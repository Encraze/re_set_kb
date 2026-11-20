---
status: draft
owner: Igor Roid
updated: 2026-11-20
---

# Spec report: Your account and the member id

[Your account and the member id](0004-your-account-and-the-member-id.md), the spec this report records.

## Criterion walk

### [Member accounts and display names](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md)

| Criterion | Gloss | Answered in | Gloss |
|---|---|---|---|
| [AC-0001-9](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) | display names need not be unique | [Your account](#your-account) | answers: the member id beside a name others may share |
| [AC-0001-12](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) | signed-out visitor sent to sign in | [Your account](#your-account) | answers: nothing drawn before the read; a 401 sends the visitor to sign in |
| [AC-0001-13](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) | display name shown on own screens | [Your account](#your-account) | answers: the header's display name |

The walk placed every criterion this spec answers or keeps; nothing was left unplaced.

## Size and route

Size M, route standard: the architecture leg's raise from S and quick, with its evidence in the [architecture record](../../arch/_runs/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#size-and-route) (size and route).

## Rounds

Three rounds of three, the `critique.rounds.standard.spec` cell.

The spec was split out of spec 0001 under round 1's first finding, so its first reading was round 2's re-read.

### Round 2: challenge

- F: The rate limits lines 91-97, Rollout lines 134-135, risk lines 126-129: the check of X-Forwarded-For against Caddy's fixed compose address cannot be written as stated, since the product repo's Dockerfile line 22 starts uvicorn with `--proxy-headers --forwarded-allow-ips "*"`, and fixing Caddy's address is a compose change the spec does not put in scope; count by the client address uvicorn already gives and drop the fixed address, the trusted-proxy setting, its unit test and the risk paragraph; blocks (spec-challenger, 2026-11-20)
  D: resolved, at the Originator's word "Fix all as asked (Recommended)": The rate limits counts by `request.client.host`, which uvicorn sets from the header Caddy writes, with no port published for the application and no fixed address or setting; the trusted-proxy unit test, the risk paragraph, the Rollout's compose and settings sentence and the Security section's forwarded-address refusal are removed
- F: Failure paths line 108: `GET /api/sign-in` is a browser navigation the API client never handles, so a 429 problem+json response reaches the member as raw JSON, not a message to wait and try again; say what the member sees or name what renders it; does not block (spec-challenger, 2026-11-20)
  D: resolved, at the Originator's word "Plain readable page (Recommended)": the sign-in route's 429 is a minimal HTML page saying to wait and try again, with no new screen and no Web client change, stated in The rate limits, the Failure paths row and the sign-in limit's unit test; the save's 429 stays a problem response
- F: The rate limits, its Failure-path rows, the limits' unit tests, Scope, Interfaces, Security and the kept criteria AC-0001-4 and AC-0001-8: rate limiting is not needed for the project, in the Originator's words "Can you remove rate limiting at all from the requirements? We don't need it for the project."; blocks (Igor Roid, 2026-11-20)
  D: resolved, as the Originator decided, "Drop from specs only (Recommended)", superseding the rate-limit parts of the two findings above: the spec is renamed "Your account and the member id" and moved to spec/0004-your-account-and-the-member-id/; The rate limits section, its three Failure-path rows, the pytest limit tests, the In-scope and Out-of-scope limit bullets, the kept AC-0001-4 and AC-0001-8, the deployment view in `arc42:` and the Security refusal and client-address sentence are removed; Interfaces reads `No interface change.`, since only the 429s needed the contract; Security records the input-validation concept's line on rates as an accepted gap, won't-fix, "not needed for the project"; the arc42 line stays as written

### Round 3: review

- F: Spec 0001 would plan into more than ten tasks; for this spec, name spec 0005 among the specs it builds on and repoint what moved: Scope lines 20-24 name 0001 as the only base, Out of scope lines 37-38 give the prompt to the sign-in spec, Your account lines 61-64 and 68-69 link the prompt and 0001#the-display-name-rule, the failure row line 79 takes the prompt from 0001, and the glosses of 0001 predate its new title; blocks (spec-reviewer, 2026-11-20)
  D: resolved, at the Originator's word "Split into 0005 (Recommended)": Scope lines 20-26 gloss spec 0001 as "sign in to the portal", list `GET /api/members/me` in place of "the member routes", and name spec 0005 (choose a display name) for the prompt and the filter's check that opens it; Out of scope lines 38-42 split the prompt into its own bullet linking 0005#the-prompt; Approach lines 56-58 say the API and Accounts are used as the sign-in spec and spec 0005 leave them; Your account line 70 links 0005#the-prompt and lines 76-77 link 0005#the-display-name-rule; the failure row line 87 links 0005#the-prompt; both anchors checked against 0005's headings, and the 0001 anchors kept (the-request-filter, the-web-client, profile-and-member-id) checked against its headings
- F: arc42 frontmatter: line 25 cites 11-risks-and-technical-debt.md, which the frontmatter does not list; add or remove; does not block (spec-reviewer, 2026-11-20)
  D: resolved, at the Originator's word "Fix all as asked (Recommended)": the sentence citing Technical debt is removed from Scope, since the spec clears no entry and section 11 registers none; `arc42:` is unchanged
- F: readable-prose §19: lines 65-68 and 137-142 restate data-classification.md lines 13 and 20-21 and PRD 0001 requirement 9 (member id); link with one sentence of context; does not block (spec-reviewer, 2026-11-20)
  D: resolved, at the Originator's word "Fix all as asked (Recommended)": Your account lines 72-79 say the page shows the member id the sign-in spec generates, linking PRD 0001 requirement 9 (member id), with the restated generation and e-mail rules removed; Security's Data bullet, lines 145-148, says Your account shows a member their own Profile-class values, linking data classification with a gloss, with the restated visibility rule and the e-mail sentence removed
- F: Finding dispositions in the accepted-gap text: lines 144-146 quote "won't-fix", "not needed for the project" and "as the Originator decided"; state the gap and its cost; does not block (spec-reviewer, 2026-11-20)
  D: resolved, at the Originator's word "Fix all as asked (Recommended)": the Accepted gap bullet, lines 149-151, states the missing rate limit and its cost, that a client can send sign-ins and writes at any rate, and carries no disposition

## Review

Two passes of `/spec-first-sdlc:review` by the spec-reviewer, over the PRD's whole spec set.

1. After the challenge loop closed on round 2's re-read: frontmatter, sections, criteria quoted word for word against the PRD, every `arc42:` path and linked anchor resolving, Interfaces and Data one line each, every Screens entry present in [screens.md](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md) (the screen manifest), diagrams against the diagram rule, no open question, every `F:` with its `D:`, and the readable-prose tells. All passed except the task count of spec 0001, the one blocking finding; with fourteen findings that do not block, it opened round 3.
2. The re-read that closed round 3, at the cap: it verified round 3's dispositions and opened nothing. The split into spec 0005, the links, the narration and the accepted-gap texts landed; two blocking conditions it found still holding, spec 0001's task count and the `api` schema, and one disposition partly landed went to the Originator at the cap.

The gate proofs bound to the Reviewer's stop returned no failing proof on either pass. The Challenger's one verifying re-read after the at-the-cap fix found the schema move landed in the text but did not stand, which the Originator then decided.

## Escalations

- Question: removing rate limiting, which the input-validation concept asks for, from the specs alone or by a send-back to the architecture leg: "Drop from specs only (Recommended)", answered by the Originator

## Decision

Approved.

The Originator approved the spec set at the gate in human mode, on the Reviewer's criterion walk placing all fourteen criteria, every finding carrying its disposition, and the decisions at the cap: Igor Roid, encraze@gmail.com, 2026-11-20.
