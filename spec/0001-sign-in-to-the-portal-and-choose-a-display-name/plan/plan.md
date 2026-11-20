---
spec: spec/0001-sign-in-to-the-portal-and-choose-a-display-name/0001-sign-in-to-the-portal-and-choose-a-display-name.md
status: TO DO
state: approved
---

# Plan: Sign in to the portal

## Tasks

| ID | Task | Status | Blockers |
|---|---|---|---|
| [0001](0001-create-a-members-profile-and-member-id-at-the-first-sign-in.md) | Create a member's profile and member id at the first sign-in | TO DO | |
| [0002](0002-hold-a-members-session-and-refuse-requests-without-one.md) | Hold a member's session and refuse requests without one | Blocked | [0001](0001-create-a-members-profile-and-member-id-at-the-first-sign-in.md) |
| [0003](0003-start-a-sign-in-at-the-identity-provider.md) | Start a sign-in at the identity provider | Blocked | [0001](0001-create-a-members-profile-and-member-id-at-the-first-sign-in.md), [0002](0002-hold-a-members-session-and-refuse-requests-without-one.md) |
| [0004](0004-draw-the-member-layout-for-the-signed-in-member.md) | Draw the member layout for the signed-in member | Blocked | [0001](0001-create-a-members-profile-and-member-id-at-the-first-sign-in.md), [0002](0002-hold-a-members-session-and-refuse-requests-without-one.md) |
| [0005](0005-complete-the-sign-in-and-open-the-members-session.md) | Complete the sign-in and open the member's session | Blocked | [0001](0001-create-a-members-profile-and-member-id-at-the-first-sign-in.md), [0002](0002-hold-a-members-session-and-refuse-requests-without-one.md), [0003](0003-start-a-sign-in-at-the-identity-provider.md) |

## Recommendations

- **One Alembic revision for the spec.** The spec's
  [Rollout](../0001-sign-in-to-the-portal-and-choose-a-display-name.md#rollout) asks for one
  revision creating the schema `accounts` with its tables, and the
  [contracts report](../contracts-report.md#findings) (finding F13, three staged pairs) lets the
  promoting task fold the three pairs into it. The first task promotes all three, so the tasks
  after it find their tables in place.
- **Ship with the display-name spec.** The
  [Rollout](../0001-sign-in-to-the-portal-and-choose-a-display-name.md#rollout) releases this spec
  together with [spec 0005](../../0005-choose-a-display-name/0005-choose-a-display-name.md)
  (choose a display name), since this plan alone lets a member with no display name reach a member
  screen. A plan can finish and merge on its own; the release waits for both.
- **Three tasks share the API's entry point.** The second, third and fourth tasks each register
  routes in `src/portal/main.py`; all three name the API block on their Modules line, so stage 04
  runs them one after another.
- **Unit tests run with no database.** The spec's
  [Tests and local stand-ins](../0001-sign-in-to-the-portal-and-choose-a-display-name.md#tests-and-local-stand-ins)
  fakes Accounts and the session store behind their interfaces in the unit suite, and keeps the
  database cases under `tests/integration`, run with the compose stack's PostgreSQL up. Stage 05's
  functional tests create confirmed test members with a first and a last name, as the same section
  says.
- **No secret reaches a log line.** Every task that logs follows the
  [logging](../../../arch/08-crosscutting-concepts/logging.md) concept's never-recorded list: no
  token, code, state, PKCE verifier or session id.
- **Two contract findings stay outside this plan.** The
  [contracts report](../contracts-report.md#findings) deferred F2 (a provider error response on
  the callback with no `code`) and F4b (who renders a problem response to a browser navigation) to
  the spec's next amendment; no task here builds either.
