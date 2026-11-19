---
title: Member accounts and display names
step: 2
---

# Member accounts and display names

## Problem

The [idea brief's problem](../intents/0001-build-a-portal/idea-brief.md#problem) asks for a
portal open to anyone, and its [users](../intents/0001-build-a-portal/idea-brief.md#users) have
owners seeing who joined their project. Nobody can do anything on the portal as themselves
until they hold an account, and an owner cannot tell members apart without a name to show. This
PRD gives every person an account, a way in and out, a display name, and a member id that tells
apart two members who chose the same name.

## Requirements

The step's source sets who may join, where the portal runs and the language of its screens and
messages:

> The portal is for an open public community: anyone can sign up and post an idea
> ([Problem](../intents/0001-build-a-portal/idea-brief.md#problem))

> **Idea owners**: anyone who signs up and posts an idea, worldwide
> ([Users](../intents/0001-build-a-portal/idea-brief.md#users))

> The portal runs on the web, responsive for desktop and phone browsers
> ([Constraints](../intents/0001-build-a-portal/idea-brief.md#constraints))

> The interface is in English
> ([Constraints](../intents/0001-build-a-portal/idea-brief.md#constraints))

Must have:

1. **Sign-up.** Any signed-out visitor, from any country, MUST be able to create an account with
   an e-mail address and a password, with no invitation and no approval by anyone. Screen:
   [Create an account](../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/sign-up.html),
   the sign-up form and the message to confirm the address.
2. **E-mail confirmation.** A new account MUST confirm its e-mail address, through a link sent to
   it, before it can sign in. An address that already belongs to an account MUST NOT open a
   second one, and signing up with it MUST show the same message a sign-up with a new address
   shows.
3. **Sign-in.** A member MUST be able to sign in with their e-mail address and password. A wrong
   e-mail address or password MUST be refused with one message that does not say which of the two
   was wrong. A holder whose address is not yet confirmed MUST be told to confirm it first only
   after entering the right password. Screen:
   [Sign in](../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/sign-in.html),
   the sign-in form with its refusal messages.
4. **Sign-out.** A signed-in member MUST be able to sign out; after it, the browser holds no
   signed-in session.
5. **Display name.** The display name is the name the portal shows other members for a member.
   A signed-in member who has no display name MUST set one before reaching any other member
   screen: the prompt cannot be dismissed, and it shows at every sign-in until a name is set. It
   MUST hold 2 to 40 characters once spaces at either end are trimmed, MAY use the letters of any
   script, and MUST NOT contain a line break. Two members MAY share a display name; their member
   ids tell them apart. Screen:
   [Choose your display name](../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/display-name.html),
   the prompt a member without a name cannot get past.
6. **Changing the display name.** A member MUST be able to change their display name at any time,
   under the same rules, and the new name replaces the old one on the member's own screens.
   Screen: [Your account](../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/account.html),
   where the member sees and changes their name and sees their member id.
7. **Where the name shows.** The member's own screens MUST show their display name. What other
   members and visitors see of a member is left to the steps that show a member to them, listed
   under Out of scope.
8. **Account recovery.** A member who has forgotten their password MUST be able to set a new one
   through a link sent to their confirmed e-mail address. Asking to recover an address that
   belongs to no account MUST show the same message as asking for a confirmed one. Screens:
   [Recover your account](../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/recover.html),
   where the link is asked for, and
   [Set a new password](../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/new-password.html),
   where the link leads.
9. **Member id.** Every account MUST hold, from its creation, a member id that no other account
   holds and that other members may see, so two members who share a display name can be told
   apart. The member id MUST NOT reveal the member's e-mail address.

## Acceptance criteria

- `AC-0001-1`: Given a signed-out visitor, When they sign up with an e-mail address not yet in use
  and a password, Then they are told to confirm the address and a confirmation link is sent to it.
- `AC-0001-2`: Given an account whose e-mail address is not yet confirmed, When its holder tries to
  sign in with the right password, Then sign-in is refused and they are told to confirm the
  address first; with a wrong password, they get the same message a wrong e-mail address gets.
- `AC-0001-3`: Given an e-mail address that already belongs to an account, When a visitor tries to
  sign up with it, Then no second account is created, and the visitor sees the same message a
  sign-up with a new address shows.
- `AC-0001-4`: Given a confirmed account, When its holder signs in with the right e-mail address
  and password, Then they are signed in.
- `AC-0001-5`: Given a confirmed account, When someone signs in with a wrong password, Then
  sign-in is refused with the same message a wrong e-mail address gets.
- `AC-0001-6`: Given a member who has no display name, When any sign-in completes, Then they are
  asked for a display name, cannot dismiss the prompt, and cannot reach any other member screen
  until they set one.
- `AC-0001-7`: Given a member setting a display name, When they enter one of fewer than 2 or more
  than 40 characters after trimming, or one with a line break, Then it is refused with a message
  stating the rule, and the name is not saved.
- `AC-0001-8`: Given a member setting a display name, When they enter one written in a non-Latin
  script, such as "Мария" or "李明", Then it is saved.
- `AC-0001-9`: Given another member already uses the display name "Alex", When a member sets
  "Alex", Then it is saved, the two accounts keep different member ids, and a member's id, as
  shown on their own screens, contains no part of their e-mail address.
- `AC-0001-10`: Given a signed-in member, When they change their display name to a valid one, Then
  their own screens show the new name and no longer the old one.
- `AC-0001-11`: Given a signed-in member, When they sign out, Then they are signed out, and opening
  a member screen afterwards sends them to sign in.
- `AC-0001-12`: Given a signed-out visitor, When they open the screen for changing a display name,
  Then they are sent to sign in and see no member's details.
- `AC-0001-13`: Given a signed-in member with a display name, When they open any of their own
  screens, Then the screen shows that display name.
- `AC-0001-14`: Given a member who has forgotten their password, When they ask to recover the
  account with their confirmed e-mail address, Then a link to set a new password is sent to it,
  and after setting one they can sign in with it; When someone asks to recover an address that
  belongs to no account, Then they see the same message.

## Out of scope

- Signing in with another service's account, such as Google or LinkedIn: not now; the
  [identity provider decision](../arch/09-architecture-decisions/0004-identity-provider.md#decision)
  sets up sign-in by e-mail address, and such logins can be added in it later without changes to
  the portal.
- Showing a member's display name and member id to other members and visitors: steps 3, 6 and 8 of the
  [roadmap](../roadmap/roadmap.md), project pages, who joined and the forum, each PRD for its own
  screens.
- Deleting an account: not now; nothing a member creates in this step would be lost or need
  handing over.
- A profile beyond the display name and member id, such as an avatar, a biography or a personal
  profile screen: a later step, which the [roadmap](../roadmap/roadmap.md) does not name yet.
- The real name, phone number and professional link of an investor, and their approval:
  [step 4](../roadmap/roadmap.md), investor verification.
- What an administrator does, and how the administrator role is granted: steps 4 and 9 of the
  [roadmap](../roadmap/roadmap.md).
- A member's status or type, such as administrator or verified investor, and the marks and colours
  that set it apart for other members: steps 4 and 9 of the [roadmap](../roadmap/roadmap.md).
- Verifying a member so no one can pass as them: [step 4](../roadmap/roadmap.md) verifies
  investors; verifying administrators and owners is a later step the roadmap does not name yet.
- Numeric targets for speed, load or availability: the platform sets none yet, per
  [quality requirements](../arch/10-quality-requirements.md) GAP-0001.
