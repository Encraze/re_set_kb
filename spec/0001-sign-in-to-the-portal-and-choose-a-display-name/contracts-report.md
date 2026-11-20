---
status: approved
owner: Igor Roid
updated: 2026-11-20
---

# Contracts report: Sign in to the portal

Spec: [Sign in to the portal](0001-sign-in-to-the-portal-and-choose-a-display-name.md)

## Files

| Writer | File | Gloss |
|---|---|---|
| data-modeller | [data-model.md](data-model.md) | Profile, Session and SignInAttempt in the schema `accounts` |
| migration-writer | [migrations/](migrations/) | three pairs: profile, session, sign-in attempt |
| contract-writer | [contracts/openapi.yaml](contracts/openapi.yaml), [contracts/events.md](contracts/events.md) | four operations; events.md states that no event crosses a block boundary |
| sequence-writer | [sequences.md](sequences.md) | three flows: sign in, draw a member screen, fetch the state-change token |

## Checks

At the gate, after the fixes and the reconcile, all four scripts exited 0:

- data-model: pass
- migrations: pass
- api-contract: pass
- sequences: pass

The first gate run, before the fixes, failed three of the four:

- data-model: nine `FAIL` lines, each a field with an underscore read as "named nowhere in the spec"
  (`Profile.memberid` and the like), because the check strips `_` from the Field cell. Raised to
  the Originator as S1.
- migrations: eleven `FAIL` lines, each a column "created or altered and no field of that entity is
  named so" (`profile.member_id` and the like), for the same reason. Raised as S1.
- api-contract: `FAIL contracts/events.md: the spec's Approach names an asynchronous flow and
  contracts/events.md does not exist`, matched on the words "security events" and a mermaid
  `classDef queue`. Raised as S2.
- sequences: pass.

Gate checks that held a writer at its stop:

- data-modeller, the diagram hook: the mermaid fence was not closed; it added the closing fence.
- data-modeller, the duplicate-prose hook: the Session lifecycle row repeated 12 words of the spec;
  it reworded the row.
- data-modeller, the prose hook, a bare id: "spec 0005" carried no link; it linked both mentions
  with the gloss "choose a display name".
- sequence-writer, the prose hook, a bare id: the criterion links on lines 9 and 49 carried no gloss;
  it added one to each.
- contract-writer, in correct mode, the contract proof on `contracts/events.md` (S2): it wrote the
  file.

## Findings

- F: S1, the data model and migrations script checks fail on every field and column with an
  underscore, since the check strips `_` from the data model's Field cell; blocking (script check,
  2026-11-20)
  D: fix, the data modeller renamed every field to camelCase with its column named in the Meaning,
  and added a `derived:` note where the spec does not name the field
- F: S2, the api-contract check asks for `contracts/events.md` because the Approach holds the words
  "security events" and `classDef queue`; the spec has no asynchronous flow; blocking (script check,
  2026-11-20)
  D: fix, the contract writer wrote `contracts/events.md` stating that no event or message crosses a
  block boundary and that the security events are log records under the logging concept
- F: F1, `contracts/openapi.yaml` lines 47-61: `completeSignIn` requires `state`, while its 302 and
  400 and the spec's failure paths handle a missing state; blocking (contracts-critic, 2026-11-20)
  D: fix, `state` is optional, its description pointing to the spec's failure paths
- F: F2, a defect in the spec, Approach and Failure paths: no outcome is stated for a provider error
  response on the callback with no `code`; non-blocking (contracts-critic, 2026-11-20)
  D: defer, no criterion names the case, and
  [AC-0001-4](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria)
  (a confirmed account holder signs in) is the success path; it goes to the spec's next amendment
- F: F3, `sequences.md` lines 19-25: `startSignIn` is drawn from the Web client, where the spec has
  a browser navigation; non-blocking (contracts-critic, 2026-11-20)
  D: fix, `startSignIn` is drawn from the Member's browser and the "sign-in is unavailable" line is
  dropped
- F: F4a, `sequences.md` lines 28-39: the callback's error branches answer before the code exchange,
  and the 503 of `startSignIn` draws no metadata fetch; non-blocking (contracts-critic, 2026-11-20)
  D: fix, the state check, the code exchange and the token checks are drawn in the spec's order, and
  the metadata fetch precedes the 503
- F: F4b, a defect in the spec: who renders the problem responses to a browser navigation is not
  stated; non-blocking (contracts-critic, 2026-11-20)
  D: defer, no criterion names those screens; it goes to the spec's next amendment
- F: F5, `sequences.md` lines 67-74: the member screen waits on `getSession`, an ordering the spec
  does not ask for; non-blocking (contracts-critic, 2026-11-20)
  D: fix, the member screen waits on `getCurrentMember` alone, and the token fetch is its own flow
- F: F6, `sequences.md` line 49: the flow cites
  [AC-0001-12](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria)
  (a signed-out visitor opens the display-name screen), which this spec does not answer;
  non-blocking (contracts-critic, 2026-11-20)
  D: fix, the citation is dropped
- F: F7, `contracts/openapi.yaml` lines 165-169: `Problem` requires only `type` and `status`;
  non-blocking (contracts-critic, 2026-11-20)
  D: fix, `title` and `correlationId` are required as well
- F: F8, `contracts/openapi.yaml` lines 39-61: the sign-in and session cookies of `completeSignIn`
  are not documented; non-blocking (contracts-critic, 2026-11-20)
  D: fix, both are optional `in: cookie` parameters, each quoting the spec
- F: F9, `contracts/openapi.yaml`, all four operations: no 500 is documented; non-blocking
  (contracts-critic, 2026-11-20)
  D: fix, every operation answers a 500 problem response
- F: F10, `contracts/openapi.yaml` lines 162-164: `memberId` carries no pattern; non-blocking
  (contracts-critic, 2026-11-20)
  D: fix, `memberId` carries `^M-[0-9A-HJKMNP-TV-Z]{8}$`
- F: F11, `migrations/02_create_session.up.sql` line 3: `varchar(64)` assumes a hex encoding the
  data model does not state; non-blocking (contracts-critic, 2026-11-20)
  D: fix, the data model states `sessionHash` as 64 characters of lower-case hex
- F: F12, `migrations/01_create_profile.up.sql` line 2: `CREATE SCHEMA IF NOT EXISTS` against an
  unconditional drop in the rollback; non-blocking (contracts-critic, 2026-11-20)
  D: fix, the forward script reads `CREATE SCHEMA accounts`
- F: F13, `migrations/`: three staged pairs, where the spec's Rollout names one Alembic revision;
  non-blocking (contracts-critic, 2026-11-20)
  D: override, the derivation guideline asks for one change per pair, the end state and the full
  downgrade match the spec, and the task that promotes the pairs may fold them into one revision

## Reconcile

- migration-writer, given the diff of [data-model.md](data-model.md): changed
  `migrations/02_create_session.up.sql`, adding a CHECK that `session_hash` is 64 characters of
  lower-case hex; no change to the other pairs.
- contract-writer, given the diff of [data-model.md](data-model.md): no change.
- sequence-writer, given the diff of [contracts/](contracts/): no change.

## Escalations

None.

## Outcome

Approved.

Approved by Igor Roid, encraze@gmail.com, on 2026-11-20, in human mode.
