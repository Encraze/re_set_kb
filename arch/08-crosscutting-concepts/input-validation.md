---
status: draft
owner: Igor Roid
updated: 2026-11-18
---

# Input validation

Everything that arrives from a browser is untrusted until checked: form fields, query strings,
headers, cookies and files.

**Shape is checked at the API block, once.** Each request binds to a model that lists the fields
it accepts, with type, length, range and format, and anything else is refused. A request is never
bound straight to a stored record. Inside a module the checked values are trusted, and the module
checks only its business rules, such as which state a pledge may move to.

**Integrity is checked again by the database**: required values, uniqueness and references are
constraints on the tables, as the last line behind the module.

**Output is escaped by the Web client.** Vue escapes every value a screen shows, so member-written
text appears escaped everywhere; no screen inserts raw HTML from a member.

**Uploaded files** are accepted by an allow-list of types confirmed by both the
file's extension and its leading bytes; their largest size is not set, and is among the targets
[GAP-0001](../10-quality-requirements.md#non-functional-requirements) (quality targets not set)
records; the browser's declared content type is ignored. A file is
stored in the private upload bucket under a name the portal generates, and its original name is
kept only as metadata. It reaches a browser through the application after the same access check
as the page that shows it, and is sent as a download unless it is an image the page displays.

**Rates are bounded.** Sign-in, sign-up and every form that writes are rate-limited per client.
