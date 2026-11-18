---
status: draft
owner: Igor Roid
updated: 2026-11-18
---

# Constraints

- No payment is taken, held or transferred by the system, and no contract is formed in it.
- The portal is open to anyone, worldwide, and its interface is in English.
- The system is a web application for desktop and phone browsers; there is no native app.
- A pledge's amount is seen by two people only: the project's owner sees every pledge on the project, and an investor sees their own pledge and no other; signed-out visitors see no money figure at all.
- No identity document is collected or stored.
- The system holds no user passwords; sign-in is delegated to an identity provider.
- The services the production host runs also run on a single developer machine; the object store and the mail relay, which sit outside the host, are reached at an endpoint set per environment.
