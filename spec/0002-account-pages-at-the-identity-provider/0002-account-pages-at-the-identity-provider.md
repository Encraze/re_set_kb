---
title: Account pages at the identity provider
step: 2
prd: [prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md]
arc42: [05-building-block-view.md, 03-context-and-scope.md, 07-deployment-view.md, 08-crosscutting-concepts/authentication-and-authorisation.md, 08-crosscutting-concepts/data-classification.md, 08-crosscutting-concepts/input-validation.md, 08-crosscutting-concepts/logging.md, 08-crosscutting-concepts/secrets.md, 09-architecture-decisions/0004-identity-provider.md, 11-risks-and-technical-debt.md]
size: M
route: standard
reworks:
state: approved
---

# Account pages at the identity provider

## Scope

This spec builds the identity provider's half of the
[account pages](../../arch/08-crosscutting-concepts/authentication-and-authorisation.md#account-pages):
the configuration of Keycloak's `portal` realm and the portal's login theme, with no portal code.
Its criteria come from
[PRD 0001](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md) (member
accounts and display names), written for [step 2](../../roadmap/roadmap.md#steps) (where members
first get accounts). It carries the account-pages change, whose decision sits in the
[architecture record](../../arch/_runs/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#escalations)
(escalations, account pages). It clears no technical debt entry, since [risks and technical debt](../../arch/11-risks-and-technical-debt.md#technical-debt)
registers none.

In scope:

- the realm's settings for sign-up, confirmation, sign-in, recovery, the password rule and the
  slowing of failed sign-ins, in `deploy/keycloak/portal-realm.json`;
- the `portal` login theme: its page frame, stylesheet and English texts, and three template
  overrides, for registration, the confirm-address page and the new-password page;
- the provider's account mail through Gmail, with the app password read from a secret file;
- closing the provider's account console to members.

Out of scope:

- the portal's OpenID Connect client, its sign-in route, session and sign-out, and the member id:
  [spec 0001](../0001-sign-in-to-the-portal-and-choose-a-display-name/0001-sign-in-to-the-portal-and-choose-a-display-name.md)
  (sign in to the portal);
- the display-name prompt:
  [spec 0005](../0005-choose-a-display-name/0005-choose-a-display-name.md#the-prompt)
  (choose a display name);
- a rate limit per client on the provider's pages, a gap this spec accepts
  ([Security](#security));
- the wording of the account mail, which keeps the provider's default English text;
- the administrator role and its second factor, and sign-in with another service's account, which
  the PRD's [out of scope](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#out-of-scope)
  leaves to later steps.

## Approach

This spec keeps the routes that serve the provider's pages, set out under
[account pages](../../arch/08-crosscutting-concepts/authentication-and-authorisation.md#account-pages)
and in the [deployment view](../../arch/07-deployment-view.md#production) (reverse proxy), and
changes what the pages do and how they look. Every behaviour comes from a
realm setting the provider has, except two that need the theme: a sign-up with an address in use,
which the provider refuses openly, and the single password field, where the provider demands a
confirmation. The work lands in the provider's configuration, which the
[building block view](../../arch/05-building-block-view.md#portal) draws outside the portal's
blocks; the sign-up it builds is the start of the flow the
[Accounts](../../arch/05-building-block-view.md#accounts) block continues at a member's first
sign-in. The portal's tables and API do not change. The provider itself is
[ADR 0004](../../arch/09-architecture-decisions/0004-identity-provider.md#decision) (identity provider).

### Realm settings

The realm import file holds these values, the same in every environment.

| Setting | Value |
|---|---|
| Registration | on |
| E-mail address as username; sign-in with e-mail | on |
| Confirm the e-mail address before sign-in | on |
| Forgot password | on |
| Duplicate e-mail addresses | off |
| Remember me; username editing | off |
| User profile attributes | username and e-mail only, first and last name removed |
| Password policy | `length(8) and maxLength(64) and notEmail` |
| Brute-force detection | temporary lockout: failure threshold 5, wait increment 60 s, maximum wait 15 min, failure reset time 12 h; permanent lockout off |
| Action token lifespans | confirmation link 24 h, recovery link 30 min |
| Login theme | `portal`; the account, admin and e-mail themes stay the provider's |
| Internationalisation | off, English only |
| Event listeners | none |
| Default roles | without the account console's roles |
| SMTP | Gmail's relay, STARTTLS on 587, authentication on, user and sender the Gmail account's address, password by vault reference |

Host, port, sender and STARTTLS keep the environment placeholders the file already uses, and the
SMTP user gets one beside them. The provider starts with its file vault pointed at the mounted
secrets, and the realm's SMTP password names a vault key, so the app password reaches the provider
as a file and never as an environment variable
([secrets](../../arch/08-crosscutting-concepts/secrets.md), how they reach a process). Compose
declares that secret and mounts it into the provider's container alone.

The event listeners are emptied because the provider's logging listener writes the address typed
into a failed sign-in, and [logging](../../arch/08-crosscutting-concepts/logging.md) never records
contact data. The portal's API records sign-in and sign-out at its end, under the portal's
sign-in in [spec 0001](../0001-sign-in-to-the-portal-and-choose-a-display-name/0001-sign-in-to-the-portal-and-choose-a-display-name.md)
(sign in to the portal). The
default roles drop the account console's roles, so a member signed in at the provider cannot open
its account console, which the theme does not dress and where a member could manage the account
outside the flows the PRD sets.

### The theme

The `portal` login theme extends the provider's `base` theme and lives in
`deploy/keycloak/themes/portal/`, mounted read-only into the provider's container. Its page frame
and stylesheet give every provider page the look of the
[prototype's screens](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md#screens),
and its English message bundle sets the headings, labels, actions and notices their entries show,
the wrong-credentials message included. Pages no screen draws, an expired link or an expired
page, take the same frame. Every field keeps a visible label, the address field is an e-mail
input, and every page reads at 320 px wide.

The registration template asks for the address and one password. A script in the theme's
resources copies the password into a hidden confirmation field when the form is sent; with script
off, that field shows as a second password field. When the provider refuses the address as already
in use, by its username or its e-mail message, the template renders the confirm-address fragment
in place of the form. Every other refusal, a malformed address or a password outside the policy,
keeps the form, with the provider's message in a red notice above it styled as the sign-in page's
error notices.

The confirm-address template is the page the provider shows after a sign-up, and again when a
holder whose address is not confirmed signs in with the right password. It renders the same
fragment as the registration override, holding the text of
[SCR-1](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md#scr-1-create-an-account)'s
success state and a link that restarts the sign-in, and it drops the provider's resend link. A
holder who wants a fresh link signs in again, and the provider mails one.

The new-password template shows one password field, fills the confirmation as registration does,
keeps the provider's choice to sign the account out on other devices, and shows a policy refusal
in a red notice above the form.

### Where each flow ends

Where the provider's own flow ends somewhere other than the prototype, the provider's flow holds
([report](report.md), this spec's findings and decisions); rows 4, 6 and 10 are those places. The
last column names the state of each screen listed under [Screens](#screens).

| # | Case | What the provider does and shows | Screen state |
|---|---|---|---|
| 1 | Sign-up, new address, password within the policy | creates the account, mails the confirmation link, shows the confirm-address page | [SCR-1](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md#scr-1-create-an-account) (create an account) success |
| 2 | Sign-up, address already in use | creates nothing, mails nothing, shows the same confirm-address page through the registration override | [SCR-1](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md#scr-1-create-an-account) (create an account) success |
| 3 | Sign-up, malformed address or password outside the policy | keeps the form, with the provider's message in a red notice above it | [SCR-1](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md#scr-1-create-an-account) (create an account) default |
| 4 | Confirmation link opened within 24 h | confirms the address, then continues the sign-in where the sign-up's browser session still runs, and otherwise shows its information page with a link to sign in | none |
| 5 | Sign-in, wrong address or password, confirmed or not, or while the account is locked | refuses with the one wrong-credentials message | [SCR-2](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md#scr-2-sign-in) (sign in) error, wrong address or password |
| 6 | Sign-in, right password, address not confirmed | refuses, mails a fresh confirmation link, shows the confirm-address page | [SCR-1](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md#scr-1-create-an-account) (create an account) success |
| 7 | Sign-in, right password, address confirmed, account not locked | hands the browser back to the client that asked for the sign-in | [SCR-2](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md#scr-2-sign-in) (sign in) default |
| 8 | Recovery asked for any address | shows the check-your-mail message, and mails a recovery link only where an account holds the address | [SCR-5](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md#scr-5-recover-your-account) (recover your account) success |
| 9 | Recovery link opened within 30 min | shows the new-password page; a password outside the policy keeps it with a red notice | [SCR-6](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md#scr-6-set-a-new-password) (set a new password) default |
| 10 | New password saved | continues the sign-in where the recovery's browser session still runs, and otherwise shows its information page with a link to sign in | none |
| 11 | Either link expired, or a page left open past its session | shows its expired page with a link to start again | none |

Two sign-ups racing on one address end with one account, since the provider's database holds the
username unique; a form sent twice creates one account the same way. While the provider is down,
the proxy cannot reach it and nobody signs up or signs in, the cost
[ADR 0004](../../arch/09-architecture-decisions/0004-identity-provider.md#costs) (identity provider)
accepts. While Gmail
refuses mail, an account is still created and no link arrives; once Gmail sends again, signing in
with the right password mails a fresh one (row 6).

### Alternatives considered

- Hiding the in-use refusal by configuration: the provider has no such setting, and the
  [account pages](../../arch/08-crosscutting-concepts/authentication-and-authorisation.md#account-pages)
  concept places the refusal's disguise in the registration override, which needs no code in the
  provider.
- A provider extension in Java for the confirmation field and the in-use case: it would keep both
  off the page, at the cost of code built into the provider, which the tree does not have.
- Keeping the resend link on the confirm-address page: in the in-use case it would lead the
  visitor back to the sign-up form, which tells them the address has an account.

### Test levels and local testing

A unit test under `tests/unit` reads the realm file and checks every value of the settings table,
so an edit that turns one off fails the unit suite before any stack starts.

The functional tests drive Chromium through Playwright, one test per criterion this spec answers,
named for the criterion as `scripts/functional.sh` selects them, against the compose stack with
the real provider and PostgreSQL. A test reaches the provider's pages through an authorization
request of the provider's built-in `account-console` client, so it needs no portal client, and
counts a sign-in as done when the provider hands the browser back to that client's redirect
address. Each test signs up its own generated address, so lockout and confirmation never carry
from one test to the next.

Mailpit stands in for Gmail and accepts only the development credential `scripts/local-secrets.sh`
writes into the SMTP password file, so a vault reference that does not resolve fails the tests. A
test reads each confirmation or recovery link from Mailpit's HTTP API and checks that it starts
with the portal's base address; the in-use sign-up and the recovery for an unknown address are
checked there for the mail that must not arrive. Two checks run beside the criteria: five wrong
passwords followed by the right one get the wrong-credentials message, and a seven-character
password and the address itself as password are refused with the form kept.

What is risky: the in-use override matches the provider's message keys, and the overrides copy
templates of the pinned provider version, so a provider upgrade can break either; the tests of the
in-use sign-up and of the sign-up itself catch it.

### Rollout

- [GAP-0002](../../arch/08-crosscutting-concepts/delivery.md) (release script and AWS resources
  not built) stands and no release has run, so the first release's import creates the realm
  with these settings. The provider's import skips a realm that exists: on a developer machine the
  stack's volumes are dropped once to take the new file, and after go-live a change to these
  settings is made in the provider's admin console as well as in the file.
- Before the first release: a Gmail account with 2-step verification and an app password; the app
  password in its secret file in the host's secrets directory, readable by root alone; and the
  host's environment holding the portal's public address and the Gmail address as SMTP user and
  sender.
- No feature flag: a visitor reaches these pages only through a client's sign-in request, and the
  portal sends none until the sign-in route of
  [spec 0001](../0001-sign-in-to-the-portal-and-choose-a-display-name/0001-sign-in-to-the-portal-and-choose-a-display-name.md)
  (sign in to the portal) is delivered.
- Rollback: the theme and the realm file return with the previous tag; since the import does not
  overwrite, the realm's settings are rolled back in the admin console. No portal data moves.

## Acceptance criteria answered

### [Member accounts and display names](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md)

- [`AC-0001-1`](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria):
  Given a signed-out visitor, When they sign up with an e-mail address not yet in use and a
  password, Then they are told to confirm the address and a confirmation link is sent to it.
  Answered in [Where each flow ends](#where-each-flow-ends), rows 1 and 4.
- [`AC-0001-2`](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria):
  Given an account whose e-mail address is not yet confirmed, When its holder tries to sign in
  with the right password, Then sign-in is refused and they are told to confirm the address first;
  with a wrong password, they get the same message a wrong e-mail address gets. Answered in
  [Where each flow ends](#where-each-flow-ends), rows 5 and 6, and
  [The theme](#the-theme), the confirm-address template.
- [`AC-0001-3`](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria):
  Given an e-mail address that already belongs to an account, When a visitor tries to sign up with
  it, Then no second account is created, and the visitor sees the same message a sign-up with a
  new address shows. Answered in [The theme](#the-theme), the registration template, and
  [Where each flow ends](#where-each-flow-ends), row 2.
- [`AC-0001-5`](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria):
  Given a confirmed account, When someone signs in with a wrong password, Then sign-in is refused
  with the same message a wrong e-mail address gets. Answered in
  [Where each flow ends](#where-each-flow-ends), row 5, and [Realm settings](#realm-settings),
  brute-force detection.
- [`AC-0001-14`](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria):
  Given a member who has forgotten their password, When they ask to recover the account with their
  confirmed e-mail address, Then a link to set a new password is sent to it, and after setting one
  they can sign in with it; When someone asks to recover an address that belongs to no account,
  Then they see the same message. Answered in [Where each flow ends](#where-each-flow-ends), rows 8
  to 10.
- [`AC-0001-4`](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria),
  kept: Given a confirmed account, When its holder signs in with the right e-mail address and
  password, Then they are signed in. Kept by [Where each flow ends](#where-each-flow-ends), row 7,
  since the themed sign-in page sends the provider's own fields; the portal's side of that sign-in
  is [spec 0001](../0001-sign-in-to-the-portal-and-choose-a-display-name/0001-sign-in-to-the-portal-and-choose-a-display-name.md)
  (sign in to the portal).

## Screens

- [`SCR-1`](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md#scr-1-create-an-account): default, success
- [`SCR-2`](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md#scr-2-sign-in): default, error wrong address or password
- [`SCR-5`](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md#scr-5-recover-your-account): default, success
- [`SCR-6`](../../ui/0001-members-sign-up-sign-in-and-set-the-name-other-members-see/screens.md#scr-6-set-a-new-password): default

## Interfaces

No interface change.

## Data

No data change.

## Security

The work crosses two of the
[trust boundaries](../../arch/03-context-and-scope.md#trust-boundaries) (browser to identity
provider; identity provider to mail relay) and adds none. It adds no data class: the credentials
and contact data it handles stay where
[data classification](../../arch/08-crosscutting-concepts/data-classification.md) places them.

What is refused, and what proves it:

- a wrong address or a wrong password, on a confirmed or an unconfirmed account, and any sign-in
  while the account is locked, with the one wrong-credentials message:
  [`AC-0001-5`](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria)
  (wrong password, same message) and
  [`AC-0001-2`](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria)
  (unconfirmed address), with the lockout check beside them;
- the right password on an address not yet confirmed:
  [`AC-0001-2`](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria)
  (told to confirm first);
- a second account for an address in use, shown as a new sign-up:
  [`AC-0001-3`](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria)
  (no second account);
- a recovery link for an address no account holds:
  [`AC-0001-14`](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria)
  (recovery, same message);
- a password under 8 or over 64 characters, or equal to the address, on sign-up and on the
  new-password page: the PRD has no criterion for it, and the password check under
  [Test levels and local testing](#test-levels-and-local-testing) proves it;
- a confirmation link older than 24 h or a recovery link older than 30 min: the provider's expired
  page, row 11;
- the account console, to every member, by the realm's default roles.

The Gmail app password is the one secret this spec adds. It is a file mounted into the provider
alone and read through the provider's vault, never an environment variable, a log line or a file
under version control, and it rotates as [secrets](../../arch/08-crosscutting-concepts/secrets.md)
says, by writing the new value and restarting the provider. No log line carries an address, since
the provider's event listeners are off.

These costs are accepted:

- Anyone can lock an account for up to 15 minutes by failing its sign-in five times; the holder
  waits, or recovers the account.
- [Input validation](../../arch/08-crosscutting-concepts/input-validation.md) (rates are bounded)
  asks for a limit per client on sign-in, sign-up and every form that writes. No per-client rate
  limit is built anywhere, in the portal or at the provider. The delivered system therefore lacks
  the property the concept states, and
  [risks and technical debt](../../arch/11-risks-and-technical-debt.md#technical-debt) holds no
  entry for the gap. Without a limit one client can try passwords across many accounts, and can send sign-ups and
  recovery requests that use up Gmail's daily allowance, after which no address is confirmed and no account recovered, a cost
  [ADR 0004](../../arch/09-architecture-decisions/0004-identity-provider.md#costs) (identity
  provider) already lists.
- A wrong password at the provider and a lockout leave no log line. The provider's event
  listeners are off, and the portal records a sign-in only once the provider hands the browser
  back, so the failed attempts [logging](../../arch/08-crosscutting-concepts/logging.md) (sign-in
  is a security event) would count go unrecorded, and nobody reading the logs sees passwords tried
  against one account or many.
- A sign-up or new password from a browser with script off shows a second password field.
