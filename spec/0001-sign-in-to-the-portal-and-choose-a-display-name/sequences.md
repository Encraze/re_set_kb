# Sequences: Sign in to the portal

Derived from [Sign in to the portal](0001-sign-in-to-the-portal-and-choose-a-display-name.md) and its [contracts/openapi.yaml](contracts/openapi.yaml).

## Flows

### Sign in at the identity provider

Started by the Member's browser, sent by the Web client on a 401 or following a link to the portal; serves [`AC-0001-4`](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) (a confirmed account's holder signs in with the right e-mail address and password).

```mermaid
sequenceDiagram
  actor Member
  participant Api as API
  participant IdP as Identity provider
  participant Accounts as Accounts

  Member->>Api: startSignIn
  Api->>IdP: fetches the provider's metadata
  alt provider unreachable or slower than 5 seconds
    Api-->>Member: 503 problem response
  else metadata fetched
    Api-->>Member: 302 to the provider, sign-in cookie set
    Member->>IdP: e-mail address and password
    IdP-->>Member: 302 to the callback with code and state
    Member->>Api: completeSignIn
    alt state missing, foreign or expired, sign-in cookie present
      Api-->>Member: 302 to a fresh sign-in for the account page
    else state missing, foreign or expired, no sign-in cookie
      Api-->>Member: 400 problem response
    else state accepted
      Api->>IdP: exchanges the code with the PKCE verifier
      alt provider unreachable or slower than 5 seconds
        Api-->>Member: 503 problem response
      else ID token fails a check
        Api-->>Member: 400 problem response, security event logged
      else ID token accepted
        IdP-->>Api: ID token
        Api->>Accounts: ensure the profile of the subject
        Accounts-->>Api: profile with member id
        Api-->>Member: 302 to the return path, session cookie set
      end
    end
  end
```

### Draw a member screen

Started by the Member opening a member screen; serves [`AC-0001-4`](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) (a confirmed account's holder signs in).

```mermaid
sequenceDiagram
  actor Member
  participant Client as Web client
  participant Api as API
  participant Accounts as Accounts

  Member->>Client: opens a member screen
  Client->>Api: getCurrentMember
  alt no live session
    Api-->>Client: 401 problem response, signed-out
    Client-->>Member: sends the browser to sign in with the current path
  else live session
    Api->>Accounts: read the member
    Accounts-->>Api: display name or none, member id
    Api-->>Client: 200 display name and member id
    Client-->>Member: draws the member screen
  end
```

### Fetch the state-change token

Started by the Web client once per page load; serves [`AC-0001-4`](../../prd/0001-members-sign-up-sign-in-and-set-the-name-other-members-see.md#acceptance-criteria) (a confirmed account's holder signs in). The member screen does not wait for it.

```mermaid
sequenceDiagram
  actor Member
  participant Client as Web client
  participant Api as API

  Client->>Api: getSession
  alt no live session
    Api-->>Client: 401 problem response, signed-out
    Client-->>Member: sends the browser to sign in with the current path
  else live session
    Api-->>Client: 200 state-change token
  end
```
