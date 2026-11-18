---
status: accepted
owner: Igor Roid
updated: 2026-11-18
decision: 0004
---

# 0004 — Identity provider

## Context

Anyone in the world may sign up, per the
[idea brief](../../intents/0001-build-a-portal/idea-brief.md) (build a portal), and
administrators hold powers over other members' standing. The portal is to keep no password of
its own, run the same stack locally and in production, and keep its running cost low. Whoever
holds the accounts holds every member's sign-in, so moving to another provider later means moving
every account.

## Options

- **Keycloak, run by the project in the portal's own stack.** Open source under Apache 2.0, no
  per-user fee, the same on a laptop and in production, and one more service to patch.
- **Amazon Cognito.** Managed by AWS, free up to a monthly user count and charged per active user
  beyond it, ties sign-in to AWS and has no local equivalent.
- **A hosted provider such as Auth0 or Okta.** Managed and full-featured, with a monthly fee that
  grows with members.
- **Sign-in with Google only.** No service to run, and it shuts out everyone without a Google
  account.
- **A credential store of the portal's own.** The last resort, which no requirement here calls
  for.

## Decision

Keycloak is the portal's identity provider, run as a container beside the application and
keeping its data in a database of its own on the portal's PostgreSQL server. The portal signs
members in over OpenID Connect and holds a member's profile keyed by the subject Keycloak
confirms. Administrators hold a role in Keycloak and sign in with a second factor. Keycloak sends
the mail its flows need, confirming an e-mail address and recovering an account, through Gmail's
SMTP relay, signed in to one Gmail account with an app password; the portal sends no mail itself.
No text message is sent: an administrator checks a member's phone number, real name and
professional link by hand, and that administrator's approval is the investor's verification. How
the portal uses the sign-in is the
[authentication and authorisation](../08-crosscutting-concepts/authentication-and-authorisation.md)
concept.

## Consequences

### Buys

- No password, reset flow or second-factor handling written or stored by the portal.
- No per-user fee, and the same sign-in on a developer machine as in production.
- Social or enterprise logins can be added in Keycloak later without code changes in the portal.

### Costs

- Keycloak is one more service the project upgrades and patches, and a vulnerability in it exposes every account.
- Keycloak takes the largest share of the host's memory.
- While Keycloak is down nobody can sign in, though sessions already open keep working until they expire.
- Account mail leaves through one Gmail account, which sends about 500 messages a day; past that limit, or while Google holds the account, no address is confirmed and no account recovered.
