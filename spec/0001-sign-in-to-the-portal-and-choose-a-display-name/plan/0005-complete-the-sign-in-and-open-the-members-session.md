---
plan: spec/0001-sign-in-to-the-portal-and-choose-a-display-name/plan/plan.md
context: M
---

# Complete the sign-in and open the member's session

Status: Blocked
Blockers: [0001](0001-create-a-members-profile-and-member-id-at-the-first-sign-in.md) (the profile and member id, whose ensure operation the callback calls), [0002](0002-hold-a-members-session-and-refuse-requests-without-one.md) (the session store the callback opens a session in), [0003](0003-start-a-sign-in-at-the-identity-provider.md) (starting a sign-in, whose attempt and provider client the callback uses)
Modules: API
Surface: backend

`GET /api/sign-in/callback` finishes what
[task 0003](0003-start-a-sign-in-at-the-identity-provider.md) (start a sign-in) began: it accepts
the provider's answer only for a live attempt whose state matches the sign-in cookie, exchanges the
code with the PKCE verifier, checks the ID token, ends any session the browser held, has Accounts
ensure the member's profile, opens a new session and returns the browser to the return path. The
realm import gains the portal's public client, and compose gives Keycloak the back-channel
hostname, so a confirmed member can sign in end to end on the local stack.

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

