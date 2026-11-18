---
status: draft
owner: Igor Roid
updated: 2026-11-18
---

# Solution strategy

## Architectural style

The portal is a modular monolith: one back-end deployable, written in Python, cut into modules
along the capabilities of section 5's [building block view](05-building-block-view.md), with a
Vue web client in front of it. A module owns its behaviour and its tables, and other modules reach
it through its public interface only. The Web client and the API block hold no business rule;
the modules hold every one. Inside a module, dependencies
point inward where a module has rules worth protecting; a module that only stores and shows data
stays small and flat.

When a choice is open, lean toward what keeps one process, one database and a web client served
as static files, and add a moving part only for a named need with a number behind it from the
[non-functional requirements](10-quality-requirements.md#non-functional-requirements).

## Platform posture

The system runs on AWS, kept to one EC2 host and one S3 bucket. Its one AWS permission is the
host's instance role, scoped to that bucket; it uses no other IAM. Everything else on the host
runs as containers, and a developer machine runs the same containers, with local stand-ins for
the bucket and the mail relay, so the system could move to another provider by moving the host
and the bucket. Availability is single-host by design for the pilot.

Security is tiered with one public entry. Only the reverse proxy listens on the internet, and it
terminates TLS. The application, the identity provider and the database talk on the host's
private container network. Identity is delegated to the identity provider, access is denied unless
a module's policy grants it, and secrets reach a container as files.

## Third-party tool policy

A tool the tree does not name is the Originator's call before it enters. Proposals come in this
order: what the tree already names, then a free open-source tool under a permissive licence such
as Apache 2.0, MIT, BSD or the PostgreSQL licence, then a paid or managed service, put with its
monthly cost. Each proposal states the alternative of
doing without.
