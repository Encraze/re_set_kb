---
status: draft
owner: Igor Roid
updated: 2026-11-18
---

# Quality requirements

## Qualities

| Quality | Dimension | Exercised by |
|---|---|---|
| [Confidentiality](https://quality.arc42.org/qualities/confidentiality) | #secure | the transport and secret rotation requirements |
| [Testability](https://quality.arc42.org/qualities/testability) | #flexible | the test coverage requirement |
| [Analysability](https://quality.arc42.org/qualities/analysability) | #flexible | the observability requirement |

## Non-functional requirements

**GAP-0001, quality targets not set.** The platform has no target yet for load, throughput,
latency, upload size, storage, availability, backup or recovery, and no
requirement below measures any of them.

| Requirement | Measure |
|---|---|
| Transport security | every connection from the internet uses TLS 1.2 or later; a scan of the host finds only ports 80 and 443 open to the internet, with 80 redirecting to 443 |
| Secret rotation | every secret is replaced within one day of a suspected exposure or of the departure of a person with host access |
| Test coverage | unit tests cover at least 80% of the application's lines, and every acceptance criterion has at least one automated functional test; the CI workflow fails below either |
| Observability | every request leaves one log line with its correlation id, status and duration, and the application answers liveness and readiness checks |
