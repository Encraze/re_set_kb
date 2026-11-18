---
status: approved
owner: Igor Roid
updated: 2026-11-18
---

# Scaffold record

[`skeleton.md`](../skeleton.md) lists the tasks that build the product repo's skeleton.

## Answers

- Product repo: `../re_set`, a clone of `git@github.com:encraze/re_set.git` that had no commits before the skeleton.
- Default branch: `master`, which the skeleton's commit creates.
- Git platform: `gh`.
- Security scan in CI: no.

## Tasks

- [S1](../skeleton.md#s1--python-project-with-the-module-packages-and-the-api-entry-point), Python project, module packages and API entry point: done. `portal.main:app` serves `/api/health`.
- [S2](../skeleton.md#s2--vue-web-client-in-typescript-with-vite-vue-router-and-api-types-generated-from-the-openapi-document), Vue web client: done. Node 22.7.0 on the build machine limits it to Vite 6.4, vue-router 4.6, Vitest 4 with happy-dom, and TypeScript 5.9.
- [S3](../skeleton.md#s3--unit-test-runners-for-the-api-and-the-web-client-each-with-a-line-coverage-summary), unit runners with coverage: done.
- [S4](../skeleton.md#s4--linters-and-type-checkers-for-the-api-and-the-web-client), linters and type checkers: done.
- [S5](../skeleton.md#s5--container-images-compose-stack-with-healthchecks-local-stand-ins-for-the-object-store-and-mail-and-the-smoke-script), images, compose stack, stand-ins and smoke script: done, except the local object store stand-in and its credentials, which were dropped. MinIO's official images no longer pull, and the Originator answered "Skip local. We'll go with S3 only". The Mail stand-in is Mailpit.
- [S6](../skeleton.md#s6--migration-tool-with-an-initial-empty-migration), migration tool and empty `0001` migration: done. SQLAlchemy is pinned to `>=2.0,<2.1`.
- [S7](../skeleton.md#s7--functional-test-runner-that-drives-a-real-browser-against-the-running-application), browser-driven functional runner: done. Playwright with Chromium, one case.
- [S8](../skeleton.md#s8--ci-workflow-for-lint-types-unit-tests-with-coverage-migrations-and-functional-tests), CI workflow: `.github/workflows/ci.yml` is written, with its four action tags checked through `gh api`. Its done-when, `gh run list --workflow ci.yml`, can only hold once the skeleton's commit is on `origin`.
- [S9](../skeleton.md#s9--the-product-repos-claudemd), the product repo's `CLAUDE.md`: done. The grep in its done-when prints 7.

The Scaffolder added three scripts and four web files that the tasks' Creates lists do not name: `scripts/migrate.sh`, `scripts/functional.sh` and `scripts/local-secrets.sh`, plus `web/tsconfig.app.json`, `web/tsconfig.node.json`, `web/.prettierignore` and `web/src/api/client.spec.ts`. It installed `uv` on the machine with `pip install --user uv`.

## Smoke test

Every command exited 0 against Docker engine 29.6.2:

- Smoke: `bash scripts/smoke.sh`. Proxy, app, db, Keycloak and Mailpit all reached healthy, `/api/health` returned `{"status":"ok"}` and `/` returned `index.html` through Caddy, then the stack was torn down.
- Lint: the `lint` command in the frontmatter of [`skeleton.md`](../skeleton.md), unchanged. It came back clean.
- Unit: the `test` command in the same frontmatter, unchanged. Pytest ran 8 tests at 95.83% line coverage, and Vitest ran 3 at 100%. Both enforce an 80% floor.
- Coverage summaries:
  - API: `coverage.xml`, Cobertura.
  - Web: `web/coverage/coverage-summary.json`, Istanbul json-summary, held to its floor by Vitest.
- Migrations:
  - apply: `uv run alembic upgrade head`
  - revert: `uv run alembic downgrade -1`
  - both with the db started first, which `bash scripts/migrate.sh` does.
- Functional: `bash scripts/functional.sh`. Its tests are in `tests/functional/`, and it writes JUnit XML to `test-results/functional.xml`. One case passed in Chromium.

## Gate findings

None.

## Configuration

- `productRepo.root`: `../re_set`
- `productRepo.defaultBranch`: `master`
- `ci.provider`: `gh`
- `ci.securityScan`: `false`
- `build.smokeCommand`: `bash scripts/smoke.sh`
- `lint.command` and `test.command`: the `lint` and `test` commands in the frontmatter of [`skeleton.md`](../skeleton.md), word for word.
- `test.coverageReport.path`: `coverage.xml`
- `test.coverageReport.format`: `cobertura`
- `test.functionalCommand`: `bash scripts/functional.sh`
- `test.functionalPath`: `tests/functional/`
- `test.resultsPath`: `test-results/`

## Escalations

- Resumed: the product repo's working tree already held `.claude/settings.json` and `.idea/`. The Originator answered "Resume / keep (Recommended)". `.idea/` is git-ignored, and `.claude/settings.json` goes into the skeleton's commit.
- Question: MinIO's official images no longer pull, so which local S3 stand-in should the skeleton use? Answered "Skip local. We'll go with S3 only", answered by the Originator.
- Question: the S3-only answer contradicts [S5](../skeleton.md#s5--container-images-compose-stack-with-healthchecks-local-stand-ins-for-the-object-store-and-mail-and-the-smoke-script) (container images, compose stack and local stand-ins) and the stand-in's development credential in [`secrets.md`](../08-crosscutting-concepts/secrets.md). Commit the skeleton now, or correct the baseline first? Answered "Commit now (Recommended)", answered by the Originator. The baseline is corrected later, through `/spec-first-sdlc:intent`.

## Decision

The `gate · scaffold` proofs passed on the product repo's working tree at the Scaffolder's stop, before anything was committed.
