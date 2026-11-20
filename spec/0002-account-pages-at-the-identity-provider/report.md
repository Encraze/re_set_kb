---
status: draft
owner: Igor Roid
updated: 2026-11-20
---

# Spec report: Account pages at the identity provider

[Account pages at the identity provider](0002-account-pages-at-the-identity-provider.md), the spec this report records.

## Criterion walk

### [Member accounts and display names](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md)

| Criterion | Gloss | Answered in | Gloss |
|---|---|---|---|
| [AC-0001-1](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) | sign up with a new address | [Where each flow ends](#where-each-flow-ends) | answers: rows 1 and 4, sign-up to the confirmation e-mail |
| [AC-0001-2](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) | unconfirmed address cannot sign in | [Where each flow ends](#where-each-flow-ends) | answers: rows 5 and 6, the confirm-address page |
| [AC-0001-3](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) | address in use tells nothing | [The theme](#the-theme) | answers: the registration override shows an address in use as a new sign-up |
| [AC-0001-4](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) | sign in with the right credentials | [Where each flow ends](#where-each-flow-ends) | keeps: row 7, the themed sign-in page |
| [AC-0001-5](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) | wrong password refused | [Realm settings](#realm-settings) | answers: one wrong-credentials message and the temporary lockout |
| [AC-0001-14](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) | recover a forgotten password | [Where each flow ends](#where-each-flow-ends) | answers: rows 8 to 10, recovery link to a new password |

The walk placed every criterion this spec answers or keeps; nothing was left unplaced.

## Size and route

Size M, route standard: the architecture leg's raise from S and quick, with its evidence in the [architecture record](../../arch/_runs/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#size-and-route) (size and route).

## Rounds

Three rounds of three, the `critique.rounds.standard.spec` cell.

### Round 1: challenge

- F: upstream: against the arc42 tree: the per-client rate limits on sign-in and sign-up are waived with no Technical debt entry. Location: 0002, line 45 and lines 310-317 (the Originator's "Won't-fix: PoC scope"); 0001, line 206; arch/08-crosscutting-concepts/input-validation.md, "Sign-in, sign-up and every form that writes are rate-limited per client"; arch/11-risks-and-technical-debt.md, "No technical debt is registered". Evidence: passwords and sign-ups are submitted to the provider's pages, and 0002 waives the limit there; 0001's limit sits on GET /api/sign-in, a redirect where no password is tried; the concept states a property the delivered system will not have; the waiver 0002 quotes is in no committed record. Fix: a Technical debt entry or a narrower concept, an upstream change; blocks (spec-challenger, 2026-11-20)
  D: resolved, answered in the spec with no send-back as the Originator decided ("Accept all (Recommended)"): Security's accepted costs now state that the provider's pages carry no per-client limit, that 0001's limit sits on the sign-in redirect, and that the tree registers no debt entry for the gap, and Out of scope points there; the arc42 tree stays as it is; the cost is a delivered system without the per-client limit the input validation concept states, tracked by no Technical debt entry, so one client can try passwords across accounts and spend Gmail's daily allowance
- F: A wrong password at the provider is logged nowhere. Location: 0002, Realm settings line 85 ("Event listeners: none") and lines 96-98. Criterion: the logging concept, which lists sign-in as a security event. Evidence: with the provider's listeners off, failed password attempts and lockouts leave no trace; 0001's security events only see the callback after a successful sign-in. The reason for turning the listeners off holds. Fix: state the resulting gap as an accepted cost in 0002's Security section, or another way to record failures without the address; does not block (spec-challenger, 2026-11-20)
  D: resolved, as the Originator decided ("Accept all (Recommended)"): an accepted cost added to Security, stating that failed passwords and lockouts at the provider leave no log line, under the Originator's reason "Won't-fix: PoC scope"; the listeners stay off
- F: upstream: against screens.md: 0002's Screens claims SCR-2 states it does not build as drawn. Location: 0002, Screens line 256 ("all five states … as the provider's flow ends them"), and Where each flow ends, rows 4, 6 and 10; ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md, SCR-2. Evidence: screens.md draws "address not confirmed" as a red notice above the sign-in form, row 6 shows the confirm-address page instead; screens.md draws the two success states as green notices on SCR-2, rows 4 and 10 carry the member into the portal or the provider's information page. Stage 04's code reviewer reads a task against the prototype page, so it will raise the differences as defects. Fix: either 0002's Screens lists only the states built as drawn, or screens.md gets an upstream correction; blocks (spec-challenger, 2026-11-20)
  D: resolved, answered in the spec as the Originator decided ("Accept all (Recommended)"): Screens lists SCR-2's default and wrong-address-or-password states only and names where the other three end, and the Screen state column of rows 4, 6 and 10 reads none, SCR-1 success and none; screens.md stays as it is; the cost is that SCR-2's address-not-confirmed notice and its two green success notices are drawn in the prototype and never built

### Round 2: challenge

- F: Security, accepted costs, lines 314-316: the text places the portal's limit in spec 0001 on its sign-in redirect, but that limit is in 0004 (0004 lines 86-87) and 0001 lines 50-53 list it as out of scope, so a reader following the link finds no limit; 0004 lines 42-44 point back to 0002's Security, so the two specs must agree; fix: link to 0004's The rate limits section; blocks (spec-challenger, 2026-11-20)
  D: resolved, as the Originator decided ("Fix all as asked (Recommended)"): the accepted cost in Security, lines 312-315, now links to spec 0004's The rate limits section, glossed as your account, the member id and the rate limits, and places the limit on the sign-in redirect; the link to spec 0001 there is gone
- F: O1. Rate limiting is not needed for the project: "Can you remove rate limiting at all from the requirements? We don't need it for the project." Location: 0002, Security, accepted costs, lines 310-322, and the link at line 313 to spec 0004's rate-limits section, which no longer exists since 0004 is now "Your account and the member id"; does not block (Igor Roid, 2026-11-20)
  D: won't-fix, the Originator's reason in their words, "not needed for the project", applied as they chose, "Drop from specs only (Recommended)": the input validation cost in Security, lines 310-319, now states that no per-client rate limit is built anywhere, in the portal or at the provider, and keeps the link to the input validation concept, the missing debt entry, and the costs of passwords tried across accounts and Gmail's daily allowance; the link to spec 0004 is gone, and no other link to its old path remains; the unlogged-failures cost, lines 320-325, states its own reason, "Won't-fix: PoC scope"; the arc42 line stays as written

### Round 3: review

- F: N1. Where each flow ends, lines 143-153: rows 1, 2, 3, 5, 7, 8 and 9 cite SCR-1, SCR-2, SCR-5 and SCR-6 as bare ids in the screen-state column, while row 6 is linked and glossed (readable-prose §18); fix: link each SCR id to its screens.md entry; does not block (spec-reviewer, 2026-11-20)
  D: resolved, as the Originator decided ("Fix all as asked (Recommended)"): every SCR id in the Screen state column, lines 140-148, is a link to its screens.md entry with the screen's title as gloss
- F: N2. Rollout, line 200: "GAP-0002" is a bare id, unlinked, minted by arch/08-crosscutting-concepts/delivery.md line 35 (readable-prose §18); fix: link the id to that file; does not block (spec-reviewer, 2026-11-20)
  D: resolved, as the Originator decided ("Fix all as asked (Recommended)"): Rollout, lines 198-199, links GAP-0002 to delivery.md with the gloss release script and AWS resources not built
- F: N3. Screens, line 256: the SCR-2 entry runs to several sentences explaining the states that are not built, against the template's one line each; fix: keep the built states on the line, the reasons already sit under Where each flow ends; does not block (spec-reviewer, 2026-11-20)
  D: resolved, as the Originator decided ("Fix all as asked (Recommended)"): the SCR-2 entry, line 254, under Screens at line 251, lists its two built states only
- F: N4. arc42 frontmatter: the body cites 11-risks-and-technical-debt.md (lines 27 and 314), which the frontmatter does not list; fix: add or remove; does not block (spec-reviewer, 2026-11-20)
  D: resolved, as the Originator decided ("Fix all as asked (Recommended)"): 11-risks-and-technical-debt.md added to `arc42:`, line 5, since Scope and Security both rest on its Technical debt section
- F: N6. Line 18 and lines 54-56 restate authentication-and-authorisation.md lines 27-31 (account pages on the provider's pages, served on the portal's domain) and the reverse-proxy row of 07, Production (readable-prose §19); fix: link; does not block (spec-reviewer, 2026-11-20)
  D: resolved, as the Originator decided ("Fix all as asked (Recommended)"): the gloss after the account pages link in Scope, line 17, is gone, and Approach, lines 52-55, links the account pages concept and the deployment view's reverse proxy for the routes instead of describing them
- F: N7. Security, lines 270-274, restate the trust-boundary rows of 03-context-and-scope.md and the Credentials and Contact data rows of data-classification.md (readable-prose §19); fix: link; does not block (spec-reviewer, 2026-11-20)
  D: resolved, as the Originator decided ("Fix all as asked (Recommended)"): Security, lines 268-272, links the trust boundaries, naming the two crossed as gloss, and links data classification for where credentials and contact data live, without restating the rows
- F: N13. History narration, against CLAUDE.md "State what is true now": lines 24-26 ("built in this run ... the Originator agreed to build now"), line 137 ("The Originator chose to follow..."), lines 165-167 ("as the architecture leg's first challenge found"); fix: state the rule and link the record for where the decision lives, without the run or the challenge; does not block (spec-reviewer, 2026-11-20)
  D: resolved, as the Originator decided ("Fix all as asked (Recommended)"): Scope, lines 22-24, states the change the spec carries and links the architecture record's escalations; Where each flow ends, lines 134-135, states that the provider's flow holds and links this spec's report.md; Alternatives considered, lines 162-165, links the account pages concept, which places the in-use refusal in the registration override
- F: N14. Finding dispositions in the accepted-gap text, lines 315 and 324: "won't-fix", "not needed for the project", "Won't-fix: PoC scope"; fix: state the gap and its cost, the disposition belongs in the findings file and the report; does not block (spec-reviewer, 2026-11-20)
  D: resolved, as the Originator decided ("Fix all as asked (Recommended)"): the two disposition sentences are removed from Security's accepted costs, lines 308-316 and 317-321, which state each gap and its cost; the dispositions stay in Round 1 and Round 2 above
- F: B1. Spec 0001 would plan into more than ten tasks; its consequence for 0002 is that Out of scope, lines 38-41, places the display-name prompt in 0001, and lines 96-97, 209-210 and 248-249 gloss 0001 as "sign in to the portal and choose a display name", which no longer matches its title; blocks, on 0001 (spec-reviewer, 2026-11-20)
  D: resolved, as the Originator decided ("Split into 0005 (Recommended)"): Out of scope, lines 38-43, keeps the client, sign-in route, session, sign-out and member id under spec 0001, glossed sign in to the portal, and gives the display-name prompt its own item linking spec 0005's The prompt section, glossed choose a display name; the gloss of the 0001 links at lines 99, 212 and 251 now reads sign in to the portal; nothing else in 0002 changed

## Review

Two passes of `/spec-first-sdlc:review` by the spec-reviewer, over the PRD's whole spec set.

1. After the challenge loop closed on round 2's re-read: frontmatter, sections, criteria quoted word for word against the PRD, every `arc42:` path and linked anchor resolving, Interfaces and Data one line each, every Screens entry present in [screens.md](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md) (the screen manifest), diagrams against the diagram rule, no open question, every `F:` with its `D:`, and the readable-prose tells. All passed except the task count of spec 0001, the one blocking finding; with fourteen findings that do not block, it opened round 3.
2. The re-read that closed round 3, at the cap: it verified round 3's dispositions and opened nothing. The split into spec 0005, the links, the narration and the accepted-gap texts landed; two blocking conditions it found still holding, spec 0001's task count and the `api` schema, and one disposition partly landed went to the Originator at the cap.

The gate proofs bound to the Reviewer's stop returned no failing proof on either pass. The Challenger's one verifying re-read after the at-the-cap fix found the schema move landed in the text but did not stand, which the Originator then decided.

## Escalations

- Question: where the provider's flows end against the prototype's SCR-2 notices: "Follow provider flow (Recommended)", answered by the Originator
- Question: a per-client rate limit on the provider's pages: "No per-client limit", recorded as "Won't-fix: PoC scope", answered by the Originator
- Question: the password rule on sign-up and the new-password page: "8–64 chars, not e-mail (Recommended)", answered by the Originator
- Question: the two upstream findings, the unregistered rate-limit gap against the arc42 tree and the SCR-2 states against screens.md, answered at the spec's altitude rather than sent back: "Accept all (Recommended)", answered by the Originator
- Question: removing rate limiting, which the input-validation concept asks for, from the specs alone or by a send-back to the architecture leg: "Drop from specs only (Recommended)", answered by the Originator

## Decision

Approved.

The Originator approved the spec set at the gate in human mode, on the Reviewer's criterion walk placing all fourteen criteria, every finding carrying its disposition, and the decisions at the cap: Igor Roid, encraze@gmail.com, 2026-11-20.
