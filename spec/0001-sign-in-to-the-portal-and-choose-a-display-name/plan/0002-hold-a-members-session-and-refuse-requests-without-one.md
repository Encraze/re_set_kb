---
plan: spec/0001-sign-in-to-the-portal-and-choose-a-display-name/plan/plan.md
context: M
---

# Hold a member's session and refuse requests without one

Status: Blocked
Blockers: [0001](0001-create-a-members-profile-and-member-id-at-the-first-sign-in.md) (the profile and member id, whose revision creates the session table)
Modules: API
Surface: backend

The API block gains the session store over the `accounts.session` table, the request filter that
answers 401 `signed-out` with no live session and 403 `state-token-invalid` for a write without a
matching state-change token or from a foreign origin, the one error handler that answers every
error as a problem response with its correlation id, and `GET /api/session`, which hands the Web
client the session's state-change token. Opening a session from a sign-in is the callback's, in
[task 0005](0005-complete-the-sign-in-and-open-the-members-session.md) (complete the sign-in); this
task gives it the store's open operation and proves it with sessions the tests create.

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

> - A session id is 32 bytes from Python's `secrets`, sent in the cookie `__Host-portal-session`
>   with the attributes the sign-in concept sets and no expiry of its own, and stored only as its
>   SHA-256 hash. The row holds the subject, the state-change token (32 bytes from `secrets`), the
>   creation time and the last-seen time. A session ends 30 minutes after its last request or 10
>   hours after it opened; the last-seen time is written at most once a minute; an ended session
>   counts as none and its row is deleted when met. Creating a session also deletes ended sessions
>   and expired attempts.
> - `GET /api/session` answers the session's state-change token, with `Cache-Control: no-store`.
>   Every `POST`, `PUT`, `PATCH` and `DELETE` under `/api` carries it in `X-State-Token`, and the
>   API block compares it in constant time, and the `Origin` header with the portal's public origin,
>   before any route runs.
>
> — [0001-sign-in-to-the-portal-and-choose-a-display-name.md](../0001-sign-in-to-the-portal-and-choose-a-display-name.md) §Sign-in and the session, abridged

> Every route under `/api` except health, `GET /api/sign-in` and the callback runs two checks in
> order:
>
> 1. No live session: 401 problem response of type `signed-out`.
> 2. A write without a matching state-change token or with a foreign origin: 403 of type
>    `state-token-invalid`, and nothing changes.
>
> — [0001-sign-in-to-the-portal-and-choose-a-display-name.md](../0001-sign-in-to-the-portal-and-choose-a-display-name.md) §The request filter, abridged

> | Case | What the system does | What the member sees |
> |---|---|---|
> | Signed out, or the session ended | 401 from the filter | the provider's sign-in page, then the screen they opened |
> | Write without the token, or from a foreign origin | 403, nothing changed | the generic message with the correlation id |
>
> Sign-in and its failures, a refused state-change token and a refused callback are security events
>
> No log line carries a token, a code, a state or a session id.
>
> — [0001-sign-in-to-the-portal-and-choose-a-display-name.md](../0001-sign-in-to-the-portal-and-choose-a-display-name.md) §Failure paths, abridged

> - Unit, pytest with no database: the member id's format and
>   alphabet; the return-path check; the filter's two answers and the token comparison through
>   FastAPI's test client, with Accounts and the session store faked behind their interfaces;
>
> — [0001-sign-in-to-the-portal-and-choose-a-display-name.md](../0001-sign-in-to-the-portal-and-choose-a-display-name.md) §Tests and local stand-ins, abridged

> Responsible for everything that faces the Web client: the HTTP routes, the shape of each request
> and answer, the signed-in session and the sign-in with the identity provider, and the mapping of
> every error to a problem response. It decides nothing about the domain; it asks the modules and
> returns what they answer.
>
> - Offers: JSON over HTTPS, described by an OpenAPI document; the sign-in and sign-out of a member.
> - Uses: every module's public interface; the identity provider for sign-in.
>
> — [05-building-block-view.md](../../../arch/05-building-block-view.md) §API, verbatim

> Session
> state lives in PostgreSQL; the browser holds only a random session id in a cookie marked
> `HttpOnly`, `Secure` and `SameSite=Lax`, with the `__Host-` prefix.
>
> — [authentication-and-authorisation.md](../../../arch/08-crosscutting-concepts/authentication-and-authorisation.md) §Sign-in, abridged

> Every request that changes state carries, in a header, a token bound to the session, which the
> API block hands the Web client with the session. The API block compares it, and the request's
> origin, with the session before the module sees the request; the `SameSite` cookie is a second
> guard behind that check.
>
> — [authentication-and-authorisation.md](../../../arch/08-crosscutting-concepts/authentication-and-authorisation.md) §Who may do what, abridged

> One handler in the API block maps every error to a response, so no route catches errors on its
> own:
>
> - Every error is answered with a problem details body as RFC 9457 defines it, with a type, a
>   title, the status and the correlation id.
> - An unexpected error is logged once, with its stack trace and the correlation id, and answered
>   with a generic 500 that reveals nothing of the inside: no trace, query, path or version.
>
> — [error-handling.md](../../../arch/08-crosscutting-concepts/error-handling.md) §Error handling, abridged

