---
status: draft
owner: Igor Roid
updated: 2026-11-20
---

# Crosscutting concepts

How each concern that spans the building blocks is handled, one file per concept.

| Concept | Holds |
|---|---|
| [Authentication and authorisation](authentication-and-authorisation.md) | sign-in and the account pages at the identity provider, the session, and where access is decided |
| [Data classification](data-classification.md) | the classes of data the system holds, where each lives and who may read it |
| [Secrets](secrets.md) | where secrets are kept, how they reach a container, how they rotate, who reads them |
| [Input validation](input-validation.md) | how what crosses the browser boundary is checked, uploaded files included |
| [Error handling](error-handling.md) | how failures become problem responses and the messages the Web client shows |
| [Logging](logging.md) | what is recorded, where it goes, and what never is |
| [Persistence](persistence.md) | how modules keep their data, identify records and change the schema |
| [Delivery](delivery.md) | how the code is built, checked and packaged |
