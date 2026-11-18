---
title: Build a portal
owner: Igor Roid
state: approved
source:
  - the Originator's raw idea, intents/0001-build-a-portal/working-raw-idea.md, 2026-11-18
depth: medium
raised: 2026-11-18
approved: 2026-11-18
---

# Build a portal

Quoted from [the Originator's raw idea](working-raw-idea.md).
## Raw idea
> I have no material. I want to build a portal that will connect enthusiasts, investors and people who can contribute in a different way (networking, ideas, services, do the job...). Some users pitch their idea with a presentation and states the needed investments. others can discuss, ask questions and join as followers, contributors or investors. Followers juts watch how the project grows, contributors provide info about how they can be helpful, investors state how much they're ready to invest. This is something like an imageboard where people discuss and engage. No financial operations processed through the platform, no contracts. All this goes offline. Our goal is to build a platform to present and track. The idea owner may create a project page with descritpion, customize it, provide photos, slide deck, expected investments (sort of CRM). Joining investors cover the need and it is reflected in realtime. Then the owner updates statuses and ETAs for each stage (idea, funding, prep, implemenation, live). Communication is not so much a chat, but rather a forum: topics, threads. So everyone can track the conversation history.

## Problem

People with an idea have no single place where investors and helpers can see it, and the talk about ideas is scattered across chats and social media, where no history is kept (owner-reported). The portal is for an open public community: anyone can sign up and post an idea (owner-reported).

An owner needs a project page that presents the idea and tracks it: who joined as follower, contributor or investor, how much funding is pledged and concluded against what was asked, and where the project stands in its stages (owner-reported). Money and contracts stay offline; the portal presents and tracks, and nothing more (owner-reported).

## Outcome

- An idea owner publishes and customizes a project page with a description, photos, a slide deck and the investment the project needs, and updates the status and ETA of each stage: idea, funding, prep, implementation, live (owner-reported).
- Members join a project as followers, contributors or investors. A contributor states how they can help; an investor states an amount they are ready to invest (owner-reported).
- The project shows its funding progress live as two figures side by side: the pledged total, which counts every pledge as soon as it is made, and the concluded total, which counts the amounts the owner has concluded (owner-reported). An investor can withdraw a pledge without giving a reason (owner-reported). A concluded pledge stands for a contract, so neither side reverses it on the portal; a reversal goes through customer support as a contract rollback (owner-reported). The owner can reject a pledge whose terms they do not agree to (owner-reported). Pledges beyond the ask change nothing on the portal; renegotiating returns with investors, or announcing a larger project to the public, is the owner's to do (owner-reported).
- Discussion runs in forum threads on each project, so the whole history stays readable (owner-reported). Only members who joined the project, as follower, contributor or investor, post in its threads (owner-reported).
- A project moved to live shows verifiable evidence: a web site or app, a venue if it is offline, a working prototype or a product available online (owner-reported). Members flag a live project whose evidence does not convince them; a platform administrator reviews each flag against the live evidence, and where it cannot be verified, marks the owner's account unreliable until the matter is resolved (owner-reported). Everyone sees the mark, so members can weigh it before they invest (owner-reported).
- The pilot succeeds when a single project reaches live with the required evidence and has no flag upheld by an administrator; no date is set for it (owner-reported).

## Users

- **Idea owners**: anyone who signs up and posts an idea, worldwide (owner-reported). An owner sees the individual pledge amounts on their project and who joined in which role (owner-reported). An owner concludes a pledge when a formal deal for that amount exists, by contract or transaction, and gives no evidence for it, since concluding is the owner's call (owner-reported).
- **Investors**: members who pledge an amount. Only a verified investor can pledge (owner-reported). Verification is light: email and phone confirmed, a profile with a real name and a professional link such as a company or LinkedIn, approved by a platform administrator, with no identity documents stored (owner-reported). An investor can edit a pledge until the owner concludes it (owner-reported).
- **Contributors**: members who offer networking, ideas, services or work, and state how they can help (owner-reported).
- **Followers**: members who watch a project grow (owner-reported).
- **Signed-in members**: see a project's pledged total and concluded total, not who pledged what or how much (owner-reported).
- **Signed-out visitors**: see the projects and their stages, and no forum and no money figures (owner-reported).
- **Platform administrators**: approve investor verification, and review each flag on a project's live stage against its evidence and rule on it (owner-reported).

## Why now

The Originator is starting the portal as their own venture, with no external trigger (owner-reported). The first projects and investors are not lined up yet and have to be recruited (owner-reported).

## Constraints

- No financial operations are processed through the platform, and no contracts; all of that happens offline (owner-reported).
- The portal is for an open public community, worldwide (owner-reported).
- Individual pledge amounts are visible only to the project's owner; signed-in members see the pledged total and the concluded total; signed-out visitors see no money figures (owner-reported).
- Only verified investors can pledge, verified by email, phone, real name and professional link, approved by an administrator, with no identity documents stored (owner-reported).
- The portal runs on the web, responsive for desktop and phone browsers (owner-reported).
- The interface is in English (owner-reported).
- No budget, team size or technology is fixed (owner-reported).

## Out of scope

- Moving money or handling contracts through the platform.
- Private messages between members; conversation happens only in public forum threads.
- Native mobile apps.
- Matching or recommending investors to projects.
- Search and browsing beyond a plain list of projects.

## Risks

- Both sides start empty: no idea owners or investors are waiting to join, so filling the portal with projects and investors is the main risk to the pilot (owner-reported).
- A concluded amount rests on the owner's word, with no evidence asked, so an owner can overstate the concluded total (owner-reported).
- Light verification confirms contact details and a professional profile, not a person's identity, so a verified investor may not be who they claim, and the pledged total can show amounts nobody follows through on (owner-reported).
- A member can flag a live project in bad faith, to harm its owner (owner-reported).

## Recommendation

Build a web portal for an open, worldwide community where idea owners present projects and track their stages, members join as followers, contributors or investors, verified investors pledge amounts the owner later concludes, and talk runs in public forum threads. Success is one project that reaches live with the required evidence and has no flag upheld by an administrator.

The main trade-off is reach against trust: an open worldwide portal with light, administrator-approved verification fills faster and costs less to run than a closed or document-checked one (owner-reported), and in return the figures it shows rest on members' and owners' word.

Alternatives turned down:

- **A closed or invite-only community, or the Originator's own deal flow**: the Originator chose an open public community.
- **One country only**: chose worldwide, because the portal is a communication platform and nothing shown on it is legally binding for anyone, so the way it shows figures carries no regulatory risk (owner-reported).
- **Owner confirmation without investor verification, or no checks**: chose verified investors only, so a pledge comes from a vetted member.
- **Identity documents reviewed by hand, or a third-party identity service**: chose light, administrator-approved verification, which stores no identity documents and avoids a per-check cost and an external dependency.
- **One funding figure, pledged or concluded**: chose both side by side, so signed-in members see interest and closed deals apart.
- **Private messages, native apps, or several interface languages at launch**: left out of the first version.
- **Community growth or revenue as the measure of success**: chose a single project that reaches live with the required evidence and has no flag upheld by an administrator.
- **A concluded total that covers the ask as the measure of success**: turned down, because one owner's unchecked entry could meet it.
