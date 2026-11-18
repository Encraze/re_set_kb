---
status: draft
owner: Igor Roid
updated: 2026-11-18
---

# Introduction and goals

The portal is a public web site where people present ideas as project pages and others gather
around them as followers, contributors or investors. It records interest, pledges and the progress
of each project through its stages, and keeps the talk about each project in forum threads. It
moves no money and holds no contract. What the product is for, and for whom, is the
[idea brief](../intents/0001-build-a-portal/idea-brief.md) (build a portal); this tree states how
the system is built to serve it.

## Quality goals

In order of priority:

1. **Little to run.** The whole system is one stack of a few containers that starts the same way
   on a developer's machine and on the production host, so a small team can operate it.
2. **Figures shown by role.** A pledge amount, the totals and who joined in which role each reach
   only the people allowed to see them, and the check is made on the server for every request.

No measure is set for these goals yet; the
[non-functional requirements](10-quality-requirements.md#non-functional-requirements) record the
gap as GAP-0001 (quality targets not set).

## Stakeholders

| Stakeholder | Expects from the architecture |
|---|---|
| The Originator, who owns the product | a pilot that is cheap to host and quick to change |
| Members, in every role the [idea brief](../intents/0001-build-a-portal/idea-brief.md#users) names | pages that answer quickly and show each figure only to those allowed |
| Platform administrators | a place to approve investors and rule on flags, with every ruling recorded |
| The team building the portal | Python behind the API and TypeScript in the Web client, one database, and one compose file to run them |
