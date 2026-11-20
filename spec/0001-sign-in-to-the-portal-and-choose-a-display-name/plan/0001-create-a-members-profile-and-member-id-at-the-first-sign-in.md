---
plan: spec/0001-sign-in-to-the-portal-and-choose-a-display-name/plan/plan.md
context: M
---

# Create a member's profile and member id at the first sign-in

Status: TO DO
Modules: Accounts, API
Surface: backend
Migrations: 01_create_profile, 02_create_session, 03_create_sign_in_attempt

Accounts gains its first table and its interface: ensuring the profile of a provider subject,
which creates the profile with a random member id the first time and reads it every time after,
and reading a member's display name, member id and completeness. The task also lands the one
Alembic revision that creates the schema `accounts` with all three of the spec's tables, the
profile, the session and the sign-in attempt; the session and sign-in attempt tables are used by
the tasks after it. The callback of
[task 0005](0005-complete-the-sign-in-and-open-the-members-session.md) (complete the sign-in) is
the first caller of the ensure operation.

## Acceptance criteria

- [AC-0001-4](../../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) "Given a confirmed account, When its holder signs in with the right e-mail address and password, Then they are signed in."
  Every task of this plan carries it:
  [task 0001](0001-create-a-members-profile-and-member-id-at-the-first-sign-in.md) (the profile and member id),
  [task 0002](0002-hold-a-members-session-and-refuse-requests-without-one.md) (the session and the request filter),
  [task 0003](0003-start-a-sign-in-at-the-identity-provider.md) (starting a sign-in),
  [task 0004](0004-draw-the-member-layout-for-the-signed-in-member.md) (the member layout) and
  [task 0005](0005-complete-the-sign-in-and-open-the-members-session.md) (the callback). The spec answers it in
  [Sign-in and the session](../0001-sign-in-to-the-portal-and-choose-a-display-name.md#sign-in-and-the-session),
  and [spec 0002](../../0002-account-pages-at-the-identity-provider/0002-account-pages-at-the-identity-provider.md)
  (account pages at the identity provider) answers it for the provider's own pages.

## Context

> Accounts' tables sit in the schema `accounts`. One table holds the profile: an id PostgreSQL
> generates, the provider's subject (unique), the member id (unique), the display name (empty until
> set), a version, and the times it was created and changed.
>
> The API block passes Accounts the subject and nothing else from the token, so the portal stores
> no e-mail address.
>
> A member id is `M-` followed by 8 characters of Crockford base32 (the digits and the capitals
> without I, L, O and U) drawn from `secrets`, so it is derived from nothing the account holds. A
> draw that collides with an existing id is drawn again, up to five times. Ensuring a profile inserts
> it and does nothing where the subject already has one, then reads it, so two first sign-ins at
> once create one profile. A profile is complete when its display name is set.
>
> Accounts' interface has two operations here: ensure the profile of a subject; and read a member,
> giving the display name or none, the member id and whether the profile is complete.
>
> — [0001-sign-in-to-the-portal-and-choose-a-display-name.md](../0001-sign-in-to-the-portal-and-choose-a-display-name.md) §Profile and member id, abridged

> One Alembic revision creates the
> schema `accounts` with its tables, applied before the new version takes traffic; its
> downgrade drops them, and after launch a rollback runs the previous version and leaves the tables
> in place.
>
> — [0001-sign-in-to-the-portal-and-choose-a-display-name.md](../0001-sign-in-to-the-portal-and-choose-a-display-name.md) §Rollout, abridged

> | Case | What the system does | What the member sees |
> |---|---|---|
> | Two first sign-ins at once | one profile with one member id, both sessions open | the same member in both tabs |
>
> — [0001-sign-in-to-the-portal-and-choose-a-display-name.md](../0001-sign-in-to-the-portal-and-choose-a-display-name.md) §Failure paths, abridged

> - Integration, pytest under `tests/integration` against the compose stack's PostgreSQL after
>   `alembic upgrade head`: unique member ids, two concurrent first sign-ins creating one profile,
>   and session expiry. A developer runs them with the database
>   service up, as the skeleton's migration check is run.
>
> — [0001-sign-in-to-the-portal-and-choose-a-display-name.md](../0001-sign-in-to-the-portal-and-choose-a-display-name.md) §Tests and local stand-ins, abridged

> Responsible for the members of the portal: each member's profile, keyed by the identity the
> provider confirms, the roles a member holds on the platform, and the state of an investor's
> verification with the administrator's approval of it.
>
> - Offers: who a member is, the display name and member id other members know them by, whether
>   their profile is complete, which platform roles they hold, and whether they are a verified
>   investor.
> - Uses: no other module.
>
> — [05-building-block-view.md](../../../arch/05-building-block-view.md) §Accounts, abridged

