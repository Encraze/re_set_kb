---
plan: spec/0001-sign-in-to-the-portal-and-choose-a-display-name/plan/plan.md
context: M
---

# Draw the member layout for the signed-in member

Status: Blocked
Blockers: [0001](0001-create-a-members-profile-and-member-id-at-the-first-sign-in.md) (the profile and member id, whose read operation the route calls), [0002](0002-hold-a-members-session-and-refuse-requests-without-one.md) (the session and the request filter the route sits behind)
Modules: API, Web client
Surface: backend, web

A member who opens `/account` either is sent to sign in or sees the member layout. The API block
gains `GET /api/members/me`, behind the request filter, answering the member's display name and
member id from Accounts' read operation. The Web client gains its one API client, which fetches
the state-change token once per page load, sends it on every write, sends the browser to sign in
on a 401 and turns any other problem into a readable message with the correlation id; and the
member layout with the wordmark, which reads the member before it draws anything about them.
Here `/account` is that layout around an empty page: what Your account shows belongs to
[spec 0004](../../0004-your-account-and-the-member-id/0004-your-account-and-the-member-id.md)
(your account and the member id), as the spec's
[Web client](../0001-sign-in-to-the-portal-and-choose-a-display-name.md#the-web-client) section
places it.

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

> The Web client asks who is signed in before it draws a member screen,
> and either sends the browser to sign in or draws the screen.
>
> — [0001-sign-in-to-the-portal-and-choose-a-display-name.md](../0001-sign-in-to-the-portal-and-choose-a-display-name.md) §Approach, abridged

> The route this spec adds behind the filter is `GET /api/members/me`, answering `displayName`, empty
> until the member sets one, and `memberId`, with `Cache-Control: no-store`.
>
> — [0001-sign-in-to-the-portal-and-choose-a-display-name.md](../0001-sign-in-to-the-portal-and-choose-a-display-name.md) §The request filter, abridged

> One API client makes every call on the portal's origin. It fetches the state-change token once
> per page load and sends it on every write. On a 401 it sends the browser to
> `/api/sign-in?return=` with the current path; any other problem becomes a readable message with
> the correlation id. The API types are regenerated from the OpenAPI document.
>
> `/account`, Your account, sits inside a member layout whose header carries the wordmark;
>
> The layout reads `GET /api/members/me` before
> it draws anything about the member. Vue's escaping shows every value the API answers; no template
> uses `v-html`.
>
> — [0001-sign-in-to-the-portal-and-choose-a-display-name.md](../0001-sign-in-to-the-portal-and-choose-a-display-name.md) §The Web client, abridged

> Vitest: the API client's 401 handling and
>   its readable message, and the layout drawing nothing about the member before the read answers.
>
> — [0001-sign-in-to-the-portal-and-choose-a-display-name.md](../0001-sign-in-to-the-portal-and-choose-a-display-name.md) §Tests and local stand-ins, abridged

> Responsible for what the member sees and does in the browser: the screens, the navigation between
> them, and the forms that send a change. It holds no business rule and no token; every figure it
> shows is what the API answered when the screen loaded.
>
> - Offers: the portal's screens, in desktop and phone browsers.
> - Uses: the API.
>
> — [05-building-block-view.md](../../../arch/05-building-block-view.md) §Web client, verbatim

> - The Web client turns a problem response into a readable message that says what the member can
>   do next and shows the correlation id.
>
> — [error-handling.md](../../../arch/08-crosscutting-concepts/error-handling.md) §Error handling, abridged

> **Output is escaped by the Web client.** Vue escapes every value a screen shows, so member-written
> text appears escaped everywhere; no screen inserts raw HTML from a member.
>
> — [input-validation.md](../../../arch/08-crosscutting-concepts/input-validation.md) §Input validation, abridged

## Interfaces

The API client also calls `getSession` for the state-change token, quoted in
[task 0002](0002-hold-a-members-session-and-refuse-requests-without-one.md) (the session and the
request filter).

> ```yaml
>     get:
>       operationId: getCurrentMember
>       summary: Read the signed-in member
>       description: Callable by a member with a live session. The member layout reads it before it draws anything about the member.
>       responses:
>         "200":
>           description: The member's display name, empty until set, and member id.
>           headers:
>             Cache-Control:
>                 const: no-store
>                 $ref: "#/components/schemas/Member"
>         "401":
>           description: No live session.
> ```
>
> — [openapi.yaml](../contracts/openapi.yaml) §getCurrentMember, abridged

## Data

No data change.

## Screens

No screen.

## Edge cases

| Case | Behaviour |
|---|---|
| `GET /api/members/me` or `GET /api/session` with no live session | 401 `signed-out`; the client sends the browser to `/api/sign-in?return=` with the current path |
| The member has no display name yet | 200 with `displayName` empty and the member id |
| Any problem response other than 401 | a readable message showing the problem's correlation id |
| The page before `GET /api/members/me` answers | the layout shows the wordmark and nothing about the member |
| A value from the API holding HTML | shown escaped as text |
| A write sent by the client | it carries `X-State-Token` with the token fetched once for the page load |

## Subtasks

- Backend: GET /api/members/me reading the member through Accounts' interface, answering the
  display name and member id with no-store caching, in src/portal/api/members.py, registered in
  src/portal/main.py; its answer and its 401 in tests/unit/api/test_members.py.
- Web: the API types regenerated from the OpenAPI document into web/src/api/schema.d.ts.
- Web: the API client in web/src/api/client.ts: calls on the portal's origin, the state-change
  token fetched once per page load and sent in X-State-Token on writes, a 401 sending the browser
  to sign in with the current path, any other problem turned into a readable message with the
  correlation id; its tests in web/src/api/client.spec.ts.
- Web: the member layout with the wordmark in web/src/layouts/MemberLayout.vue, reading the
  member before it draws anything about them, with no v-html; its tests in
  web/src/layouts/MemberLayout.spec.ts.
- Web: the route for Your account in web/src/router.ts, drawing web/src/views/AccountView.vue
  inside the member layout.

## Done when

`tests/unit/api/test_members.py` proves `GET /api/members/me` answers `displayName` and
`memberId` with `Cache-Control: no-store` for a live session and a 401 `signed-out` without one,
`web/src/api/client.spec.ts` proves a 401 sends the browser to `/api/sign-in?return=` with the
current path, another problem becomes a readable message with its correlation id, and a write
carries the token fetched once, and `web/src/layouts/MemberLayout.spec.ts` proves the layout draws
nothing about the member before `getCurrentMember` answers.

## External factors

None: the Web client and the API run on the compose stack the skeleton provides.

## Questions