> **The correlation id** is taken from the reverse proxy's request header, or generated at the API
> block where none arrives, and passed into every module call and log line of the request. It is
> shown with every error message the Web client displays, so a member can quote it.
>
> **Never recorded**: passwords, tokens, cookies and session ids, secret values, contact data, and
> individual pledge amounts.
>
> — [logging.md](../../../arch/08-crosscutting-concepts/logging.md) §Logging, abridged

## Interfaces

> ```yaml
>     get:
>       operationId: getSession
>       summary: Read the session's state-change token
>       description: Callable by a member with a live session. The token goes in X-State-Token on every write.
>       security:
>         - sessionCookie: []
>       responses:
>         "200":
>           description: The session's state-change token.
>           headers:
>             Cache-Control:
>               schema:
>                 type: string
>                 const: no-store
>           content:
>             application/json:
>               schema:
>                 $ref: "#/components/schemas/Session"
>         "401":
>           description: No live session.
>           content:
>             application/problem+json:
>               schema:
>                 $ref: "#/components/schemas/Problem"
> ```
>
> — [openapi.yaml](../contracts/openapi.yaml) §getSession, abridged

Every operation of the contract also answers a 500 problem response for an unexpected error,
which the handler this task builds gives.

## Data

> | Field | Type | Required | Constraints | Meaning |
> |---|---|---|---|---|
> | sessionHash | string, 64 characters, lower-case hex of the SHA-256 hash | yes | primary key | derived: "stored only as its SHA-256 hash"; the session id itself is never stored; column `session_hash` |
> | subject | string | yes | | the provider's subject of the signed-in member |
> | stateToken | string (32 random bytes) | yes | | the state-change token answered by `GET /api/session`; column `state_token` |
> | createdAt | timestamp UTC | yes | | derived: "the creation time"; the session ends 10 hours after it; column `created_at` |
> | lastSeenAt | timestamp UTC | yes | written at most once a minute | derived: "the last-seen time"; the session ends 30 minutes after it; column `last_seen_at` |
>
> — [data-model.md](../data-model.md) §Session, abridged

> Session:
>
> | State | Transition | Trigger |
> |---|---|---|
> | ended | live to ended | idle for 30 minutes (`lastSeenAt`), or open for 10 hours (`createdAt`) |
> | deleted | ended to deleted | the ended session is met, or a session is created |
>
> — [data-model.md](../data-model.md) §Lifecycle, abridged

> | Session | `sessionHash`, primary key | resolving the session the cookie names on every request |
>
> — [data-model.md](../data-model.md) §Indexes, abridged

## Screens

No screen.

## Edge cases

| Case | Behaviour |
|---|---|
| A request under `/api` with no session cookie, or a cookie naming no session | 401 problem response of type `signed-out` |
| A session idle for 30 minutes, or opened 10 hours ago | 401 `signed-out`, and the session's row is gone afterwards |
| A write with no `X-State-Token`, a token that differs from the session's, or an `Origin` other than the portal's public origin | 403 problem response of type `state-token-invalid`, no route runs, nothing changes, and a security event is logged with no token in it |
| A read (`GET`) with a live session and no `X-State-Token` | the route runs |
| A request to health, `GET /api/sign-in` or the callback with no session | the filter does not run, and the route answers |
| Two requests in the same minute on one session | the last-seen time is written once |
| An unexpected error in a route | a generic 500 problem response carrying the correlation id and nothing of the inside |

## Subtasks

- Backend: the portal's public URL among the settings, read by the origin check, in
  src/portal/config.py.
- Backend: the session store in src/portal/api/sessions.py, opening a session with a 32-byte id
  from `secrets` stored as its SHA-256 hash and a 32-byte state-change token, deleting ended
  sessions when it opens one, resolving the session a cookie names with the 30-minute idle and
  10-hour absolute ends, writing the last-seen time at most once a minute, and ending a session.
- Backend: the error handler and problem responses with the correlation id, from the proxy's
  header or generated, in src/portal/api/problems.py.
- Backend: the request filter, its two checks in order, the constant-time token comparison and
  the origin check, logging a refused token as a security event, in
  src/portal/api/request_filter.py.
- Backend: GET /api/session answering the state-change token with no-store caching in
  src/portal/api/session_routes.py, registered with the filter and the handler in
  src/portal/main.py.
- Tests: the filter's two answers and the token comparison with the session store faked, in
  tests/unit/api/test_request_filter.py; the session route's answer and its 401 in
  tests/unit/api/test_session_routes.py; session expiry and the cleanup of ended sessions against
  PostgreSQL in tests/integration/api/test_session_expiry.py.

## Done when

`tests/unit/api/test_request_filter.py` proves a 401 `signed-out` with no live session and a 403
`state-token-invalid` for a write with a missing or wrong token or a foreign origin, with a read
passing untouched, `tests/unit/api/test_session_routes.py` proves `GET /api/session` answers the
token with `Cache-Control: no-store`, and `tests/integration/api/test_session_expiry.py` proves a
session ends after 30 idle minutes and after 10 hours and its row is deleted.

## External factors

None: the task runs against the compose stack's PostgreSQL, which the skeleton provides.

## Questions
