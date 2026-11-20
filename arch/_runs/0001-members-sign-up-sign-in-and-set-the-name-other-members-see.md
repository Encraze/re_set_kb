---
status: draft
owner: Igor Roid
updated: 2026-11-20
---

# Architecture leg record: Member accounts and display names

PRD: [PRD 0001](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md), Member accounts and display names
Step: [step 2](../../roadmap/roadmap.md), members sign up, sign in and set the name others see
Follows: [0002-members-sign-up-sign-in-and-set-the-name-other-members-see.md](../../prd/_runs/0002-members-sign-up-sign-in-and-set-the-name-other-members-see.md), the PRD leg's record for step 2

## Changes

- [Authentication and authorisation, Account pages](../08-crosscutting-concepts/authentication-and-authorisation.md#account-pages), new: sign-up, confirmation, sign-in and recovery on the identity provider's own pages in the portal's look, with no page telling whether an address has an account, and the API block holding a member with no display name to setting one.
- [Data classification](../08-crosscutting-concepts/data-classification.md): the Profile class gains the display name and the member id, which other members may see, and a member id carries nothing of the contact data.
- [Crosscutting concepts index](../08-crosscutting-concepts/README.md): the authentication and authorisation gloss names the account pages.
- [Building block view, Accounts](../05-building-block-view.md#accounts): the block's interface offers a member's display name and member id, and whether their profile is complete.
- [Glossary](../12-glossary.md): Display name and Member id added.

No other section and no decision record moved.

## Affected set

No committed spec exists: the spec area holds none, so no spec names a changed section.

## Depth

`easy`, chosen by the Originator when asked at the start of the leg, on the step's quick route.

The Architect returned these assumptions with its change:

- Assumed: account pages = the identity provider's own pages, themed to the portal's look and served on the portal's domain, because [ADR 0004](../09-architecture-decisions/0004-identity-provider.md) (identity provider) gives these flows to Keycloak and [context and scope](../03-context-and-scope.md) says the portal never sees credentials.
- Assumed: one message whether or not an address has an account = provider configuration and theme, with no portal code, because the pages are the provider's.
- Assumed: repeated failed sign-ins = slowed per account by the provider, because security practice asks for throttling and Keycloak does it with no new tool.
- Assumed: display-name gate = the API block refuses every member request except setting the name while Accounts reports the profile incomplete, because the Originator's answer to [P1](../../prd/_runs/0002-members-sign-up-sign-in-and-set-the-name-other-members-see.md#round-1-prototype) (no sign-out on the display-name prompt) treats sign-in as incomplete until a name is set, and one check point spares every later module from repeating it.
- Assumed: who may see a display name and member id = other members, with visitors left to later steps, because [PRD 0001, requirement 9](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (member id) says other members may see the id and the PRD leaves what visitors see to [steps 3, 6 and 8](../../roadmap/roadmap.md) (project page, joining, forum).
- Assumed: Accounts offers the display name, member id and profile completeness in its interface, because [steps 3, 6 and 8](../../roadmap/roadmap.md) (project page, joining, forum) show them through Accounts.
- Assumed: no non-functional requirement added = [GAP-0001](../10-quality-requirements.md) (quality targets not set) stands, because the PRD sets no number and leaves targets out of scope.
- Assumed: runtime and deployment views unchanged, because the flows run on Keycloak, which the deployment view already lists, and the main flow is clear without sign-in drawn.
- Assumed: no decision record added, because [ADR 0004](../09-architecture-decisions/0004-identity-provider.md) (identity provider) already decides these flows.

The Originator's answer to the list, put before the challenge: "Keep all (Recommended)". No line was vetoed.

## Size and route

Raise: size S to M
Raise: route quick to standard

The PRD carries a few outcomes in one area, sign-up with confirmation, sign-in and sign-out, recovery, and the display name with its member id, and 14 acceptance criteria against S's range of 3 to 6; the PRD leg's first challenge finding recorded the Originator's view that the step is M. The tree shows the work behind them spanning four parts of the system: the identity provider's configuration and its themed pages under the [account pages](../08-crosscutting-concepts/authentication-and-authorisation.md#account-pages) concept, the API block's first sign-in, session and request guard under [sign-in](../08-crosscutting-concepts/authentication-and-authorisation.md#sign-in), the [Accounts](../05-building-block-view.md#accounts) block's profile in its first tables, and the Web client's two member screens. That is more than one spec, which an S step's single short spec cannot hold. The provider carries sign-up, confirmation, sign-in and recovery as configuration, with one override of its registration template in the portal's theme, which supplies the password confirmation the provider requires and shows a sign-up with an address in use as a new one, and the portal writes code for the session, the profile and two screens only, which keeps the step within M. The route rises with the size to M's default, because the change opens the portal's first trust boundary with a member, and one round would leave its corrections unread.

## Escalations

- Raise: size S to M, the Architect's, with the evidence under [Size and route](#size-and-route)
- Raise: route quick to standard, the Architect's, with the evidence under [Size and route](#size-and-route)
- Question: two crosscutting concepts change and the running system carries neither until code changes, the [account pages](../08-crosscutting-concepts/authentication-and-authorisation.md#account-pages) in authentication and authorisation, and the display name and member id in the Profile class of [data classification](../08-crosscutting-concepts/data-classification.md); built in this run, with the spec leg writing the spec that carries them, or deferred as technical debt, the recommendation being to build them now. The answer, "(a) Build now (Recommended)", applied as worked out in this run, so nothing is registered under Technical debt, answered by the Originator

## Findings

### Round 1: challenge

- F: Authentication and authorisation, Account pages, and Size and route: a sign-up with an address already in use cannot be made to look like a fresh one by configuration; Keycloak shows "Email already exists" with duplicates disallowed and opens a second account with them allowed, and the section must state the mechanism; blocks (architecture-challenger, 2026-11-20)
  D: resolved, the [account pages](../08-crosscutting-concepts/authentication-and-authorisation.md#account-pages) concept states the mechanism, a theme override of Keycloak's registration template for an address in use; the Size and route evidence names the override beside the configuration
- F: Authentication and authorisation, Account pages: the display-name guard refuses sign-out and the reads the prompt needs, and says a member without a name has no portal session while the sign-in section opens one; blocks (architecture-challenger, 2026-11-20)
  D: resolved another way, as the Originator decided: "You can send whatever requests to the backend with that session, but it it's not a display name setup, the backend will return a status 'registration incomplete' and redirect to display-name setup. So you have the session but the request filter redirects you to the initial sign-in flow. Simple as that." The [account pages](../08-crosscutting-concepts/authentication-and-authorisation.md#account-pages) concept states the session from sign-in and the API block's request filter that turns away everything but the display-name setup and sign-out. Asked whether sign-out should pass the filter too, the Originator answered: "You can do that but the UI does not need to have that button."
- F: Glossary, Member id; Data classification; Building block view, Accounts: when the member id is created, and by whom, is left open and contradicts itself; blocks (architecture-challenger, 2026-11-20)
  D: resolved, Accounts creates the profile and generates the member id at the member's first sign-in: stated in the Accounts block's responsibility and in data classification, and the glossary's member id is held from the profile's creation at first sign-in
- F: Authentication and authorisation, Account pages: the concept does not say what the provider's sign-up form asks for, while Keycloak's default asks for a username and a first and last name; does not block (architecture-challenger, 2026-11-20)
  D: resolved, the [account pages](../08-crosscutting-concepts/authentication-and-authorisation.md#account-pages) concept names the e-mail address as the username and limits the sign-up form to it and a password

### Round 2: challenge

- F: Building block view, Accounts; Data classification; Glossary, Member id: the change meets the PRD's "every account holds, from its creation, a member id" only by reading "account" as the portal profile, since the account is created at sign-up at the provider and the profile and member id at first sign-in, and a confirmed account that never signed in holds no member id; does not block (architecture-challenger, 2026-11-20)
  D: resolved, as the Originator decided, "Treat as one flow (Recommended)": the [Accounts](../05-building-block-view.md#accounts) block states once that sign-up continues through the address confirmation into the first portal sign-in, where Accounts creates the profile and its member id, so a member holds the id from the moment they can use the portal
- F: Authentication and authorisation, Account pages, and Size and route: the sign-up form's "no other field" cannot be had by configuration alone, since Keycloak's registration form action refuses a form without a password confirmation equal to the password, and nothing says how the form meets it; does not block (architecture-challenger, 2026-11-20)
  D: resolved, as the Originator decided, "Fix as asked (Recommended)": the [account pages](../08-crosscutting-concepts/authentication-and-authorisation.md#account-pages) concept gives the existing override of the registration template the second job of supplying the password confirmation, and the Size and route evidence names it; size and route unchanged

### Round 3: review

- F: Authentication and authorisation, Account pages, lines 30-31 and 36-41: the sentences on open registration, confirmation before sign-in, and the messages that tell no one whether an address has an account repeat [PRD 0001, requirements 1, 2, 3 and 8](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (sign-up, confirmation, sign-in and recovery) (readable-prose §19), and "each show the message their other case shows" is hard to follow; does not block (architecture-reviewer, 2026-11-20)
  D: resolved, as the Originator decided, "Fix all as asked (Recommended)": the [account pages](../08-crosscutting-concepts/authentication-and-authorisation.md#account-pages) concept drops the repeated behaviour and links to those four requirements, keeping the provider's pages, the theme override and the provider's configuration
- F: Authentication and authorisation, Account pages, line 46: "at every sign-in until a name is saved" repeats [PRD 0001, requirement 5](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (display name) (readable-prose §19); does not block (architecture-reviewer, 2026-11-20)
  D: resolved, as the Originator decided, "Fix all as asked (Recommended)": the [account pages](../08-crosscutting-concepts/authentication-and-authorisation.md#account-pages) concept keeps the request filter and links to that requirement for the prompt
- F: Data classification, lines 20-22: "carries nothing of the member's contact data, so showing it reveals no e-mail address" repeats [PRD 0001, requirement 9](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (member id) (readable-prose §19); does not block (architecture-reviewer, 2026-11-20)
  D: resolved, as the Originator decided, "Fix all as asked (Recommended)": [data classification](../08-crosscutting-concepts/data-classification.md) keeps the member id's generation by Accounts at first sign-in and links to that requirement for its rules
- F: Glossary, lines 12-13: Display name's "Several members may hold the same one" and Member id's "unique to it and visible to other members, which tells apart members with one display name" repeat [PRD 0001, requirements 5 and 9](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements) (display name, member id); the glossary should define each term and leave the rules to the PRD (readable-prose §19); does not block (architecture-reviewer, 2026-11-20)
  D: resolved, as the Originator decided, "Fix all as asked (Recommended)": the [glossary](../12-glossary.md) keeps the definition of each term only
- F: Record form, lines 21-37: the subsection "Source items the PRD carries no requirement for" is no heading of the record template and repeats the PRD leg's source walk, and line 21 argues why sections did not move, which the template keeps out of the record; does not block (architecture-reviewer, 2026-11-20)
  D: resolved, as the Originator decided, "Fix as asked (Recommended)": the extra subsection and line 21's argument are deleted, and Changes ends on the line that no other section and no decision record moved

## Rounds

Three rounds of three, the `critique.rounds.standard.arc42` cell, since the raise put the leg on the standard route.

1. Round 1, challenge: three blocking findings and one that does not block, each applied as the Originator decided; the re-read that closed it confirmed every disposition and raised the two findings of round 2.
2. Round 2, challenge: two findings, neither blocking, applied as the Originator decided; with nothing blocking, the challenge loop ended on the apply.
3. Round 3, review: five findings from the Reviewer, none blocking, applied as the Originator decided; with nothing blocking, the round closed on the apply, and no finding was open at the cap.

## Review

One pass of `/spec-first-sdlc:review` by the architecture-reviewer, after round 2.

- The tree's form against the arc42 scaffold: all twelve sections and the two section directories with their indexes; no decision-record template file and no template guidance left in the tree; every building block a heading; every `F:` item carrying its `D:` line. All passed.
- The section names in committed specs: nothing to check, since no spec is committed.
- The record check: the `PRD:`, `Step:` and `Follows:` openings, the empty affected set, the two `Raise:` lines against step 2's row in the roadmap with their evidence, no external tool, no technical debt, no upstream finding. All passed.
- The walk: the PRD leg's [source walk](../../prd/_runs/0002-members-sign-up-sign-in-and-set-the-name-other-members-see.md#source-walk) marks no item for this leg, so nothing was left to place.
- The one diagram in a changed section, the building block view's, which this run left as it stood, passed the diagram rule.
- No open question in any of the five changed files.
- The gate proofs bound to the Reviewer's stop returned no failing proof.

It raised the five findings of round 3, none blocking.

## Outcome

Approved.

The Originator approved the change at the gate in human mode, on the Reviewer's clean checks and walk and with no finding open: Igor Roid, encraze@gmail.com, 2026-11-20.
