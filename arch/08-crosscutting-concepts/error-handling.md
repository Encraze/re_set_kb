---
status: draft
owner: Igor Roid
updated: 2026-11-18
---

# Error handling

A module raises a typed business error for each rule it enforces, named for what went wrong in
the domain, such as a pledge that may no longer change. It never raises an HTTP status.

One handler in the API block maps every error to a response, so no route catches errors on its
own:

- Every error is answered with a problem details body as RFC 9457 defines it, with a type, a
  title, the status and the correlation id.
- The Web client turns a problem response into a readable message that says what the member can
  do next and shows the correlation id.
- A business error maps to the 4xx status that fits it; a validation failure lists the fields
  that failed.
- An unexpected error is logged once, with its stack trace and the correlation id, and answered
  with a generic 500 that reveals nothing of the inside: no trace, query, path or version.

An error during a write leaves no change behind: the use case's transaction rolls back as a whole.
