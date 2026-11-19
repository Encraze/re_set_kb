# PRD leg record: step 2, sign-up, sign-in and the display name

Step: [step 2](../../roadmap/roadmap.md#steps), accounts with a name other members see, citing the idea brief's [Problem](../../intents/0001-build-a-portal/idea-brief.md#problem), an open community anyone can sign up to, and [Users](../../intents/0001-build-a-portal/idea-brief.md#users), an owner who sees who joined

## Outcome

Approved.

## PRD

| Did | PRD | Gloss |
|---|---|---|
| created | [PRD 0001, Member accounts and display names](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md) | sign-up with e-mail confirmation, sign-in and sign-out, password recovery, a required display name and a public member id |

## Prototype

| PRD | Prototype | How |
|---|---|---|
| [PRD 0001](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md), member accounts and display names | [ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/index.html), six screens with their manifest, [screens.md](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md) | written |

## Source walk

| Item in the source | Gloss | Landed in | Gloss |
|---|---|---|---|
| [Problem](../../intents/0001-build-a-portal/idea-brief.md#problem) | no single place to see ideas; talk scattered across chats | does not bear on this step | project pages and the forum are steps 3 and 8 |
| [Problem](../../intents/0001-build-a-portal/idea-brief.md#problem) | an open public community where anyone can sign up and post an idea | [PRD 0001, Requirements](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements), requirement 1 | any signed-out visitor creates an account, tested by the first criterion; posting an idea is step 3 |
| [Problem](../../intents/0001-build-a-portal/idea-brief.md#problem) | an owner needs a page showing who joined, funding and stages | [PRD 0001, Requirements](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements), requirements 5 and 9 | this step gives every member a display name and a member id; showing them to others is left to steps 3, 6 and 8 under Out of scope |
| [Problem](../../intents/0001-build-a-portal/idea-brief.md#problem) | money and contracts stay offline | does not bear on this step | the step has no money or contract surface |
| [Users](../../intents/0001-build-a-portal/idea-brief.md#users) | idea owners are anyone who signs up, worldwide | [PRD 0001, Requirements](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements), requirement 1 and the quoted constraints | sign-up from any country, with no invitation and no approval |
| [Users](../../intents/0001-build-a-portal/idea-brief.md#users) | the owner sees pledge amounts and who joined in which role | [PRD 0001, Requirements](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements), requirements 5 and 9 | the name and id only; pledges are step 7, joining is step 6 |
| [Users](../../intents/0001-build-a-portal/idea-brief.md#users) | the owner concludes a pledge | does not bear on this step | step 10 |
| [Users](../../intents/0001-build-a-portal/idea-brief.md#users) | investors verified by e-mail, phone, real name, professional link and an administrator's approval, with no identity documents | [PRD 0001, Requirements](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements), requirement 2 | a confirmed e-mail address; the rest of verification is step 4, named under Out of scope, and this step stores no identity document |
| [Users](../../intents/0001-build-a-portal/idea-brief.md#users) | contributors and followers | does not bear on this step | joining in a role is step 6 |
| [Users](../../intents/0001-build-a-portal/idea-brief.md#users) | signed-in members see the totals | [PRD 0001, Requirements](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements), requirements 3 and 4 | signing in and out; the totals are steps 7 and 10 |
| [Users](../../intents/0001-build-a-portal/idea-brief.md#users) | signed-out visitors see projects, not the forum or money | [PRD 0001, Acceptance criteria](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria), the twelfth criterion | a signed-out visitor cannot change a display name; what visitors see is steps 3, 5 and 8 |
| [Users](../../intents/0001-build-a-portal/idea-brief.md#users) | administrators approve verification and rule on flags | does not bear on this step | steps 4 and 9, named under Out of scope |
| [Constraints](../../intents/0001-build-a-portal/idea-brief.md#constraints) | no financial operations and no contracts | does not bear on this step | the step has no money or contract surface |
| [Constraints](../../intents/0001-build-a-portal/idea-brief.md#constraints) | an open public community, worldwide | [PRD 0001, Requirements](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements), the quoted constraints and requirement 1 | anyone, from any country, signs up |
| [Constraints](../../intents/0001-build-a-portal/idea-brief.md#constraints) | pledge amounts only to the owner, totals to signed-in members | does not bear on this step | steps 7 and 10 |
| [Constraints](../../intents/0001-build-a-portal/idea-brief.md#constraints) | only verified investors pledge, with no identity documents | does not bear on this step | beyond the confirmed e-mail of requirement 2, step 4 |
| [Constraints](../../intents/0001-build-a-portal/idea-brief.md#constraints) | web, responsive for desktop and phone browsers | [PRD 0001, Requirements](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements), the quoted constraints | binds this step's screens |
| [Constraints](../../intents/0001-build-a-portal/idea-brief.md#constraints) | the interface is in English | [PRD 0001, Requirements](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements), the quoted constraints | binds this step's screens and messages |
| [Constraints](../../intents/0001-build-a-portal/idea-brief.md#constraints) | no budget, team size or technology fixed | does not bear on this step | the PRD names no technology |

The walk placed every item.

## Depth

`easy`, chosen by the Originator.

The PRD's write dispatch returned:

- Assumed: sign-up method = e-mail address and password only, because [ADR-0004](../../arch/09-architecture-decisions/0004-identity-provider.md#decision) (identity provider) keeps the password with the identity provider and nothing in the source asks for another service's login (that is under Out of scope).
- Assumed: e-mail confirmation = required before first sign-in, because [ADR-0004](../../arch/09-architecture-decisions/0004-identity-provider.md#decision) (identity provider) has the identity provider confirm the address and step 4's verification needs a confirmed e-mail.
- Assumed: wrong-credentials message = one message that does not say which of e-mail or password was wrong, because saying which would reveal whether an account exists.
- Assumed: display name = required at first sign-in, before any other member screen, because the step exists so other members have a name to see.
- Assumed: display name rules = 2 to 40 characters after trimming, letters of any script, no line breaks, because the community is worldwide and a criterion needs concrete limits.
- Assumed: display name uniqueness = not required, because the source asks only for a name to show, not one that identifies a person.
- Assumed: display name change = allowed at any time, and the new name shows everywhere the old one did, because nothing in the source fixes the name.
- Assumed: e-mail visibility = never shown to other members or visitors, because the display name is the name others see and the e-mail is contact data.
- Assumed: password recovery by e-mail link = Should have in this step, because [ADR-0004](../../arch/09-architecture-decisions/0004-identity-provider.md#decision) (identity provider) already has the identity provider send recovery mail and a lost password would otherwise lock a member out.
- Assumed: account deletion = out of scope, because nothing a member creates in this step would be lost.
- Assumed: profile fields beyond the display name, such as a photo or biography = out of scope, because the source asks only for a name.
- Assumed: administrator role and investor verification details = out of scope, because roadmap steps 4 and 9 cover them.

The Originator's answer: "Keep all".

The apply of the round 1 challenge returned, on the sixth finding of [Round 1: challenge](#round-1-challenge) (the shared-name rule):

- Assumed: F6 = won't-fix, quoting the Originator's words as the reason.

The Originator did not keep that reading and gave the decision that finding's `D:` line quotes. The re-dispatch that wrote it in returned:

- Assumed: the member id does not reveal the e-mail address = true, because the id is public and [R2](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (e-mail confirmation) and [R8](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (account recovery) forbid showing whether an address has an account.
- Assumed: statuses and their marks = steps 4 and 9, because the PRD already gives the administrator role to steps 4 and 9, and the roadmap's step 4 delivers the verified investor status.

The Originator's answer: "Statuses and marks only respond the concern, so you don't have to keep them in step 2 as something to implement. Just for reference." Both stood, the statuses and marks staying under Out of scope only.

The prototype dispatch returned:

- Assumed: after sign-in, a member with a display name lands on [SCR-4](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md#scr-4-your-account) Your account, because it is the only member screen this step has, and adding a home screen would draw something no requirement states.
- Assumed: [SCR-3](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md#scr-3-choose-your-display-name) (the display-name prompt) offers a "Sign out" link but no way to close the prompt, because [R4](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (sign-out) lets a signed-in member sign out at any time and [R5](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (display name) only forbids dismissing the prompt.
- Assumed: [SCR-2](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md#scr-2-sign-in) (sign in) shows a confirmation notice after the address is confirmed and after a new password is set, because [R2](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (e-mail confirmation) and [R8](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (account recovery) imply the holder arrives at sign-in next. The PRD names neither notice as a state, so the round may raise them.
- Assumed: the wordmark reads "Portal" and the member id is drawn as "M-7Q4K9X2B", because neither the brief nor the arc42 tree names the product or the id's format. The format is left to the spec.
- Assumed: Your account does not show the member's e-mail address, and no form asks for the password twice or shows password rules, because no requirement asks for them.
- Assumed: the sign-in, sign-up and recovery screens are drawn as the portal's own pages, although [ADR-0004](../../arch/09-architecture-decisions/0004-identity-provider.md#decision) (identity provider) has Keycloak serve those flows, because the prototype draws what the user sees. Making Keycloak's pages match them is a matter for the spec.

The Originator vetoed the second line, answering: "The name prompt does not need to have a sign-out. A user can leave by closing the tab. If they're back, they're shown the name prompt again. If session is expired by that time, they sign-in and again see the name prompt. The rest is fine"

## Size and route

Size `S`, route `quick`, the step's own. The Originator holds that the step is `M`; that raise is left to the Architect at `/spec-first-sdlc:arch`, as the first finding's `D:` line records.

## Rounds

1 round of a cap of 1, the `critique.rounds.quick.prd` cell. The round's challenge, review, prototype and prototype review passes all fell within it, the passes after the challenge being decided at the cap.

### Round 1: challenge

- F: Acceptance criteria, 14 criteria against size S's range of 3 to 6, so the step is larger than its size; possible merges [AC-0001-7, 8 and 9](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) (the display-name rules) and [AC-0001-4 and 5](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) (sign-in, right and wrong password); does not block (prd-challenger, 2026-11-19)
  D: won't-fix, "the step is M; the raise goes to the Architect at /spec-first-sdlc:arch"; the criteria stay as they are, with no merges
- F: Requirements [R7](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (where the name shows) and [AC-0001-10](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) (a changed name shows), [AC-0001-13](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) (screens show the name), nothing step 2 delivers shows one member to another or to a visitor, so the second criterion has no place to be seen and the first never says where the name shows; blocks (prd-challenger, 2026-11-19)
  D: resolved, own screens only: [R6](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (changing the display name) and [R7](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (where the name shows) now place the display name on the member's own screens, [AC-0001-10](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) (a changed name shows) and [AC-0001-13](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) (screens show the name) test only those, and a line under Out of scope leaves showing the name to others to steps 3, 6 and 8
- F: Requirements [R5](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (display name) and [AC-0001-6](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) (the name prompt at sign-in), a member who dismisses the prompt or signs out without a name signs in again past the first sign-in and reaches member screens with no display name; blocks (prd-challenger, 2026-11-19)
  D: resolved, until a name is set: [R5](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (display name) and [AC-0001-6](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) (the name prompt at sign-in) now cover any signed-in member with no display name, the prompt cannot be dismissed and shows at every sign-in until a name is set
- F: Requirements [R3](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (sign-in) and [AC-0001-2](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) (unconfirmed sign-in refused), [AC-0001-3](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) (no second account for an address in use), [AC-0001-14](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) (password recovery), undecided whether the portal may reveal that an e-mail address has an account; blocks (prd-challenger, 2026-11-19)
  D: resolved, never reveal: [R2](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (e-mail confirmation) and [AC-0001-3](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) (no second account for an address in use) show a sign-up with an address in use the same message as a new one, [R8](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (account recovery) and [AC-0001-14](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) (password recovery) show recovery with an unknown address the same message, and [R3](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (sign-in) and [AC-0001-2](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) (unconfirmed sign-in refused) tell a holder to confirm first only after the right password
- F: Requirements [R6](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (changing the display name) and [AC-0001-12](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) (a visitor sent to sign in), no criterion stops a member changing another member's display name; blocks (prd-challenger, 2026-11-19)
  D: won't-fix, "There's no flow when one member can change another member's display name. No API for it, no UI for it, nothing. If there's no functionality, nothing allows it and there's nothing to stop."
- F: Problem and Requirements [R5](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (display name), the problem says an owner cannot tell members apart without a name, while two members may share one, which also lets a member take a name like "Administrator"; does not block (prd-challenger, 2026-11-19)
  D: resolved, the Originator's decision: "Name 'Administrator' does not do anything. A user status or type will be shown to others at later stages or on the personal profile screen. The real admins should have distinctive user statuses, colors etc." and "A user will have a display name and a user id which is also publicly available. So in case of a collision we will be able to tell them apart. Also avatars will be added and user statuses. So verified (by ID) critical users (like admins, investors, owners) with identical names still will have enough differences. And verification will hold them back from impostoring each other." The Problem names the member id; [R5](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (display name) says member ids tell apart two members with one name and a display name grants no role or status; [R9](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (member id) gives every account a member id other members may see; [AC-0001-9](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) (shared names keep different ids) checks the two accounts keep different ids; Out of scope places showing the id with steps 3, 6 and 8, statuses and their marks with steps 4 and 9, investor verification with step 4, and avatars, a profile screen and verifying administrators and owners with later steps the roadmap does not name yet
- F: Out of scope, the line on other services' sign-in says the source asks for e-mail and password, and it does not; the choice comes from [ADR-0004](../../arch/09-architecture-decisions/0004-identity-provider.md#decision) (identity provider); does not block (prd-challenger, 2026-11-19)
  D: resolved, the line under Out of scope now gives the reason from the identity provider decision and links that decision record's Decision section
- F: Requirements [R8](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (account recovery) and [AC-0001-14](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) (password recovery), account recovery is a Should have with a mandatory criterion; does not block (prd-challenger, 2026-11-19)
  D: resolved, [R8](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (account recovery) is now a Must have, the Should have heading is gone, and [AC-0001-14](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) (password recovery) stays

The verifying re-read that closed the round's budget returned nothing open.

### Round 1: review

- F: RV1, Requirements, the brief's constraints on a responsive web portal for desktop and phone browsers and an English interface are neither quoted nor marked as not bearing on this step, though both bear on its sign-up, sign-in and name screens and on every message the criteria name; blocks (prd-reviewer, 2026-11-19)
  D: resolved, carry both: the Requirements quote both constraints under a link to the brief's Constraints, beside the quotes on who may join, so they bind this step's screens and messages
- F: RV2, Requirements [R5](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (display name), the rule that a display name grants no role and no status has no acceptance criterion; blocks (prd-reviewer, 2026-11-19)
  D: resolved, the Originator's decision: "It should not. A name is a name. Roles and permissions are defined by a user type, status... You don't have to associate name and role in any manner, including tests. This should not even be an AC or a requirement. It's just counter-logical." [R5](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (display name) no longer states that a display name grants no role and no status, and no criterion tests it
- F: RV3, Requirements [R9](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (member id), the rule that the member id MUST NOT reveal the e-mail address has no acceptance criterion; [AC-0001-9](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) (shared names keep different ids) only checks that two ids differ; blocks (prd-reviewer, 2026-11-19)
  D: resolved, extend the ninth criterion: [AC-0001-9](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) (shared names keep different ids) now also checks the member id against the member's e-mail address; the criteria stay at 14
- F: RV4, Acceptance criteria, the refusal halves of [R1](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (sign-up), [R2](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (e-mail confirmation), [R3](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (sign-in) and [R6](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (changing the display name) are not tested: sign-up with no invitation and no approval, the confirmation link taking effect, a wrong e-mail address refused with the shared message, and an invalid name change refused; does not block (prd-reviewer, 2026-11-19)
  D: won't-fix, closed at the round cap
- F: RV5, Out of scope, the line on other services' sign-in restates the consequence on other logins of [ADR-0004](../../arch/09-architecture-decisions/0004-identity-provider.md#consequences) (identity provider) in a paraphrase, and cites the Decision for a claim the Decision does not state; does not block (prd-reviewer, 2026-11-19)
  D: won't-fix, closed at the round cap
- F: RV6, Problem, the opening retells the brief's Users sentence on owners seeing who joined instead of linking it with a gloss; does not block (prd-reviewer, 2026-11-19)
  D: won't-fix, closed at the round cap
- F: RV7, Out of scope, the id [GAP-0001](../../arch/10-quality-requirements.md#non-functional-requirements) (quality targets not set) is bare, unlinked and without a gloss, and sits outside the arc42 file that mints it; does not block (prd-reviewer, 2026-11-19)
  D: won't-fix, closed at the round cap
- F: RV8, Findings, the closure reason of the first finding of [Round 1: challenge](#round-1-challenge) (the criteria count) says the step is M, while roadmap row 2 sizes the step S; does not block (prd-reviewer, 2026-11-19)
  D: won't-fix, closed at the round cap

The verifying re-read after the apply returned nothing open.

### Round 1: prototype

- F: P1, Prototype [SCR-3](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md#scr-3-choose-your-display-name) "Choose your display name", display-name.html lines 95-108 and screens.md lines 65-68 and the Flow with no edge from it to [SCR-2](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md#scr-2-sign-in) (sign in), a signed-in member with no display name has no way to sign out, against [R4](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (sign-out); blocks (prd-challenger, 2026-11-19)
  D: won't-fix, "Until a name is provided the sign-in is considered incomplete"; this keeps the Originator's earlier answer to the vetoed assumption: "The name prompt does not need to have a sign-out. A user can leave by closing the tab. If they're back, they're shown the name prompt again. If session is expired by that time, they sign-in and again see the name prompt."
- F: P2, Requirements [R2](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (e-mail confirmation), [R8](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (account recovery) and [AC-0001-1](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) (sign-up sends a confirmation link), [AC-0001-3](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) (no second account for an address in use), [AC-0001-14](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) (password recovery), a holder whose address is not confirmed and who no longer has the confirmation link has no way back in: sign-up sends one link, recovery serves only a confirmed address and a repeated sign-up sends no new link, so the success text of [SCR-5](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md#scr-5-recover-your-account) (recover your account) is false for that holder; does not block (prd-challenger, 2026-11-19)
  D: won't-fix, closed at the round cap
- F: P3, Acceptance criteria, the success states "address confirmed" and "new password set" of [SCR-2](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md#scr-2-sign-in) (sign in) draw outcomes no acceptance criterion names; each traces to [R2](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (e-mail confirmation) and [R8](../0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (account recovery); does not block (prd-challenger, 2026-11-19)
  D: won't-fix, closed at the round cap
- F: P4, Requirements, the sign-up and set-new-password forms have no refusal state because the PRD sets no rule a password must meet; does not block (prd-challenger, 2026-11-19)
  D: won't-fix, closed at the round cap

### Round 1: prototype review

- F: PV1, Prototype, the check that each manifest entry matches its page fails: screens.md lines 70 ([SCR-3](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md#scr-3-choose-your-display-name), the display-name prompt) and 90 ([SCR-4](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md#scr-4-your-account), your account) mark the Display name field required, while display-name.html lines 102-103 and account.html line 107 carry no `required` attribute, unlike every other form in the prototype; blocks (prd-reviewer, 2026-11-19)
  D: resolved, the Originator's decision "Fix the pages": the Display name inputs in display-name.html and account.html now carry `required`, in the default, success and validation states, and screens.md stays as it is
- F: PV2, Prototype, screens.md cites acceptance criterion ids bare, with no link and no gloss, at lines 27, 49, 54, 75, 96, 98, 100, 102, 118 and 130; does not block (prd-reviewer, 2026-11-19)
  D: won't-fix, closed at the round cap
- F: PV3, Prototype, the Requirements glosses in screens.md paraphrase the PRD's requirements in full sentences, as at line 75; does not block (prd-reviewer, 2026-11-19)
  D: won't-fix, closed at the round cap
- F: PV4, Prototype, screens.md line 136 draws the flow as `flowchart TD`, where the diagram rule asks LR for a flow; does not block (prd-reviewer, 2026-11-19)
  D: won't-fix, closed at the round cap
- F: PV5, Prototype, the Flow in screens.md has edges no page draws: line 147, from sign in to your account with a display name set, and line 150, from your account to sign in when opened signed out; does not block (prd-reviewer, 2026-11-19)
  D: won't-fix, closed at the round cap
- F: PV6, Prototype, the sample data is fixed: sign-up.html line 109 and recover.html line 107 always show ana@example.org, and the success state of [SCR-4](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md#scr-4-your-account) (your account) shows the same name as its default; does not block (prd-reviewer, 2026-11-19)
  D: won't-fix, closed at the round cap

The verifying re-read after the apply returned nothing open.

## Review

1. **First pass, on the PRD.** Frontmatter, required sections, no history or open questions, dense criterion ids, links and the findings file's closure passed. The trace from requirement to criterion raised RV2 and RV3 of [Round 1: review](#round-1-review), the source walk raised RV1, and RV4 to RV8 came as non-blocking sightings.
2. **Final pass, on the PRD before the first decision.** Every gate proof passed: required sections, frontmatter against roadmap row 2, the id scheme, no open questions, every finding closed, every link resolving. The walk above placed every item. Notes, none blocking: no criterion tests the two quoted constraints; RV5 to RV8 stand as closed.
3. **Prototype pass.** The screen links resolve, the PRD differs from the text approved at the first decision only by the added screen links (confirmed by a diff in the conductor's thread), and the manifest fits its template. The check that each entry matches its page failed on PV1 of [Round 1: prototype review](#round-1-prototype-review); PV2 to PV6 came as notes. After the fix, the verifying re-read found the entries and pages matching.

## Escalations

- Cap: [RV1](#round-1-review), blocking, the brief's web and English constraints not carried; decided fixed by the Originator, both carried
- Cap: [RV2](#round-1-review), blocking, no criterion for a display name granting no role; decided by the Originator, the sentence removed from the display-name requirement: "It should not. A name is a name. Roles and permissions are defined by a user type, status... You don't have to associate name and role in any manner, including tests. This should not even be an AC or a requirement. It's just counter-logical."
- Cap: [RV3](#round-1-review), blocking, no criterion for the member id not revealing the e-mail address; decided fixed by the Originator, the ninth criterion extended
- Cap: [RV4](#round-1-review), non-blocking, refusal halves of four requirements untested; won't-fix, closed at the round cap
- Cap: [RV5](#round-1-review), non-blocking, the identity provider decision's consequence paraphrased under Out of scope; won't-fix, closed at the round cap
- Cap: [RV6](#round-1-review), non-blocking, the Problem retells the brief's Users sentence; won't-fix, closed at the round cap
- Cap: [RV7](#round-1-review), non-blocking, the quality-targets gap cited by a bare id; won't-fix, closed at the round cap
- Cap: [RV8](#round-1-review), non-blocking, the first finding's closure names size M against the roadmap's S; won't-fix, closed at the round cap
- Cap: [P1](#round-1-prototype), blocking, no sign-out on the display-name prompt against the sign-out requirement; won't-fix, the Originator's reason: "Until a name is provided the sign-in is considered incomplete"
- Cap: [P2](#round-1-prototype), non-blocking, an unconfirmed holder who lost the link has no way back in; won't-fix, closed at the round cap
- Cap: [P3](#round-1-prototype), non-blocking, two sign-in notices no criterion names; won't-fix, closed at the round cap
- Cap: [P4](#round-1-prototype), non-blocking, no password rule and so no refusal state; won't-fix, closed at the round cap
- Cap: [PV1](#round-1-prototype-review), blocking, the Display name inputs not marked required as the manifest says; decided fixed by the Originator, the pages fixed
- Cap: [PV2](#round-1-prototype-review), non-blocking, bare criterion ids in screens.md; won't-fix, closed at the round cap
- Cap: [PV3](#round-1-prototype-review), non-blocking, paraphrased requirement glosses in screens.md; won't-fix, closed at the round cap
- Cap: [PV4](#round-1-prototype-review), non-blocking, the flow drawn top-down; won't-fix, closed at the round cap
- Cap: [PV5](#round-1-prototype-review), non-blocking, flow edges no page draws; won't-fix, closed at the round cap
- Cap: [PV6](#round-1-prototype-review), non-blocking, fixed sample data; won't-fix, closed at the round cap

## Decision

1. **The PRD.** Approved in human mode, on the final review pass with every gate proof passing and every finding closed, the walk placing every item. Approver: Igor Roid, encraze@gmail.com, 2026-11-19.
2. **The prototype.** Approved in human mode, on the prototype pass with every proof passing after the fix of PV1 of [Round 1: prototype review](#round-1-prototype-review), the approved text unchanged but for the screen links, and every finding closed. Approver: Igor Roid, encraze@gmail.com, 2026-11-19.
