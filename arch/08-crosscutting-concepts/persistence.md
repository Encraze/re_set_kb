---
status: draft
owner: Igor Roid
updated: 2026-11-18
---

# Persistence

The reasons behind this concept are argued in
[data persistence](../09-architecture-decisions/0003-data-persistence.md).

**One database, one schema per module.** The portal's data lives in one PostgreSQL database, and
each module's tables sit in a schema named for the module. A module reads and writes its own
schema and no other; data another module holds comes through that module's interface. The
identity provider keeps its own database on the same server, which the portal never queries.

**Access goes through SQLAlchemy 2.0** inside each module's infrastructure layer. Queries are
parameterised and bounded, and a repository returns the module's own objects, never driver rows.

**Ids are random UUIDs that PostgreSQL generates** when a row is inserted. An id says nothing
about order or count, so it can be shown in a URL.

**Every table that two writers may update carries a version column.** An update names the version
it read and fails when another write came first; the member is shown the current state and
decides again.

**One use case, one transaction**, opened in the module's application layer. No remote call, to
the object store or the identity provider, runs inside a transaction.

**Schema changes are Alembic migrations** in one linear history in the product repo, applied by
the release before the new version of the application takes traffic. Each migration is written to
work with the version still running: add first, move the data, remove in a later release.

**Files go to the upload bucket, never into the database.** The owning module keeps the object's
generated key and its metadata in a row; the object is written before the transaction that inserts
the row opens, and removed after the transaction that deletes the row commits.
