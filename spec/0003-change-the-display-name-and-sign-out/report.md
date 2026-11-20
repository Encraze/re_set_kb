---
status: draft
owner: Igor Roid
updated: 2026-11-20
---

# Spec report: Change the display name and sign out

[Change the display name and sign out](0003-change-the-display-name-and-sign-out.md), the spec this report records.

## Criterion walk

### [Member accounts and display names](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md)

| Criterion | Gloss | Answered in | Gloss |
|---|---|---|---|
| [AC-0001-7](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) | display-name length rule | [Changing the display name](#changing-the-display-name) | answers: the change path under the same rule |
| [AC-0001-10](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) | change the display name | [Changing the display name](#changing-the-display-name) | answers: the save and the header's new name |
| [AC-0001-11](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) | sign out | [Sign-out](#sign-out) | answers: the session ends at the portal and at the provider |
| [AC-0001-12](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) | signed-out visitor sent to sign in | [The session store and the filter](#the-session-store-and-the-filter) | keeps: the filter lets sign-out through and still turns the signed-out away |
| [AC-0001-13](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) | display name shown on own screens | [Changing the display name](#changing-the-display-name) | keeps: the header shows the saved name |

The walk placed every criterion this spec answers or keeps; nothing was left unplaced.

## Size and route

Size M, route standard: the architecture leg's raise from S and quick, with its evidence in the [architecture record](../../arch/_runs/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#size-and-route) (size and route).

## Rounds

Three rounds of three, the `critique.rounds.standard.spec` cell.

### Round 1: challenge

- F: Spec 0001, Approach, about lines 52-275: spec 0001 is too wide, and part of it moves to a new spec; for 0003, the lines that cite what moved, Your account in its default state, AC-0001-13 (a member's own screens show their display name) kept on the layout, and the save-rate 429 row, point at 0001; blocks (spec-challenger, 2026-11-20)
  D: resolved, as the Originator decided, "Accept all (Recommended)": [spec 0004](../0004-your-account-the-member-id-and-the-rate-limits/0004-your-account-the-member-id-and-the-rate-limits.md) (your account, the member id and the rate limits) is named in Scope among the specs 0003 builds on, for Your account's default state, the header's display name and the save's rate limit; the Sign-out bullet names 0004 as drawing the header's name, the 429 row of Failure paths links 0004's The rate limits, and AC-0001-13's kept line names the header 0004 draws and answers it with
- F: Failure paths, lines 208-209, Rollout, lines 249-252, In scope, lines 29-38: the reverse proxy's log is always on, Caddy's JSON access log records the request URI with its query string, so every sign-out writes the ID token into the log through `id_token_hint`; dropping it is a change to `deploy/caddy/Caddyfile` in the product repo, so it is code and falls to no task as written, against question 1, question 15 and the logging concept's "Never recorded: … tokens"; blocks (spec-challenger, 2026-11-20)
  D: resolved, as the Originator decided, "Accept all (Recommended)": In scope gains the reverse proxy's access log in the product repo's `deploy/caddy/Caddyfile`; the paragraph under Failure paths states that the proxy's log filter deletes `id_token_hint` from every request URI and the `Location` header from the answer of `/api/sign-out/provider`, whose 303 carries the hint, and "where it is on" is gone; Rollout ships the filter with the code and no longer lists it outside the code; the functional test reads the proxy's log after AC-0001-11's sign-out and finds no ID token; Security's Data bullet names the proxy; `07-deployment-view.md` joins the frontmatter's arc42 list
- F: Lines 39 and 176-177, with 0001's Security line 345: 0001 and 0003 split the portal client's settings; the trim of the `email` and `profile` default client scopes belongs in 0001, which creates the client and relies on it, and 0003 keeps the post-logout redirect URI; does not block (spec-challenger, 2026-11-20)
  D: resolved, as the Originator decided, "Accept all (Recommended)": In scope keeps the post-logout redirect URI alone; the bullet under The session store and the filter states that the stored token carries no contact data and links the sign-in spec's Sign-in and the session for the client's scopes; Rollout sets only the post-logout redirect URI through the admin console; Security's Data bullet points at that bullet in place of "the default client scopes above"
- F: Spec 0001, the portal client: the client's secret has no mechanism; for 0003, its sign-out has to read true once the client is public; does not block (spec-challenger, 2026-11-20)
  D: resolved, as the Originator decided, "Public client, PKCE (Recommended)": the Sign-out bullet on `GET /api/sign-out/provider` states that the end-session request authenticates no client, so the public client, holding no secret, signs out with `id_token_hint`, `post_logout_redirect_uri` and `client_id` alone; nothing else in 0003 named a secret
- F: Lines 133-135: the change path cites ADR 0001's costs for last-write-wins, while the profile table carries no version column, against the persistence concept, and ADR 0003 refuses a conflicting write; does not block (spec-challenger, 2026-11-20)
  D: resolved, as the Originator decided, "Add it now (Recommended)": the ADR 0001 citation is gone from Changing the display name, and a bullet there states that the save meets Accounts' version check from the sign-in spec's Profile and member id, a write landing between read and update answered 409 `profile-changed` with nothing saved, the readable message shown, the field keeping the typed value and the header the saved name; a Failure paths row for the 409 and a Vitest case for the 409 message are added

### Round 2: challenge

- F: Scope, Failure paths, Security and the links to spec 0004: rate limiting is not needed for the project, in the Originator's words "Can you remove rate limiting at all from the requirements? We don't need it for the project."; for 0003, the save-rate 429 row and Scope's "the save's rate limit" go, and every link to 0004 follows its new path and title; blocks (Igor Roid, 2026-11-20)
  D: resolved, as the Originator decided, "Drop from specs only (Recommended)": the 429 row of Failure paths is gone; Scope names [spec 0004](../0004-your-account-and-the-member-id/0004-your-account-and-the-member-id.md) (your account and the member id) for Your account's default state and the header's display name only; the Sign-out bullet and AC-0001-13's kept line link 0004's Your account at its new path and title; Security gains an accepted gap, the input validation concept's line on rates, won't-fix, "not needed for the project", linking the concept, which joins the frontmatter's arc42 list; the arc42 line stays as written

### Round 3: review

- F: Spec 0001 would plan into more than ten tasks; the split moves the display-name rule, Accounts' set operation with the version check and ProfileChanged, `PUT /api/members/me/display-name` with its 422 and 409 mappings, the filter's third check, the session-id renewal at profile completion and the prompt to spec 0005; for 0003, lines 21-23, 34-37, 49-52, 64-67, 136-139, 140-146, 153-156, 157-163, 183-184, 218, 233-235, 289 and 301-302 attribute those to 0001, and the gloss "(sign-in and the first display name)" is outdated; blocks (spec-reviewer, 2026-11-20)
  D: resolved, as the Originator decided, "Split into 0005 (Recommended)": Scope names [spec 0005](../0005-choose-a-display-name/0005-choose-a-display-name.md) (choose a display name) among the specs 0003 builds on, for the rule, the route, the set operation and the third check, and glosses 0001 as "(sign in to the portal)"; In scope's route, Out of scope's rule, prompt, route and operation, Approach's route and operation, the session-id renewal, the version check, the prompt's header, the third check's exception (Sign-out bullet and AC-0001-12's kept line), the ID token kept at the new session id, the 409 row of Failure paths, the set operation's fake under Tests and AC-0001-7's prompt path now link 0005's anchors `#setting-the-name`, `#the-display-name-rule`, `#the-prompt`, `#the-request-filters-third-check`, `#tests-and-local-stand-ins` and `#acceptance-criteria-answered`, each checked against 0005's headings; the building-block paragraph says this spec changes nothing in Accounts and calls the sign-in spec's profile read and 0005's set operation; the links left on 0001 (the Web client's 401 handling, the client's scopes, the tests' fakes and stand-ins, the filter's 401) point at what 0001 still builds
- F: arc42 frontmatter: line 30 cites 11-risks-and-technical-debt.md, which the frontmatter does not list; the frontmatter lists 09-architecture-decisions/0001-application-stack.md, which the body never cites (line 5); does not block (spec-reviewer, 2026-11-20)
  D: resolved, as the Originator decided, "Fix all as asked (Recommended)": the frontmatter's arc42 list gains `11-risks-and-technical-debt.md` and drops `09-architecture-decisions/0001-application-stack.md`
- F: readable-prose §19: lines 26-28 restate authentication-and-authorisation.md lines 19-20, sign-out ending the session on the server and at the provider; does not block (spec-reviewer, 2026-11-20)
  D: resolved, as the Originator decided, "Fix all as asked (Recommended)": Scope's sentence now reads "Sign-out follows the sign-in concept (how a session starts and ends)", a link with a gloss and no restatement
- F: readable-prose §19 against the screen manifest: lines 131-135 restate SCREENS lines 83-86, the validation and success states of SCR-4; does not block (spec-reviewer, 2026-11-20)
  D: resolved, as the Originator decided, "Fix all as asked (Recommended)": the two bullets under Changing the display name link SCR-4's entry for the validation and success states and keep only what the spec adds: the problem's message, the field keeping the typed value, the header keeping the saved name, the name the answer carries and how long the notice stays
- F: Screen state built but not in the manifest: lines 140-146 describe a 409 message on the display-name section, and SCR-4 holds no such state; does not block (spec-reviewer, 2026-11-20)
  D: resolved, as the Originator decided, "Fix all as asked (Recommended)": the version-check bullet states that no state of Your account's screen draws the 409 and sends the reader to Failure paths, whose 409 row carries what the member sees, the readable message with its correlation id, the typed value kept and the header's saved name, with no screen entry; screens.md is unchanged
- F: History narration, against CLAUDE.md "State what is true now": remove any narration of the run or of a challenge, state the rule and link where the decision lives; does not block (spec-reviewer, 2026-11-20)
  D: resolved, as the Originator decided, "Fix all as asked (Recommended)": the one narration the spec held, "Won't-fix, as the Originator decided" in the accepted gap, is gone (see the next finding); the decision lives in this file's Round 2 entry
- F: Finding dispositions in the accepted-gap text: lines 350-351 quote "won't-fix", "not needed for the project" and "as the Originator decided"; does not block (spec-reviewer, 2026-11-20)
  D: resolved, as the Originator decided, "Fix all as asked (Recommended)": Security's accepted gap states the gap and its cost, a client holding a session can send saves and sign-outs at any rate, each a write to the profile or to the session row; the disposition stays in this file
- F: Lines 189-190 put tables in an `api` schema, which the tree names for no module; does not block (spec-reviewer, 2026-11-20)
  D: won't-fix, "The API block owning its own schema follows the one-schema-per-owner pattern; the tree doesn't forbid it"
  D: superseded by the fix of the blocking finding under At the cap: the session table sits in the `accounts` schema, and 0003 names no `api` schema

Decided at the round cap, after the re-read that closed round 3:

- F: The session store and the filter, lines 198-199, and Security: 0001 and 0003 place tables in an `api` schema; the persistence concept gives one schema per module, the building block view names six modules and the API block is none of them, and no `api` schema appears in the tree; the won't-fix on the Round 3 finding does not clear this; blocks (spec-reviewer, 2026-11-20)
  D: resolved, as the Originator decided, "Move to accounts schema (Recommended)": the bullet under The session store and the filter puts the two new nullable columns on the session table in the `accounts` schema; Security's Data bullet holds the ID token in the `accounts` schema alone; the building-block paragraph says this spec adds no operation to Accounts, whose schema holds the session table, where it said this spec changes nothing in Accounts
  D: won't-fix, as the Originator decided, "Won't-fix, go to gate (Recommended)", after the Challenger's verifying re-read (spec-challenger, 2026-11-20) found the move landed in the text but does not stand: with the session tables in the schema `accounts`, the API block reads and writes another module's schema directly (lines 117-121; 0001, lines 33, 67, 118, 139-149 and 231; 0005, line 134), against [persistence](../../arch/08-crosscutting-concepts/persistence.md) lines 12-14, and Accounts offers no session operation ([building block view](../../arch/05-building-block-view.md#accounts) lines 78-88); "Reason: the session store is the API block's own state, not module data; a minimal PoC accepts it sharing the accounts schema"; the spec text stays

## Review

Two passes of `/spec-first-sdlc:review` by the spec-reviewer, over the PRD's whole spec set.

1. After the challenge loop closed on round 2's re-read: frontmatter, sections, criteria quoted word for word against the PRD, every `arc42:` path and linked anchor resolving, Interfaces and Data one line each, every Screens entry present in [screens.md](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md) (the screen manifest), diagrams against the diagram rule, no open question, every `F:` with its `D:`, and the readable-prose tells. All passed except the task count of spec 0001, the one blocking finding; with fourteen findings that do not block, it opened round 3.
2. The re-read that closed round 3, at the cap: it verified round 3's dispositions and opened nothing. The split into spec 0005, the links, the narration and the accepted-gap texts landed; two blocking conditions it found still holding, spec 0001's task count and the `api` schema, and one disposition partly landed went to the Originator at the cap.

The gate proofs bound to the Reviewer's stop returned no failing proof on either pass. The Challenger's one verifying re-read after the at-the-cap fix found the schema move landed in the text but did not stand, which the Originator then decided.

## Escalations

- Question: removing rate limiting, which the input-validation concept asks for, from the specs alone or by a send-back to the architecture leg: "Drop from specs only (Recommended)", answered by the Originator
- Cap: the session tables in an `api` schema the arc42 tree does not name, blocking: fixed, "Move to accounts schema (Recommended)"; the verifying re-read found the API block then writes Accounts' schema directly, and the Originator decided won't-fix, "Reason: the session store is the API block's own state, not module data; a minimal PoC accepts it sharing the accounts schema"

## Decision

Approved.

The Originator approved the spec set at the gate in human mode, on the Reviewer's criterion walk placing all fourteen criteria, every finding carrying its disposition, and the decisions at the cap: Igor Roid, encraze@gmail.com, 2026-11-20.
