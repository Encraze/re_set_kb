---
status: accepted
owner: Igor Roid
updated: 2026-11-18
decision: 0005
---

# 0005 — Production hosting

## Context

The Originator asked for the simplest pilot, with minimal infrastructure, runnable on a
developer's machine, on AWS with S3 for files. Where the portal runs decides how it is released
and recovered, and what it costs each month.

## Options

- **One EC2 host running the same container stack as a developer machine**, with S3 for files.
  About 40 USD a month at on-demand prices for a 4 GB host, its disk and its address,
  plus cents for S3; the project runs the database, the identity provider and the patching.
- **Managed services: ECS Fargate, RDS for PostgreSQL across two zones, Cognito.** Higher
  availability and no host to patch, several times the monthly cost, and a production that looks
  nothing like a developer machine.
- **A platform as a service outside AWS.** Little operations work, and a second vendor beside S3,
  with its own limits on long-lived connections and background jobs.

## Decision

Production is one EC2 host in one region. It runs every instance of the
[deployment view](../07-deployment-view.md) as a container, from one compose file that a
developer machine runs as well: the reverse proxy, the application, PostgreSQL and Keycloak. The
database's data sits on the host's encrypted disk, and no backup of it is taken. Uploaded files
live in a private bucket outside the host, and Keycloak's mail leaves through Gmail's SMTP relay.
The application and Keycloak reach the bucket and the relay at an endpoint set per environment, so
a developer machine and CI point them at local stand-ins with the same code. The host reaches the
bucket through an instance role scoped to that bucket alone, the one IAM grant the system uses, so
no AWS key is stored anywhere. A release is built on the host itself: an administrator's script
connects over SSH, checks out the tagged commit and rebuilds and restarts the stack with Docker
Compose, with no image registry and no deploy pipeline in between
([delivery](../08-crosscutting-concepts/delivery.md)).

## Consequences

### Buys

- The lowest running cost of the options, and one bill from one provider.
- Production and a developer machine run the same services at the same versions.
- The product repo holds the compose file and every image's build, so the software on a host is rebuilt from the repo and the secrets; the AWS resources around the host are not in it, per [GAP-0002](../08-crosscutting-concepts/delivery.md) (release script and AWS resources not built).

### Costs

- The host is a single point of failure: when it or its zone fails, the whole portal is down until a new host is stood up.
- The database is lost with the host's disk, since no backup of it is taken.
- The project patches the operating system, PostgreSQL and Keycloak itself, and nobody is paged when the host fails.
- Secrets sit as files on the host's disk, readable by anyone with root on it.
- A release builds the portal's images, the application and the Web client inside the reverse proxy's, on the production host, using its CPU and memory while it serves, and runs only from an administrator's machine with SSH access to it.
- Growing beyond one host means moving PostgreSQL off it first, onto a managed database or a host of its own.
