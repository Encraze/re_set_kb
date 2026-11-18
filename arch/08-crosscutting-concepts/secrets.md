---
status: draft
owner: Igor Roid
updated: 2026-11-18
---

# Secrets

**Where they are kept.** In production each secret is a file on the host, outside the checkout
of the product repo, owned by root and readable by root alone. Nothing secret is written into the
product repo, a container image, a log or an error message, and no secret is kept in the Git
platform's secret store. In production, access to S3 needs no stored key: the host's instance
role grants it for the upload bucket alone, and the AWS client in a container picks the role up at
runtime.

**How they reach a process.** The compose file declares each secret and mounts it, as a file,
into the containers that need it and no others. A service reads its secrets once at start, and the
configuration check at start fails the boot when one is missing or malformed. Environment
variables carry no secret value.

**How they rotate.** A secret is replaced by writing the new value to its file and restarting the
containers that read it; a password shared by two services, such as the database's, is changed in
the service that owns it first. Every secret is rotated at once when it may have been exposed and
when a person with access to the host leaves the project. A secret that reached the product repo
is revoked and replaced before it is removed from the history.

**Who may read them.** On the host, administrators, who reach it over SSH from named addresses
with their own keys, and the container each secret is mounted into. On a developer's machine, its
developer. In CI, the run itself, which writes development values for that run and holds no
production secret. The release script holds no secret of its own; it runs with the
administrator's SSH access to the host.

On a developer's machine and in CI every secret is a local file outside version control, holding a
value generated for that machine or, where production relies on the instance role, a static
development credential for the local stand-in of the object store; production values stay on the
production host. The application reads
the object store's endpoint and credentials the same way in every environment, so its code does
not change between them.
