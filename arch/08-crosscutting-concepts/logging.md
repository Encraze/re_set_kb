---
status: draft
owner: Igor Roid
updated: 2026-11-18
---

# Logging

Every container writes its log as JSON lines to standard output, and the host keeps them with
rotation by size. Each line carries the time, the level, the service, the request's correlation
id and, for a signed-in request, the member's id.

**The correlation id** is taken from the reverse proxy's request header, or generated at the API
block where none arrives, and passed into every module call and log line of the request. It is
shown with every error message the Web client displays, so a member can quote it.

**Recorded on every request**: method, route, status and duration, as the observability line of
the [non-functional requirements](../10-quality-requirements.md#non-functional-requirements)
asks.

**Recorded as security events**: sign-in and sign-out, refused permissions, failed validation at
volume, and every administrator action, an investor approval, a flag ruling, a reliability mark
set or lifted, with who did it and to what.

**Never recorded**: passwords, tokens, cookies and session ids, secret values, contact data, and
individual pledge amounts. Values a member typed are encoded before they reach a log line, so
input cannot forge one.

Every container on the host, the reverse proxy, the application, PostgreSQL and Keycloak,
declares a healthcheck in the compose file. The application answers liveness and readiness on
routes of its own; the other three are probed through the checks each of them provides.
