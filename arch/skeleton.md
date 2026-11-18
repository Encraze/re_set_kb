---
build: "docker compose build"
test: "uv run pytest tests/unit --cov=portal --cov-report=term --cov-report=xml:coverage.xml && npm --prefix web run test:coverage"
lint: "uv run ruff check . && uv run ruff format --check . && uv run mypy src && npm --prefix web run lint && npm --prefix web run type-check"
migrate-apply: "uv run alembic upgrade head"
migrate-revert: "uv run alembic downgrade -1"
---

# Skeleton plan

The tasks below turn the [arc42 baseline](05-building-block-view.md) (the portal's building
blocks) into a product repo that builds, runs and checks itself, before any feature exists.

## Tasks

### S1 — Python project with the module packages and the API entry point

- Depends on: none
- Creates: pyproject.toml, uv.lock, .python-version, .gitignore, src/portal/__init__.py, src/portal/main.py, src/portal/config.py, src/portal/api/__init__.py, src/portal/api/routes.py, src/portal/accounts/__init__.py, src/portal/projects/__init__.py, src/portal/participation/__init__.py, src/portal/funding/__init__.py, src/portal/discussion/__init__.py, src/portal/moderation/__init__.py
- Done when: `uv run python -c "from portal.main import app; print(app.title)"` prints the application's title, and the app answers a health route.

### S2 — Vue web client in TypeScript with Vite, Vue Router and API types generated from the OpenAPI document

- Depends on: S1
- Creates: web/package.json, web/package-lock.json, web/.nvmrc, web/index.html, web/vite.config.ts, web/tsconfig.json, web/env.d.ts, web/src/main.ts, web/src/App.vue, web/src/router.ts, web/src/views/HomeView.vue, web/src/api/client.ts, web/src/api/schema.d.ts
- Done when: `npm --prefix web ci && npm --prefix web run build` exits 0 and leaves `web/dist/index.html`.

### S3 — Unit test runners for the API and the web client, each with a line coverage summary

- Depends on: S1, S2
- Creates: tests/unit/conftest.py, tests/unit/test_health.py, web/vitest.config.ts, web/src/App.spec.ts
- Done when: `uv run pytest tests/unit --cov=portal --cov-report=term --cov-report=xml:coverage.xml && npm --prefix web run test:coverage` passes and writes `coverage.xml` and `web/coverage/coverage-summary.json`.

### S4 — Linters and type checkers for the API and the web client

- Depends on: S1, S2
- Creates: ruff.toml, mypy.ini, web/eslint.config.js, web/.prettierrc.json
- Done when: `uv run ruff check . && uv run ruff format --check . && uv run mypy src && npm --prefix web run lint && npm --prefix web run type-check` exits 0.

### S5 — Container images, compose stack with healthchecks, local stand-ins for the object store and mail, and the smoke script

- Depends on: S1, S2
- Creates: Dockerfile, .dockerignore, compose.yaml, compose.override.yaml, deploy/caddy/Dockerfile, deploy/caddy/Caddyfile, deploy/keycloak/portal-realm.json, deploy/postgres/init-databases.sql, scripts/local-secrets.sh, scripts/smoke.sh
- Done when: `bash scripts/smoke.sh` writes the local secret files outside version control, including MinIO's static development credentials, then starts the reverse proxy with the web client's built files, the application, PostgreSQL and Keycloak from `compose.yaml`, with MinIO holding the upload bucket and Mailpit catching Keycloak's mail from `compose.override.yaml`, waits for every service's healthcheck, gets 200 from `http://localhost/api/health` and the web client's `index.html` from `http://localhost/` through the proxy, tears the stack down and exits 0.

### S6 — Migration tool with an initial empty migration

- Depends on: S5
- Creates: alembic.ini, migrations/env.py, migrations/script.py.mako, migrations/versions/0001_initial.py, src/portal/db.py
- Done when: with `docker compose up -d --wait db` running, `uv run alembic upgrade head && uv run alembic downgrade base` exits 0.

### S7 — Functional test runner that drives a real browser against the running application

- Depends on: S5
- Creates: tests/functional/conftest.py, tests/functional/test_home_opens.py
- Done when: with `docker compose up -d --wait` running, `uv run pytest tests/functional --junitxml=test-results/functional.xml` passes one case that opens `http://localhost/` in Chromium through Playwright and finds the web client's title.

### S8 — CI workflow for lint, types, unit tests with coverage, migrations and functional tests

- Depends on: S3, S4, S6, S7
- Creates: .github/workflows/ci.yml
- Done when: `gh run list --workflow ci.yml --limit 1` shows the latest run on the default branch completed with success.

### S9 — The product repo's CLAUDE.md

- Depends on: S8
- Creates: CLAUDE.md
- Done when: `grep -cE "uv run pytest|uv run ruff|npm --prefix web|scripts/smoke.sh|alembic upgrade" CLAUDE.md` prints 5 or more.
