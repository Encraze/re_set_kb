---
status: accepted
owner: Igor Roid
updated: 2026-11-18
decision: 0003
---

# 0003 — Data persistence

## Context

The portal holds relational data with rules between its parts: members, projects, roles on
projects, pledges whose totals must add up, and threads in order. It also holds photos and slide
decks. An owner and an investor may change the same pledge at once. The Originator chose PostgreSQL for
the data and S3 for files. The store, the mapping layer, the migration tool and the id scheme sit
under every module and every row written from the first feature on.

## Options

- **PostgreSQL for all records, S3 for files**, mapped with SQLAlchemy 2.0, migrated with
  Alembic. One relational store for every invariant, files kept out of it.
- **PostgreSQL with files stored in the database.** One store to back up, and a database that
  grows by the size of every upload and slows its own backups.
- **A document store for projects and threads beside a relational one for pledges.** A better
  fit for free-form page content, and a second store to run and keep in agreement with the first.

For ids, the choice was between sequential integers, which leak counts and order in a URL, and
random UUIDs, which reveal nothing and cost a little index space.

## Decision

All of the portal's records live in one PostgreSQL database, one schema per module. Modules map
them with SQLAlchemy 2.0, and Alembic migrations in the product repo change the schema. PostgreSQL
generates every id as a random UUID. Each table that two people may update at once carries a
version that every update checks, so the later of two conflicting writes fails and the member
sees the current state. Files go to a private S3 bucket under generated names; the owning module
keeps each file's key and metadata in a row. How these rules are applied day to day is the
[persistence](../08-crosscutting-concepts/persistence.md) concept.

## Consequences

### Buys

- Every invariant, such as a total matching its pledges, holds in one transaction on one store.
- Uploads never swell the database.
- Ids can appear in URLs without telling anyone how many projects or pledges exist.
- A schema change is a reviewed file in version control, applied the same way on every machine.

### Costs

- A row and its file live in two stores with no shared transaction, so a failure between the two writes can leave a file no row points to.
- A conflicting write is refused, and the member has to look at the current state and act again.
- Random UUID keys make indexes larger and inserts less local than sequential keys, which shows only well beyond the pilot's volume.
