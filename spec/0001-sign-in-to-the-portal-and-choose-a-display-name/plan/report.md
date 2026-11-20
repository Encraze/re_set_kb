---
status: approved
owner: Igor Roid
updated: 2026-11-20
---

# Plan report: Sign in to the portal

[plan.md](plan.md), the plan for Sign in to the portal.

## Gap

The spec was not parked.

## Validation

The validation script's last run on the plan exited 0, every check passing:

```
WALK AC-0001-4 0001-create-a-members-profile-and-member-id-at-the-first-sign-in.md
WALK AC-0001-4 0002-hold-a-members-session-and-refuse-requests-without-one.md
WALK AC-0001-4 0003-start-a-sign-in-at-the-identity-provider.md
WALK AC-0001-4 0004-draw-the-member-layout-for-the-signed-in-member.md
WALK AC-0001-4 0005-complete-the-sign-in-and-open-the-members-session.md
COUNT 5 size M range 3-7
ROWS unit 15
ROWS functional 3
ROWS e2e-through-ui 2
CONTEXT 0001-create-a-members-profile-and-member-id-at-the-first-sign-in.md M 93
CONTEXT 0002-hold-a-members-session-and-refuse-requests-without-one.md M 119
CONTEXT 0003-start-a-sign-in-at-the-identity-provider.md M 84
CONTEXT 0004-draw-the-member-layout-for-the-signed-in-member.md M 66
CONTEXT 0005-complete-the-sign-in-and-open-the-members-session.md M 100
```

## Criterion walk

| Criterion or outcome | Gloss | Carried by | Gloss |
|---|---|---|---|
| [AC-0001-4](../../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) | a confirmed holder signs in | [0001](0001-create-a-members-profile-and-member-id-at-the-first-sign-in.md) | profile and member id at the first sign-in |
| [AC-0001-4](../../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) | the same sign-in | [0002](0002-hold-a-members-session-and-refuse-requests-without-one.md) | Hold a member's session and refuse requests without one |
| [AC-0001-4](../../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) | the same sign-in | [0003](0003-start-a-sign-in-at-the-identity-provider.md) | Start a sign-in at the identity provider |
| [AC-0001-4](../../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) | the same sign-in | [0004](0004-draw-the-member-layout-for-the-signed-in-member.md) | Draw the member layout for the signed-in member |
| [AC-0001-4](../../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) | the same sign-in | [0005](0005-complete-the-sign-in-and-open-the-members-session.md) | Complete the sign-in and open the member's session |

## Task count

`COUNT 5 size M range 3-7`: five tasks, inside the range size M gives, so there is no note against
the spec's cut.

## Test plan

[test-plan.md](test-plan.md), the plan's test cases: 15 rows at `unit`, 3 at `functional` and 2 at
`e2e-through-ui`. No row is marked `qa`.

## Task context

- [0001](0001-create-a-members-profile-and-member-id-at-the-first-sign-in.md), profile and member id: `M`, 93 quoted lines.
- [0002](0002-hold-a-members-session-and-refuse-requests-without-one.md), the member's session: `M`, 119 quoted lines.
- [0003](0003-start-a-sign-in-at-the-identity-provider.md), starting a sign-in: `M`, 84 quoted lines.
- [0004](0004-draw-the-member-layout-for-the-signed-in-member.md), the member layout: `M`, 66 quoted lines.
- [0005](0005-complete-the-sign-in-and-open-the-members-session.md), completing the sign-in: `M`, 100 quoted lines.

No task is `L`.

## External factors

Two external factors stand in the
[External factors of task 0005](0005-complete-the-sign-in-and-open-the-members-session.md#external-factors)
(completing the sign-in), both read from the spec's
[Rollout](../0001-sign-in-to-the-portal-and-choose-a-display-name.md#rollout), and both `assumed`:
the portal client in the production realm, and the provider's back-channel hostname with the new
settings on the production host. Nobody gave either at the gate.

## Gate checks

- Validation script, the context-band proof: [task 0002](0002-hold-a-members-session-and-refuse-requests-without-one.md), the member's session, read `context: M` but measured 125 quoted lines, band L. The Planner removed the `x-criteria` lines and the 500 response from its getSession quote, marked the quote abridged, and added a line saying the handler the task builds gives the 500; it measured 119, `M`, and the next run passed.
- Duplicate-prose hook (readable-prose §19): each of these repeated text held elsewhere. The criterion bullet, copied across the task files, [spec 0001](../0001-sign-in-to-the-portal-and-choose-a-display-name.md) (sign in to the portal) and [spec 0002](../../0002-account-pages-at-the-identity-provider/0002-account-pages-at-the-identity-provider.md) (account pages at the identity provider). The Accounts block quote in [task 0001](0001-create-a-members-profile-and-member-id-at-the-first-sign-in.md) (profile and member id). The session-bullet quote in [task 0002](0002-hold-a-members-session-and-refuse-requests-without-one.md) (the member's session). The YAML quotes of the 500, problem-schema, startSignIn and completeSignIn lines. The opening paragraph of [task 0004](0004-draw-the-member-layout-for-the-signed-in-member.md) (the member layout). Two cases in [test-plan.md](test-plan.md). The Planner linked the criterion bullet to its siblings and sources, abridged the repeated quotes, rewrote the opening of [task 0004](0004-draw-the-member-layout-for-the-signed-in-member.md) (the member layout) around links, and reworded the two cases.
- Readability hook (readable-prose §18, bare id): sibling task ids in [task 0001](0001-create-a-members-profile-and-member-id-at-the-first-sign-in.md) (profile and member id), every task's Blockers line, and the ID and Blockers cells of the [plan.md](plan.md) table were bare ids. The Planner glossed them and made each a relative link.

## Corrections

The gate runs in agent mode, which asks for no corrections.

## Missing dependency

Not asked: the gate runs in agent mode.

## Decision

Gate mode `agent`, as `gates.plan` sets it. Approved on 2026-11-20, on the validation script's pass,
exit 0, with the output under [Validation](#validation) as the evidence.
