---
status: draft
owner: Igor Roid
updated: 2026-11-20
---

# Spec leg record: Member accounts and display names

PRD: [PRD 0001](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md), Member accounts and display names
Step: [step 2](../../roadmap/roadmap.md), members sign up, sign in and set the name others see
Follows: [0002-members-sign-up-sign-in-and-set-the-name-other-members-see.md](../../prd/_runs/0002-members-sign-up-sign-in-and-set-the-name-other-members-see.md), the PRD leg's record for step 2

## Specs

| Spec | Gloss | Why | Report |
|---|---|---|---|
| [Sign in to the portal](../0001-sign-in-to-the-portal-and-choose-a-display-name/0001-sign-in-to-the-portal-and-choose-a-display-name.md) | the OpenID Connect sign-in, the session and the profile with its member id | answers the PRD and carries the session, request filter and Profile-class change the [architecture record](../../arch/_runs/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#escalations) (escalations) says the Originator agreed to build | [report](../0001-sign-in-to-the-portal-and-choose-a-display-name/report.md) |
| [Account pages at the identity provider](../0002-account-pages-at-the-identity-provider/0002-account-pages-at-the-identity-provider.md) | the identity provider's realm settings and themed account pages | answers the PRD and carries the account pages change the [architecture record](../../arch/_runs/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#escalations) (escalations) says the Originator agreed to build | [report](../0002-account-pages-at-the-identity-provider/report.md) |
| [Change the display name and sign out](../0003-change-the-display-name-and-sign-out/0003-change-the-display-name-and-sign-out.md) | changing the display name and signing out | answers the PRD | [report](../0003-change-the-display-name-and-sign-out/report.md) |
| [Your account and the member id](../0004-your-account-and-the-member-id/0004-your-account-and-the-member-id.md) | Your account with the member id and the header's name | answers the PRD | [report](../0004-your-account-and-the-member-id/report.md) |
| [Choose a display name](../0005-choose-a-display-name/0005-choose-a-display-name.md) | the display-name rule, the prompt and the incomplete-registration check | answers the PRD and carries the session, request filter and Profile-class change the [architecture record](../../arch/_runs/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#escalations) (escalations) says the Originator agreed to build | [report](../0005-choose-a-display-name/report.md) |

## Depth

`medium`, chosen by the Originator when asked at the start of the leg.

## Size and route

Size M, route standard on every spec: the architecture leg's raise from S and quick, with its evidence in the [architecture record](../../arch/_runs/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#size-and-route) (size and route).

## Rounds

Three rounds of three, the `critique.rounds.standard.spec` cell: round 1 a challenge, round 2 a challenge, round 3 a review, then the decisions at the cap. The findings and their dispositions are in each spec's report, linked under Specs.

## Escalations

- Question: the OpenID Connect client library, a new runtime dependency under the tool policy: "Authlib + httpx (Recommended)", answered by the Originator
- Question: where the provider's flows end against the prototype's SCR-2 notices: "Follow provider flow (Recommended)", answered by the Originator
- Question: a per-client rate limit on the provider's pages: "No per-client limit", recorded as "Won't-fix: PoC scope", answered by the Originator
- Question: the password rule on sign-up and the new-password page: "8–64 chars, not e-mail (Recommended)", answered by the Originator
- Question: the two upstream findings, the unregistered rate-limit gap against the arc42 tree and the SCR-2 states against screens.md, answered at the spec's altitude rather than sent back: "Accept all (Recommended)", answered by the Originator
- Question: the library that counts a display name's visible characters, a new runtime dependency under the tool policy: "regex (Recommended)", answered by the Originator
- Question: removing rate limiting, which the input-validation concept asks for, from the specs alone or by a send-back to the architecture leg: "Drop from specs only (Recommended)", answered by the Originator
- Cap: spec 0001 would plan into more than ten tasks, blocking: won't-fix, "Reason: provider metadata, sign-in and the callback plan as one task, and the session store, session route and token as one; about 9 tasks, matching the Challenger's estimate; stage 03 parks the spec if it plans into more than ten"
- Cap: the session tables in an `api` schema the arc42 tree does not name, blocking: fixed, "Move to accounts schema (Recommended)"; the verifying re-read found the API block then writes Accounts' schema directly, and the Originator decided won't-fix, "Reason: the session store is the API block's own state, not module data; a minimal PoC accepts it sharing the accounts schema"
- Cap: the Approach narrates the Originator's library choice, not blocking: won't-fix, closed at the round cap

## Outcome

Approved.

The Originator approved the spec set at the gate in human mode, on the Reviewer's criterion walk placing all fourteen criteria, every finding carrying its disposition, and the decisions at the cap: Igor Roid, encraze@gmail.com, 2026-11-20.
