---
title: Your account and the member id
step: 2
prd: [prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md]
arc42: [05-building-block-view.md, 08-crosscutting-concepts/authentication-and-authorisation.md, 08-crosscutting-concepts/data-classification.md, 08-crosscutting-concepts/input-validation.md, 08-crosscutting-concepts/error-handling.md]
size: M
route: standard
reworks:
state: approved
---

# Your account and the member id

## Scope

This spec builds Your account as a member first finds it, with their display name in the header
and their member id on the page. It answers three criteria of
[PRD 0001](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md) (the
PRD for member accounts), the PRD of [step 2](../../roadmap/roadmap.md#steps) (where members first
get accounts). It builds on
[spec 0001](../0001-sign-in-to-the-portal-and-choose-a-display-name/0001-sign-in-to-the-portal-and-choose-a-display-name.md)
(sign in to the portal), named the sign-in spec from here on, for the session, the request
filter, `GET /api/members/me`, the member layout, the Web client's API client and the member id
Accounts generates. It builds on
[spec 0005](../0005-choose-a-display-name/0005-choose-a-display-name.md) (choose a display name)
for the display-name prompt and the filter's check that opens it.

In scope:

- Your account's page content in its default state, and the display name in the member layout's
  header.

Out of scope:

- The Display name section of Your account with its field and save, and the header's Sign out:
  [spec 0003](../0003-change-the-display-name-and-sign-out/0003-change-the-display-name-and-sign-out.md)
  (change the display name and sign out).
- The route and the Accounts operations Your account reads through: the sign-in spec builds them
  and this spec uses them unchanged.
- The display-name prompt:
  [spec 0005](../0005-choose-a-display-name/0005-choose-a-display-name.md#the-prompt) builds it
  and this spec uses it unchanged.
- Showing a display name or member id to other members, which the PRD leaves to later steps.

## Approach

Your account needs nothing new from the API or from Accounts. The answer of `GET /api/members/me`,
which the sign-in spec's
[request filter](../0001-sign-in-to-the-portal-and-choose-a-display-name/0001-sign-in-to-the-portal-and-choose-a-display-name.md#the-request-filter)
section adds, already carries the display name and the member id, and the member layout already
reads it before drawing anything about the member; this spec draws what it reads.

One block of the [building block view](../../arch/05-building-block-view.md) changes: the
[Web client](../../arch/05-building-block-view.md#web-client) gains Your account's content and the
header's name. The [API](../../arch/05-building-block-view.md#api) and
[Accounts](../../arch/05-building-block-view.md#accounts) are used as the sign-in spec and
[spec 0005](../0005-choose-a-display-name/0005-choose-a-display-name.md) (choose a display name)
leave them.

### Your account

- The member layout's header shows the display name from the layout's read, at the header's right
  end, so every screen inside the layout carries it. Your account at `/account` draws the
  [SCR-4](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md#scr-4-your-account)
  default state from the same read: the heading, its line and the Member id section with the id
  as Accounts holds it.
- Nothing about the member is drawn before the read answers 200. A 401 takes the sign-in spec's
  [Web client](../0001-sign-in-to-the-portal-and-choose-a-display-name/0001-sign-in-to-the-portal-and-choose-a-display-name.md#the-web-client)
  path to sign in with `/account` as the return path, and `registration-incomplete` opens
  [spec 0005's prompt](../0005-choose-a-display-name/0005-choose-a-display-name.md#the-prompt);
  once the prompt saves, the layout reads again and draws the name and the page.
- The page shows the member id the sign-in spec's
  [profile and member id](../0001-sign-in-to-the-portal-and-choose-a-display-name/0001-sign-in-to-the-portal-and-choose-a-display-name.md#profile-and-member-id)
  section generates, to
  [PRD 0001, requirement 9](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements)
  (member id). Spec 0005's
  [display-name rule](../0005-choose-a-display-name/0005-choose-a-display-name.md#the-display-name-rule)
  never compares a name with other members' names, so two members who both chose "Alex" each see
  their own id.
- Both values are shown through Vue's escaping, as text.

### Failure paths

| Case | What the system does | What the member sees |
|---|---|---|
| Your account opened signed out, or after the session ended | 401 from the filter, nothing about the member drawn | the provider's sign-in page, then Your account |
| Your account opened before a display name is set | 403 `registration-incomplete` | [spec 0005's prompt](../0005-choose-a-display-name/0005-choose-a-display-name.md#the-prompt), then Your account with the name |
| The read fails with any other problem | the problem response | the readable message with the correlation id, and no member details |

### Tests and local stand-ins

- Unit, Vitest: the header and Your account drawing the name and the id from the read, nothing of
  the member drawn before it answers, and the readable message on a problem.
- Functional, stage 05's: a browser test per criterion above, run against the same stack and test
  members as the sign-in spec's functional tests.

### Rollout

No flag: Your account ships with the release. No migration, no new dependency and no change
outside the code. A rollback runs the previous version, which leaves Your account's content empty.

## Acceptance criteria answered

### [Member accounts and display names](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md)

The step's PRD: accounts, sign-in and the display name.

- [`AC-0001-9`](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria):
  "Given another member already uses the display name "Alex", When a member sets "Alex", Then it is
  saved, the two accounts keep different member ids, and a member's id, as shown on their own
  screens, contains no part of their e-mail address." Answered in [Your account](#your-account),
  the member id and the rule.
- [`AC-0001-12`](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria):
  "Given a signed-out visitor, When they open the screen for changing a display name, Then they are
  sent to sign in and see no member's details." Answered in [Your account](#your-account), nothing
  drawn before the read and the 401 path;
  [spec 0003](../0003-change-the-display-name-and-sign-out/0003-change-the-display-name-and-sign-out.md#acceptance-criteria-answered)
  (change the display name and sign out) keeps it.
- [`AC-0001-13`](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria):
  "Given a signed-in member with a display name, When they open any of their own screens, Then the
  screen shows that display name." Answered in [Your account](#your-account), the header;
  [spec 0003](../0003-change-the-display-name-and-sign-out/0003-change-the-display-name-and-sign-out.md#acceptance-criteria-answered)
  (change the display name and sign out) keeps it.

## Screens

- [`SCR-4`](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md#scr-4-your-account):
  default, with the display name in the header and the Member id section.

## Interfaces

No interface change.

## Data

No data change.

## Security

- **Browser to API.** No new boundary: Your account reads behind the session and the filter the
  [sign-in](../../arch/08-crosscutting-concepts/authentication-and-authorisation.md#sign-in)
  concept places. Refused: Your account opened with no live session, under
  [AC-0001-12](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria)
  (signed-out visitors see no member's details).
- **Data.** No new class and no new place: Your account shows a member their own display name and
  member id, both of the Profile class in
  [data classification](../../arch/08-crosscutting-concepts/data-classification.md) (where each
  class of data lives and who may read it).
- **Accepted gap.** The portal builds no rate limit per client on sign-in, sign-up or a form that
  writes, which the [input validation](../../arch/08-crosscutting-concepts/input-validation.md)
  concept's line on rates asks for. A client can send sign-ins and writes at any rate.
