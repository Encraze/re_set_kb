---
plan: spec/0001-sign-in-to-the-portal-and-choose-a-display-name/plan/plan.md
context: M
---

# Start a sign-in at the identity provider

Status: Blocked
Blockers: [0001](0001-create-a-members-profile-and-member-id-at-the-first-sign-in.md) (the profile and member id, whose revision creates the sign-in attempt table), [0002](0002-hold-a-members-session-and-refuse-requests-without-one.md) (the session and the request filter, whose handler answers the 503)
Modules: API
Surface: backend

`GET /api/sign-in` takes a browser to the identity provider: the API block checks the return
path, stores a sign-in attempt with a random state, a nonce and a PKCE verifier, sets the sign-in
cookie and redirects to the provider's authorisation endpoint, which it reads from the provider's
metadata. The task adds Authlib and httpx, the provider's settings and the metadata and key fetch.
Accepting the provider's answer is
[task 0005](0005-complete-the-sign-in-and-open-the-members-session.md) (complete the sign-in).

## Acceptance criteria

- [AC-0001-4](../../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) "Given a confirmed account, When its holder signs in with the right e-mail address and password, Then they are signed in."
  Every task of this plan carries it:
  [task 0001](0001-create-a-members-profile-and-member-id-at-the-first-sign-in.md) (the profile and member id),
  [task 0002](0002-hold-a-members-session-and-refuse-requests-without-one.md) (the session and the request filter),
  [task 0003](0003-start-a-sign-in-at-the-identity-provider.md) (starting a sign-in),
  [task 0004](0004-draw-the-member-layout-for-the-signed-in-member.md) (the member layout) and
  [task 0005](0005-complete-the-sign-in-and-open-the-members-session.md) (the callback). The spec answers it in
  [Sign-in and the session](../0001-sign-in-to-the-portal-and-choose-a-display-name.md#sign-in-and-the-session),
  and [spec 0002](../../0002-account-pages-at-the-identity-provider/0002-account-pages-at-the-identity-provider.md)
  (account pages at the identity provider) answers it for the provider's own pages.

## Context

> - `GET /api/sign-in?return=<path>` keeps the return path when it is portal-relative: it starts
>   with one `/` followed by neither `/` nor `\`, and does not start with `/api/`, `/realms/` or
>   `/resources/`. Any other value
>   becomes `/account`, Your account. The route stores a sign-in attempt holding a random state, a
>   nonce, a PKCE verifier and the return path, valid for 30 minutes, sets a `__Host-portal-sign-in`
>   cookie carrying the state for the same time, and redirects to the provider's authorisation
>   endpoint with PKCE S256 and the scope `openid` alone.
> - The provider's metadata and keys are fetched from its private URL with a 5-second timeout and
>   cached in the process;
>   Settings name the portal's public URL, the provider's public and private URLs and the client id.
>
> — [0001-sign-in-to-the-portal-and-choose-a-display-name.md](../0001-sign-in-to-the-portal-and-choose-a-display-name.md) §Sign-in and the session, abridged

> | Case | What the system does | What the member sees |
> |---|---|---|
> | Provider unreachable or slower than 5 seconds | no session, 503 problem response; open sessions keep working | sign-in is unavailable, try again shortly |
>
> — [0001-sign-in-to-the-portal-and-choose-a-display-name.md](../0001-sign-in-to-the-portal-and-choose-a-display-name.md) §Failure paths, abridged

> A client can
> call `GET /api/sign-in` at any rate, and each call stores a sign-in attempt that stays until it
> expires or the next session's creation deletes it.
>
> — [0001-sign-in-to-the-portal-and-choose-a-display-name.md](../0001-sign-in-to-the-portal-and-choose-a-display-name.md) §Security, abridged

> Authlib and httpx become runtime dependencies.
>
> — [0001-sign-in-to-the-portal-and-choose-a-display-name.md](../0001-sign-in-to-the-portal-and-choose-a-display-name.md) §Rollout, abridged

> The portal never receives a password. The API block is the OpenID Connect client: to sign in, the
> Web client hands the browser to the API block, which sends it to the provider and receives it
> back.
>
> — [authentication-and-authorisation.md](../../../arch/08-crosscutting-concepts/authentication-and-authorisation.md) §Sign-in, abridged

> **Shape is checked at the API block, once.** Each request binds to a model that lists the fields
> it accepts, with type, length, range and format, and anything else is refused.
>
> — [input-validation.md](../../../arch/08-crosscutting-concepts/input-validation.md) §Input validation, abridged

## Interfaces

> ```yaml
>     get:
>       operationId: startSignIn
>       summary: Start a sign-in at the identity provider
>       description: Stores a sign-in attempt, sets the sign-in cookie and redirects to the provider's authorisation endpoint. Public, no session needed.
>       security: []
>       parameters:
>         - name: return
>           in: query
>           required: false
>           description: The portal-relative path to return to. Any other value becomes /account.
>           schema:
>             type: string
>       responses:
>         "302":
>           headers:
>             Location:
>               schema:
>                 type: string
>             Set-Cookie:
>               schema:
>                 type: string
>         "503":
>           description: The provider is unreachable or slower than 5 seconds; sign-in is unavailable.
>           content:
>             application/problem+json:
>               schema:
>                 $ref: "#/components/schemas/Problem"
> ```
>
> — [openapi.yaml](../contracts/openapi.yaml) §startSignIn, abridged

## Data

> | Field | Type | Required | Constraints | Meaning |
> |---|---|---|---|---|
> | state | string (random) | yes | primary key | derived: the callback "names a live attempt" by the state its response carries |
> | nonce | string | yes | | checked against the ID token's nonce |
> | pkceVerifier | string | yes | | the PKCE verifier, which never leaves the API block; column `pkce_verifier` |
> | returnPath | string | yes | portal-relative; `/account` where the requested value fails the check | derived: "the return path"; the path the browser is redirected to after sign-in; column `return_path` |
> | createdAt | timestamp UTC | yes | | derived: "valid for 30 minutes"; the expiry is 30 minutes after it; column `created_at` |
>
> — [data-model.md](../data-model.md) §SignInAttempt, abridged

> | SignInAttempt.state, nonce, pkceVerifier | sign-in credentials, never in a log line; the table names no class for them | 30 minutes, or until the callback uses the attempt |
>
> — [data-model.md](../data-model.md) §Sensitive data, abridged

## Screens

No screen.

## Edge cases

| Case | Behaviour |
|---|---|
| `return` absent, absolute (`https://...`), protocol-relative (`//host`), starting `/\`, or under `/api/`, `/realms/` or `/resources/` | the attempt stores `/account` as its return path |
| `return` a portal-relative path such as `/account` | the attempt stores it unchanged |
| The provider's metadata cannot be fetched, or takes longer than 5 seconds | 503 problem response, no attempt stored, no cookie set |
| Metadata already fetched by this process | the redirect is answered without calling the provider |
| Many calls from one client | each stores its own attempt and answers its own redirect |

## Subtasks

- Backend: Authlib and httpx as runtime dependencies in pyproject.toml and uv.lock.
- Backend: the provider's public and private URLs and the portal client's id among the settings
  in src/portal/config.py.
- Backend: the provider client in src/portal/api/oidc.py, fetching the metadata and keys from the
  private URL with a 5-second timeout and caching them in the process, and building the
  authorisation URL with PKCE S256 and the scope openid.
- Backend: the sign-in attempt store over the sign-in attempt table in
  src/portal/api/sign_in_attempts.py, storing an attempt with its state, nonce, PKCE verifier,
  return path and creation time.
- Backend: GET /api/sign-in with the return-path check, the attempt, the sign-in cookie valid for
  30 minutes and the redirect, in src/portal/api/sign_in.py, registered in src/portal/main.py.
- Tests: the return-path check in tests/unit/api/test_return_path.py; the redirect, its PKCE and
  scope parameters, the cookie and the 503 with the provider faked in
  tests/unit/api/test_start_sign_in.py.

## Done when

`tests/unit/api/test_return_path.py` proves the check keeps a portal-relative path and turns every
other value into `/account`, and `tests/unit/api/test_start_sign_in.py` proves `GET /api/sign-in`
stores an attempt, sets `__Host-portal-sign-in` with the attempt's state and answers a 302 to the
provider's authorisation endpoint with `code_challenge_method=S256` and `scope=openid`, and
answers a 503 problem response when the provider does not answer within 5 seconds.

## External factors

None: the provider runs in the compose stack, and these tests fake it.

## Questions
