---
status: draft
owner: Igor Roid
updated: 2026-11-18
---

# Risks and technical debt

## Risks

| Risk | Accepted in |
|---|---|
| Two languages, two toolchains and two dependency sets to keep current | [0001 — Application stack](09-architecture-decisions/0001-application-stack.md#costs) |
| A screen change often spans the API and the Web client, with the generated types rebuilt | [0001 — Application stack](09-architecture-decisions/0001-application-stack.md#costs) |
| The first screen appears after the client loads, and search engines see little of a project page | [0001 — Application stack](09-architecture-decisions/0001-application-stack.md#costs) |
| A figure on screen stays as loaded until the member reloads or acts | [0001 — Application stack](09-architecture-decisions/0001-application-stack.md#costs) |
| CPU-heavy work in a request holds a worker until it moves to a background job | [0001 — Application stack](09-architecture-decisions/0001-application-stack.md#costs) |
| Module boundaries hold only by convention and review | [0002 — Module structure](09-architecture-decisions/0002-module-structure.md#costs) |
| A fault in one module takes the whole portal down | [0002 — Module structure](09-architecture-decisions/0002-module-structure.md#costs) |
| All modules scale together, as copies of the whole application | [0002 — Module structure](09-architecture-decisions/0002-module-structure.md#costs) |
| A failed write between row and file can leave an orphaned file | [0003 — Data persistence](09-architecture-decisions/0003-data-persistence.md#costs) |
| A conflicting write is refused and the member acts again | [0003 — Data persistence](09-architecture-decisions/0003-data-persistence.md#costs) |
| Random UUID keys enlarge indexes at volumes beyond the pilot | [0003 — Data persistence](09-architecture-decisions/0003-data-persistence.md#costs) |
| Keycloak is a service to patch, and a flaw in it exposes every account | [0004 — Identity provider](09-architecture-decisions/0004-identity-provider.md#costs) |
| Keycloak takes the largest share of the host's memory | [0004 — Identity provider](09-architecture-decisions/0004-identity-provider.md#costs) |
| Nobody can sign in while Keycloak is down | [0004 — Identity provider](09-architecture-decisions/0004-identity-provider.md#costs) |
| Account mail stops at the Gmail account's daily limit, or while Google holds the account | [0004 — Identity provider](09-architecture-decisions/0004-identity-provider.md#costs) |
| The single host is a single point of failure for the whole portal | [0005 — Production hosting](09-architecture-decisions/0005-production-hosting.md#costs) |
| The database is lost with the host's disk, since no backup is taken | [0005 — Production hosting](09-architecture-decisions/0005-production-hosting.md#costs) |
| The project patches the host's software itself, and no alert fires when the host fails | [0005 — Production hosting](09-architecture-decisions/0005-production-hosting.md#costs) |
| Secrets on the host's disk are readable by anyone with root | [0005 — Production hosting](09-architecture-decisions/0005-production-hosting.md#costs) |
| A release builds on the production host while it serves, and needs an administrator's machine with SSH access | [0005 — Production hosting](09-architecture-decisions/0005-production-hosting.md#costs) |
| Growing past one host requires moving PostgreSQL off it first | [0005 — Production hosting](09-architecture-decisions/0005-production-hosting.md#costs) |

## Technical debt

No technical debt is registered.
