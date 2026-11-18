# CLAUDE.md

This repository is the AI context repo of the project `re-set-kb`. It holds every artifact
the spec-first-sdlc pipeline writes about the product, and nothing of the product itself: the
code lives in the product repo beside this one, at the path `productRepo.root` names in
`spec-first-sdlc.yaml`. The pipeline's
configuration is `spec-first-sdlc.yaml` at this root, which every stage reads, and a session
starts in this directory. The pipeline's first command wrote this file; the project edits it like
any other committed file.

## Layout

| Area | Holds |
|---|---|
| `intents/` | One directory per intent, `<NNNN>-<slug>/`, with its `idea-brief.md` and `report.md`, and `intent-tracker.md` |
| `roadmap/` | `roadmap.md`, the project's steps with their source, size, route and status; the documents a person brought, under `sources/`; one record per roadmap run under `_runs/` |
| `prd/` | One PRD per roadmap step, `<NNNN>-<slug>.md`, `prd-tracker.md`, and the PRD leg's records under `_runs/` |
| `arch/` | The arc42 tree, one file per section, the decision records, `skeleton.md`, and under `_runs/` the foundation's, the scaffold's and the architecture leg's records |
| `spec/` | One directory per spec, `<NNNN>-<slug>/`: the spec, its `report.md`, the files derived from it (`data-model.md`, `migrations/`, `contracts/`, `sequences.md`) with their `contracts-report.md`, and `plan/` with `plan.md` and one file per task; `spec-tracker.md` |
| `ui/` | UI prototypes, one directory per PRD, each with its screen manifest, `screens.md` |
| `kb/` | The knowledge base, one file per module the arc42 tree names |
| `tests/` | What outlives a plan: one directory per PRD with its `test-cases.md`, and `regression/` |

A tracker is an index, rewritten by the stage that owns it. A `_runs/` record or a `report.md`
is the run's own account; it is generated, committed and never edited by hand.

## The pipeline

| Stage | Command | Produces |
|---|---|---|
| 01 Foundation | `/spec-first-sdlc:intent` per need; `/spec-first-sdlc:foundation` and `/spec-first-sdlc:scaffold` once; `/spec-first-sdlc:roadmap` whenever the scope changes | an idea brief, the arc42 baseline, the roadmap of sized steps, the skeleton in the product repo |
| 02 Spec | `/spec-first-sdlc:prd <step_num>`, then `/spec-first-sdlc:arch <prd_num>` and `/spec-first-sdlc:specification <prd_num>`, then `/spec-first-sdlc:contracts <spec_num>` per spec | the step's PRD, the arc42 change, the specs, and each spec's derived files |
| 03 Plan | `/spec-first-sdlc:plan <spec_num>` | `plan.md` and the task files |
| 04 Execution | `/spec-first-sdlc:execute <spec_num>`; `/spec-first-sdlc:fix <spec_num>` for tasks sent back | code and unit tests on the plan's branch, in the product repo |
| 05 Test | `/spec-first-sdlc:test <spec_num>` | functional tests and the plan's test report |
| 06 CI and PR | `/spec-first-sdlc:pr <spec_num>`; `/spec-first-sdlc:corrections` for findings sent back | the merged pull request, the knowledge base |

Each command runs in the main thread as a conductor and dispatches every step to a subagent
of the plugin. Skills and agents are always named with the plugin's prefix, as above.

## How this repository is worked

**Read before you write.** Every artifact names its sources in its frontmatter: the intent, the
PRDs, the arc42 sections, the spec. Read them in full, and the guideline the step preloads,
before producing anything. An artifact written from a summary of its sources is the most
expensive thing this pipeline makes, because every step after it builds on the summary.

**Get it right where it is produced.** Sending an artifact back costs every leg after it, every
gate again, and the work that waited. So the check belongs at the moment of writing: before a
spec is handed to its challenger, ask whether it is one product increment that plans into a
handful of tasks; before a task is handed to its reviewer, ask whether its change can be read in
one sitting. A round spent now is cheaper than a stage spent later, and a reactive rework is the
one move to avoid.

**A committed artifact is never edited.** Upstream is frozen. What a later step finds wrong in
an approved artifact becomes a recorded finding and a new artifact, never a quiet correction.

**State what is true now.** No artifact narrates its own history: no "previously", no
changelog, no note on what an earlier version got wrong. One statement, one home; everything
else links there.

**No blank sections and no invented answers.** A gap is a finding with an id, or a question put
to the Originator. An empty section and an open question look the same in a diff, and only one
of them is honest. Where a step may not decide, it escalates; it never guesses.

**Main line only.** Every commit here is a checkpoint's, on the branch `origin` names. Nothing
is reviewed through a branch or a pull request in this repository.

## How code is written in the product repo

Adapted from the Karpathy-inspired `CLAUDE.md` by Forrest Chang. These bias toward caution over
speed; for a trivial change, use judgement.

**Think before coding.** State the assumptions. Where two readings of a criterion exist, name
both rather than picking one silently. Where a simpler approach exists, say so. Where something
is unclear, stop and name it, through the escalation the stage provides.

**Simplicity first.** The minimum code that answers the criterion, and nothing speculative: no
feature nobody asked for, no abstraction for single-use code, no configurability that was not
requested, no handling of a case that cannot happen. If two hundred lines could be fifty,
rewrite them.

**Surgical changes.** Touch only what the task names. Match the style around the change, even
where another would be preferred. Mention unrelated dead code rather than deleting it, and
remove only what the change itself orphaned. Every changed line traces to a criterion in the
task file.

**Goal-driven execution.** The acceptance criterion is the check. Write the test that fails
before the code that makes it pass; for a bug, the test that reproduces it first. For a task of
several steps, state the plan with a check per step, and loop until each check holds.
