---
status: draft
owner: Igor Roid
updated: 2026-11-20
---

# Authentication and authorisation

## Sign-in

Members sign in at the identity provider, Keycloak, over OpenID Connect with the authorisation
code flow and PKCE ([identity provider](../09-architecture-decisions/0004-identity-provider.md)).
The portal never receives a password. The API block is the OpenID Connect client: to sign in, the
Web client hands the browser to the API block, which sends it to the provider and receives it
back. The API block checks the returned token's signature, issuer, audience and expiry, then opens
a session and returns the browser to the Web client. The Web client never holds a token. Session
state lives in PostgreSQL; the browser holds only a random session id in a cookie marked
`HttpOnly`, `Secure` and `SameSite=Lax`, with the `__Host-` prefix. The API block issues a new id at sign-in and at every change of privilege,
ends the session after a period of inactivity and at an absolute limit, and on sign-out ends it
on the server and at the provider.

Administrators sign in with a second factor, which the identity provider enforces for the
administrator role.

## Account pages

Creating an account, confirming its address, signing in, asking for a recovery link and setting a
new password all happen on the identity provider's own pages, and behave as
[PRD 0001, requirements 1, 2, 3 and 8](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements)
(sign-up, confirmation, sign-in and recovery) set out. They carry the portal's look and are
served on the portal's domain, so a member never sees where the portal ends and the provider
begins. The e-mail address is the username, and the sign-up form asks
for the address and a password and no other field. The portal's theme overrides the provider's
registration template, and the override supplies the password confirmation the provider requires
from the password the member typed once.

The provider refuses a second account for an address in use, and the same override shows this
refusal as the confirm-address outcome a new address gets. The provider's configuration gives
the sign-in and recovery messages those requirements set, and slows repeated failed sign-ins to
one account.

A member holds a portal session from sign-in, whether or not their profile holds a display name.
Accounts says whether a member's profile is complete. While it is not, the API block's request
filter answers every request but those of the display-name setup and sign-out with the status
registration incomplete and a redirect to the display-name setup, which holds the member to the
prompt of [PRD 0001, requirement 5](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#requirements)
(display name).

## Who may do what

The module that owns the data decides authorisation once, through its own policy, before any
change and before any read of data that is not public. The policy refuses anything it does not grant,
and an error during the check refuses too. The Web client hides actions a member cannot use,
which is a courtesy; the module's policy is the control.

A policy checks the object as well as the role: being a member is no permission to
read a given project's pledges, and the policy asks whether this member owns this project.
Platform roles, such as administrator, come from Accounts; a member's role on a project comes
from Participation; ownership comes from Projects.

Every request that changes state carries, in a header, a token bound to the session, which the
API block hands the Web client with the session. The API block compares it, and the request's
origin, with the session before the module sees the request; the `SameSite` cookie is a second
guard behind that check.
