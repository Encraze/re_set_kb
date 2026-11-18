---
status: accepted
owner: Igor Roid
updated: 2026-11-18
decision: 0002
---

# 0002 — Module structure

## Context

The [idea brief](../../intents/0001-build-a-portal/idea-brief.md) (build a portal) describes
several parts a member would name apart: profiles and verification, project pages, joining a
project, pledges and totals, forum threads, and flags with their rulings. The pilot has a small
team and a small load, and the Originator asked for minimal infrastructure. How the code is cut
decides where every later feature lands and what can be split off later.

## Options

- **A modular monolith cut by capability.** One process and one database, with modules that own
  their data and talk through narrow interfaces; a module can become a service later if a reason
  appears.
- **A monolith cut by technical layer**, with all routes in one package, all models in another.
  The fastest start, and every feature then touches every layer, with nothing stopping one area
  from reading another's tables.
- **Separate services per capability.** Independent deployment and scaling, at the price of a
  network call, a contract and a deployment for each boundary, which a pilot of this size does
  not use.

## Decision

The portal is a modular monolith with six domain modules, Accounts, Projects, Participation,
Funding, Discussion and Moderation, and an API block in front of them that the Web client calls, as the
[building block view](../05-building-block-view.md) draws. Each module is a package of the one
application with a public interface, its own PostgreSQL schema and layers inside it; other
modules call the interface, pass ids and plain data, and never read another module's tables.
Modules depend on each other in one direction only, with no cycle.

## Consequences

### Buys

- One process to run and debug, with in-process calls and one transaction per use case.
- A module can be specified, built and reviewed on its own, and a feature lands in the module that owns it.
- A module with clean boundaries can move into a service of its own later without a rewrite of its callers.

### Costs

- Module boundaries hold by convention and review, since Python lets any package import any other; a shortcut across a boundary is easy to write and costly to find later.
- A fault in one module, such as a leak or a crash, takes the whole portal down with it.
- The modules scale together: a busy Funding module means more copies of the whole application.
