---
status: accepted
owner: Igor Roid
updated: 2026-11-18
decision: 0001
---

# 0001 — Application stack

## Context

The [idea brief](../../intents/0001-build-a-portal/idea-brief.md) (build a portal) asks for a
responsive web portal with funding figures and forum threads, and fixes no technology. The
Originator asked for the simplest pilot that runs locally with little infrastructure, a backend
in Python with FastAPI, and a front end in Vue. The languages, the way screens are built and how
they reach the server touch every module and every screen, so changing any of them later means
rewriting most of the code.

## Options

- **A Vue single-page client in TypeScript, built by Vite, calling FastAPI as a JSON API.** The
  front end the Originator asked for, typed against the API's own description, and served as
  static files with nothing extra running in production.
- **The same client in plain JavaScript.** No compile step for types, and no type check between
  the client and the API; the pipeline ships no code guideline for the language.
- **Nuxt, rendering Vue on the server.** A faster first screen and pages a search engine reads
  in full, at the price of a Node server in production as a third runtime to operate.
- **Pages rendered by FastAPI with Jinja2 and made interactive with htmx.** One language and one
  build, and not the Vue front end the Originator wants.

## Decision

The portal's back end is written in Python 3.13 on FastAPI. Its API block answers JSON over
HTTPS, and the OpenAPI document FastAPI generates is the contract the front end is built against.
The Web client is a Vue 3 single-page application in TypeScript, built by Vite, with Vue Router
and no component library: its screens are plain Vue components with scoped styles. Its types for
the API are generated from the OpenAPI document by openapi-typescript, and it calls the API with
the browser's own `fetch`. Node runs only to build it. The reverse proxy serves the built files on
the portal's own domain beside the API, so the browser makes no cross-origin call. Sign-in stays
on the server, as the
[authentication and authorisation](../08-crosscutting-concepts/authentication-and-authorisation.md)
concept says. The domain modules know nothing of HTTP, so the API block could be replaced without
touching them.

## Consequences

### Buys

- The front end in Vue, as the Originator asked, with room for screens that need rich interaction in the browser.
- A mismatch between a screen and the API fails the build, through types generated from the API's own description.
- One origin for the client and the API, so no cross-origin rules and no token held in the browser.
- The JSON API serves a later client, such as a native app or a partner integration, with no second web layer.
- The front end adds nothing to run in production beyond the reverse proxy already there.

### Costs

- Two languages, two toolchains and two sets of dependencies to keep current.
- A change to what a screen shows often lands in both the API and the Web client, with the generated types rebuilt between them.
- A first visit loads the client before it fetches any data, so the first screen appears later than a page rendered on the server, and a search engine sees little of a project page.
- A screen shows what the API answered when it loaded, and a figure stays as it was until the member reloads or acts again.
- CPU-heavy work in a request, such as resizing large images, holds a worker process and has to move to a background job once it shows up in latency.