> - `GET /api/sign-in/callback` accepts the response only when its state equals the cookie's and
>   names a live attempt, and deletes the attempt so it is used once. It exchanges the code with the
>   PKCE verifier over the private network, with no client secret, and Authlib checks the ID token's
>   signature against the provider's keys, its issuer (the provider's public URL), its audience (the
>   portal's client), its expiry and its nonce. The API block then ends any session the browser's
>   cookie names, calls Accounts to ensure the member's profile for the token's subject, opens a new
>   session, clears the sign-in cookie and redirects to the return path.
>
> Creating a session also deletes ended sessions and expired attempts.
>
> the keys are fetched again once when a token names an unknown key.
>
> - The realm import declares the portal's client as a public client: it holds no secret, requires
>   PKCE with S256, and registers the callback as its redirect URI in each environment. Its default
>   client scopes are listed as `basic` alone. `basic` carries the `sub` claim, the subject the
>   profile lookup reads and sign-out's ID token hint relies on; an ID token without it has no subject.
>   The list leaves out `email` and `profile`, because Keycloak adds a client's default scopes to
>   its tokens whatever scope the request names, and the `profile` scope carries the username, here
>   the member's e-mail address.
>
> — [0001-sign-in-to-the-portal-and-choose-a-display-name.md](../0001-sign-in-to-the-portal-and-choose-a-display-name.md) §Sign-in and the session, abridged

> | Case | What the system does | What the member sees |
> |---|---|---|
> | Callback state missing from the cookie, foreign or expired | no session; with a sign-in cookie present, a fresh sign-in starts for `/account`; without one, a 400 problem response | a second pass through sign-in, or the message to open the portal again |
> | ID token fails a check | no session, a security event logged, 400 problem response | the message to open the portal again |
>
> — [0001-sign-in-to-the-portal-and-choose-a-display-name.md](../0001-sign-in-to-the-portal-and-choose-a-display-name.md) §Failure paths, abridged

> the callback against a recorded provider exchange whose token is signed by a test key, refused for a
>   wrong issuer, audience, expiry, nonce or signature.
>
> Three things are risky. The application calls Keycloak on the private network while the browser
> uses the public URL, so Keycloak runs with a dynamic back-channel hostname and the issuer is
> checked against the public URL. The `__Host-` cookies need a secure context, which Chromium grants
> `http://localhost` on the local stack. Keycloak imports the realm only when it does not exist, so
> a local stack started before this spec is recreated with its volumes.
>
> — [0001-sign-in-to-the-portal-and-choose-a-display-name.md](../0001-sign-in-to-the-portal-and-choose-a-display-name.md) §Tests and local stand-ins, abridged

> - **API to identity provider.** The back channel on the private network. The portal's client is
>   public and holds no secret: the PKCE verifier, which never leaves the API block, binds the code
>   exchange to the browser that started the sign-in. Refused: a callback whose
>   state is foreign, expired or reused, and an ID token with a wrong signature, issuer, audience,
>   expiry or nonce; each opens no session, and the unit tests prove each refusal.
>
> — [0001-sign-in-to-the-portal-and-choose-a-display-name.md](../0001-sign-in-to-the-portal-and-choose-a-display-name.md) §Security, abridged

> The API block checks the returned token's signature, issuer, audience and expiry, then opens
> a session and returns the browser to the Web client. The Web client never holds a token.
>
> — [authentication-and-authorisation.md](../../../arch/08-crosscutting-concepts/authentication-and-authorisation.md) §Sign-in, abridged

> - While Keycloak is down nobody can sign in, though sessions already open keep working until they expire.
>
> — [0004-identity-provider.md](../../../arch/09-architecture-decisions/0004-identity-provider.md) §Costs, abridged

> **Recorded as security events**: sign-in and sign-out, refused permissions, failed validation at
> volume, and every administrator action, an investor approval, a flag ruling, a reliability mark
> set or lifted, with who did it and to what.
>
> — [logging.md](../../../arch/08-crosscutting-concepts/logging.md) §Logging, abridged

## Interfaces

> ```yaml
>     get:
>       operationId: completeSignIn
>       summary: Accept the provider's response and open a session
>       security: []
>       parameters:
>         - name: state
>           in: query
>           required: false
>         - name: __Host-portal-sign-in
>           in: cookie
>           description: The sign-in cookie carrying the state the response's state is compared with.
>         - name: __Host-portal-session
>           in: cookie
>           description: The session cookie of the browser, whose session the route ends before it opens a new one.
>         - name: code
>           in: query
>           required: true
>       responses:
>         "302":
>           description: A session is open and the sign-in cookie is cleared; redirects to the return path. Also the fresh sign-in for /account when the state is missing, foreign or expired and a sign-in cookie is present.
>         "400":
>           description: The state is missing without a sign-in cookie, or the ID token fails a check. No session is opened.
>         "503":
>           description: The provider is unreachable or slower than 5 seconds. No session is opened.
> ```
>
> — [openapi.yaml](../contracts/openapi.yaml) §completeSignIn, abridged

## Data

> Session:
>
> | State | Transition | Trigger |
> |---|---|---|
> | live | opened | the callback accepts the ID token |
>
> SignInAttempt:
>
> | State | Transition | Trigger |
> |---|---|---|
> | used | live to deleted | the callback accepts the response |
> | expired | live to deleted | 30 minutes pass, deleted when a session is created |
>
> — [data-model.md](../data-model.md) §Lifecycle, abridged

> - Profile to Session: one profile, none or many sessions, joined on `subject`.
>
> — [data-model.md](../data-model.md) §Relationships, abridged

## Screens

No screen.

## Edge cases

| Case | Behaviour |
|---|---|
| State missing, foreign or expired, with the sign-in cookie present | no session; a 302 to a fresh sign-in for `/account` |
| State missing, foreign or expired, with no sign-in cookie | 400 problem response, no session |
| A state whose attempt was already used | no live attempt is found, and the case above applies |
| ID token with a wrong signature, issuer, audience, expiry or nonce | 400 problem response, no session, a security event logged |
| ID token naming a key the cached keys lack | the keys are fetched again once before the signature is checked |
| Provider unreachable or slower than 5 seconds at the code exchange | 503 problem response, no session; sessions already open keep working |
| The browser already holds a session cookie | that session ends before the new one opens |
| The subject's first sign-in | Accounts creates the profile with its member id, and the session opens |
| Any log line the callback writes | it holds no token, code, state or session id |

## Subtasks

- Backend: the code exchange with the PKCE verifier and no client secret, the ID token's checks of
  signature, issuer, audience, expiry and nonce, and the one refetch of the keys for an unknown
  key, in src/portal/api/oidc.py.
- Backend: taking a live attempt by its state and deleting it, and deleting expired attempts when
  a session opens, in src/portal/api/sign_in_attempts.py.
- Backend: GET /api/sign-in/callback in src/portal/api/sign_in.py: the state check against the
  cookie, the failure answers, the security events, ending the browser's old session, ensuring the
  profile through Accounts' interface, opening the session, clearing the sign-in cookie and
  redirecting to the return path.
- Infrastructure: the portal's public client in deploy/keycloak/portal-realm.json, with PKCE S256,
  the callback as its redirect URI and basic alone among its default client scopes; Keycloak's
  dynamic back-channel hostname and the application's provider settings in compose.yaml.
- Tests: the test signing key and the recorded provider exchange in tests/unit/api/conftest.py and
  tests/unit/api/provider_exchange.json; the callback's success and every refusal in
  tests/unit/api/test_complete_sign_in.py.

## Done when

`tests/unit/api/test_complete_sign_in.py`, against a recorded provider exchange whose token a test
key signs, proves the callback opens a session, ensures the profile, clears the sign-in cookie and
redirects to the return path; refuses a wrong issuer, audience, expiry, nonce or signature with a
400 and no session; answers a missing or foreign state with a fresh sign-in when the sign-in cookie
is present and a 400 when it is not; and answers a 503 when the provider does not answer within 5
seconds.

## External factors

| Factor | Estimate | Given by | Source |
|---|---|---|---|
| The portal client, with its default client scopes, added to the production realm through the provider's admin console | not stated | assumed | [Rollout](../0001-sign-in-to-the-portal-and-choose-a-display-name.md#rollout) |
| Keycloak's back-channel hostname option and the new settings set on the production host | not stated | assumed | [Rollout](../0001-sign-in-to-the-portal-and-choose-a-display-name.md#rollout) |

## Questions
