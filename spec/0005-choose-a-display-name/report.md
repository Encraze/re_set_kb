---
status: draft
owner: Igor Roid
updated: 2026-11-20
---

# Spec report: Choose a display name

[Choose a display name](0005-choose-a-display-name.md), the spec this report records.

## Criterion walk

### [Member accounts and display names](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md)

| Criterion | Gloss | Answered in | Gloss |
|---|---|---|---|
| [AC-0001-6](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) | no display name, prompted | [The request filter's third check](#the-request-filters-third-check) | answers: registration-incomplete opens the prompt |
| [AC-0001-7](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) | display-name length rule | [The display-name rule](#the-display-name-rule) | answers: 2 to 40 visible characters on the prompt path |
| [AC-0001-8](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) | non-Latin display name accepted | [The display-name rule](#the-display-name-rule) | answers: any script accepted |

The walk placed every criterion this spec answers or keeps; nothing was left unplaced.

## Size and route

Size M, route standard: the architecture leg's raise from S and quick, with its evidence in the [architecture record](../../arch/_runs/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#size-and-route) (size and route).

## Rounds

Three rounds of three, the `critique.rounds.standard.spec` cell.

The spec was split out of spec 0001 under round 3's first finding, so the re-read that closed round 3 was its only reading.

### Round 3: review

- F: Spec 0001, lines 131-292: by the Reviewer's count [spec 0001](../0001-sign-in-to-the-portal-and-choose-a-display-name/0001-sign-in-to-the-portal-and-choose-a-display-name.md) carries 14 separable build units and three test levels, which a planner at the usual grain cuts into about 12 to 14 tasks, against "would plan into more than ten tasks"; move the Accounts profile and member-id work (171-204) or the session, sign-in and filter work (131-160) into a further spec, or show how they fold into ten tasks; blocks (spec-reviewer, 2026-11-20)
  D: resolved, as the Originator decided, "Split into 0005 (Recommended)", the cut left to the Outliner: this spec is the display-name half of 0001, step 2, PRD 0001, size M, route standard, building on 0001 (sign in to the portal) for the session, the state-change token, the filter's first two checks, the profile table, the API client and the member layout; it takes the display-name rule, Accounts' set operation with the version check and `ProfileChanged`, `PUT /api/members/me/display-name` with its 422 and 409 mappings, the filter's third check, the new session id at completion, the prompt and the API client's `registration-incomplete` handling, and answers AC-0001-6, AC-0001-7 and AC-0001-8 with SCR-3 default and validation; it adds no migration, since 0001's revision creates the profile with its display name and version

## Review

Two passes of `/spec-first-sdlc:review` by the spec-reviewer, over the PRD's whole spec set.

1. After the challenge loop closed on round 2's re-read: frontmatter, sections, criteria quoted word for word against the PRD, every `arc42:` path and linked anchor resolving, Interfaces and Data one line each, every Screens entry present in [screens.md](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md) (the screen manifest), diagrams against the diagram rule, no open question, every `F:` with its `D:`, and the readable-prose tells. All passed except the task count of spec 0001, the one blocking finding; with fourteen findings that do not block, it opened round 3.
2. The re-read that closed round 3, at the cap: it verified round 3's dispositions and opened nothing. The split into spec 0005, the links, the narration and the accepted-gap texts landed; two blocking conditions it found still holding, spec 0001's task count and the `api` schema, and one disposition partly landed went to the Originator at the cap.

The gate proofs bound to the Reviewer's stop returned no failing proof on either pass. The Challenger's one verifying re-read after the at-the-cap fix found the schema move landed in the text but did not stand, which the Originator then decided.

## Escalations

- Question: the library that counts a display name's visible characters, a new runtime dependency under the tool policy: "regex (Recommended)", answered by the Originator

## Decision

Approved.

The Originator approved the spec set at the gate in human mode, on the Reviewer's criterion walk placing all fourteen criteria, every finding carrying its disposition, and the decisions at the cap: Igor Roid, encraze@gmail.com, 2026-11-20.
