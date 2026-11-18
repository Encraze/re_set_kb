---
status: draft
owner: Igor Roid
updated: 2026-11-18
---

# Delivery

**Dependencies are locked.** uv manages the Python version and the packages, and npm the Web
client's packages on a pinned Node LTS release, each from a lock file in the product repo; every
build and every CI run installs from the lock files. Node is used to build the Web client and runs
nowhere in production.

**Every change is checked the same way.** Ruff lints and checks the formatting of the Python code
and mypy checks its types; ESLint and Prettier do the same for the Web client, and vue-tsc checks
its types. The unit and functional suites run, with the unit line coverage held to the
[test coverage requirement](../10-quality-requirements.md#non-functional-requirements). The CI
workflow runs on GitHub Actions on every push and pull request, and a red check blocks the merge.
GitHub Actions runs these checks only and deploys nothing. Actions and base images are pinned to a
version.

**What runs is container images.** The application's image is built from the Python lock file.
The reverse proxy's image is Caddy's published image at a pinned version with the Web client's
built files added, built from the npm lock file. The identity provider and the database run from
their published images at pinned versions. No image registry holds the portal's images. A release applies the database migrations, then
replaces the application and reverse proxy containers.

**A release starts from a version tag.** An administrator runs the release script from their own
machine. It connects to the host over SSH, which the host's security group allows from named
administrator addresses only, checks out the tagged commit of the product repo on the host, and
builds and starts the stack there with `docker compose build` and `docker compose up`, from
`compose.yaml` alone, applying the migrations before the new application container takes traffic.
No CI workflow and no cloud secret store take part in a release.

**GAP-0002, release script and AWS resources not built.** The product repo holds the compose
file and every image's build, and nothing yet creates the release script or the AWS resources
production runs on: the EC2 host, its security group, its Elastic IP, its instance role and the
upload bucket. Both are to be built before the first production release; the skeleton covers the
local stack only.