> **One database, one schema per module.** The portal's data lives in one PostgreSQL database, and
> each module's tables sit in a schema named for the module. A module reads and writes its own
> schema and no other; data another module holds comes through that module's interface.
>
> **Access goes through SQLAlchemy 2.0** inside each module's infrastructure layer. Queries are
> parameterised and bounded, and a repository returns the module's own objects, never driver rows.
>
> **Ids are random UUIDs that PostgreSQL generates** when a row is inserted.
>
> **Every table that two writers may update carries a version column.**
>
> **One use case, one transaction**, opened in the module's application layer.
>
> **Schema changes are Alembic migrations** in one linear history in the product repo, applied by
> the release before the new version of the application takes traffic.
>
> — [persistence.md](../../../arch/08-crosscutting-concepts/persistence.md) §Persistence, abridged

> 9. **Member id.** Every account MUST hold, from its creation, a member id that no other account
>    holds and that other members may see, so two members who share a display name can be told
>    apart. The member id MUST NOT reveal the member's e-mail address.
>
> — [PRD 0001](../../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md) §Requirements, abridged

> | Profile | display name, member id, real name, professional link, verification state, reliability mark | Accounts, Moderation | per the module's policy; a display name and a member id may be shown to other members, and a reliability mark is public |
>
> Data of each class stays in the module named for it. A copy in another module, a log line or an
> error message is a breach of this table.
>
> — [data-classification.md](../../../arch/08-crosscutting-concepts/data-classification.md) §Data classification, abridged

## Interfaces

No interface.

## Data

> The three tables sit in the PostgreSQL schema `accounts`, as the spec's Approach places them.
>
> — [data-model.md](../data-model.md) §Data model: Sign in to the portal, abridged

> | Field | Type | Required | Constraints | Meaning |
> |---|---|---|---|---|
> | id | uuid | yes | primary key, generated by PostgreSQL | "an id PostgreSQL generates" |
> | subject | string | yes | unique | the provider's subject, the identity the member signs in with |
> | memberId | string, `M-` plus 8 characters of Crockford base32 | yes | unique, drawn from `secrets`, redrawn up to five times on a collision | the member id Accounts generates at the first sign-in; stored in column `member_id` |
> | version | integer | yes | checked on update | "a version" the persistence concept requires on a table two writers update |
> | createdAt | timestamp UTC | yes | | derived: "the times it was created and changed"; column `created_at` |
> | changedAt | timestamp UTC | yes | | derived: "the times it was created and changed"; the time of the last change, column `changed_at` |
>
> — [data-model.md](../data-model.md) §Profile, abridged

> | Entity | Identifier | Unique |
> |---|---|---|
> | Profile | `id` | `subject` and `memberId`, each across the table |
> | Session | `sessionHash` | the hash, across the table |
> | SignInAttempt | `state` | the state, across the table, so an attempt is used once |
>
> — [data-model.md](../data-model.md) §Identifiers and uniqueness, verbatim

> | Entity | Fields | Query that needs it |
> |---|---|---|
> | Profile | `subject`, unique | ensuring a profile for the token's subject, and reading a member's profile |
> | Profile | `memberId`, unique | a drawn member id colliding with an existing one |
>
> — [data-model.md](../data-model.md) §Indexes, abridged

## Screens

No screen.

## Edge cases

| Case | Behaviour |
|---|---|
| Two first sign-ins for one subject at once | one profile with one member id exists afterwards, and both ensure calls return it |
| Ensuring the profile of a subject that already has one | nothing is inserted; the existing profile is read and returned unchanged |
| A drawn member id equals an existing one | the id is drawn again, up to five times, and the profile stores an id no other profile holds |
| Reading a member whose display name is empty | the read answers no display name, the member id, and an incomplete profile |
| Downgrading the revision | the schema `accounts` and its three tables are dropped |

## Subtasks

- Database: promote the three staged pairs into one Alembic revision,
  migrations/versions/0002_create_accounts_schema.py, whose upgrade creates the schema `accounts`
  with the profile, session and sign-in attempt tables and whose downgrade drops them.
- Backend: the member id generator, `M-` plus 8 Crockford base32 characters from `secrets`, in
  src/portal/accounts/member_id.py.
- Backend: the profile's mapping and the module's profile object in src/portal/accounts/models.py,
  and the repository that inserts a profile doing nothing on an existing subject, redraws on a
  member id collision, and reads a profile by subject, in src/portal/accounts/repository.py.
- Backend: Accounts' interface, ensure the profile of a subject and read a member, each one use
  case in one transaction, in src/portal/accounts/service.py, exported from
  src/portal/accounts/__init__.py.
- Tests: the member id's format and alphabet in tests/unit/accounts/test_member_id.py; unique
  member ids and two concurrent first sign-ins creating one profile against PostgreSQL in
  tests/integration/accounts/test_profile.py, with the database fixture in
  tests/integration/conftest.py.

## Done when

`tests/unit/accounts/test_member_id.py` proves every member id is `M-` and 8 characters of the
digits and the capitals without I, L, O and U, and `tests/integration/accounts/test_profile.py`,
after `alembic upgrade head`, proves two subjects get different member ids, ensuring one subject
twice, and twice at once, leaves one profile with one member id, and reading it answers an empty
display name and an incomplete profile.

## External factors

None: the task needs only the compose stack's PostgreSQL, which the skeleton runs.

## Questions
