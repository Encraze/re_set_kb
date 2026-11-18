---
status: draft
owner: Igor Roid
updated: 2026-11-18
---

# Runtime view

## Main flow: a project is funded

An owner publishes a project, an investor joins it and pledges, and the project's totals show the
pledge the next time a page of the project is loaded. The deal itself is closed away from the
portal; the owner then records it as concluded.

```mermaid
%%{init: {"flowchart": {"curve": "linear"}}}%%
flowchart LR
  subgraph OwnerLane["Idea owner"]
    Publish["Publishes the project page"]:::step
    Conclude["Concludes the pledge"]:::step
  end
  subgraph InvestorLane["Investor"]
    Join["Joins the project as investor"]:::step
    Pledge["Pledges an amount"]:::step
    Deal["Closes the deal with the owner offline"]:::step
  end
  subgraph ParticipationLane["Participation"]
    Record["Records the investor role"]:::step
  end
  subgraph FundingLane["Funding"]
    Verified{"Verified investor?"}:::decision
    Refuse["Refuses the pledge"]:::step
    Count["Recounts the project's totals"]:::step
  end
  subgraph ClientLane["Web client"]
    Show["Shows the new totals on the next page load"]:::step
  end

  Publish --> Join
  Join --> Record
  Record --> Pledge
  Pledge --> Verified
  Verified -->|"no"| Refuse
  Verified -->|"yes"| Count
  Count --> Show
  Show --> Deal
  Deal --> Conclude

  classDef person   fill:#fff3cd,stroke:#8a6d1d,color:#111
  classDef block    fill:#cfe4ff,stroke:#3a414a,color:#111
  classDef store    fill:#e2f0d9,stroke:#4f7a3a,color:#111
  classDef queue    fill:#fde2cf,stroke:#9c5a2a,color:#111
  classDef external fill:#f5f5f5,stroke:#9aa0a6,color:#111
  classDef infra    fill:#ede7f6,stroke:#5e4b8b,color:#111
  classDef step     fill:#ffffff,stroke:#3a414a,color:#111
  classDef decision fill:#e0f4f7,stroke:#1f6f7a,color:#111
```

Concluding a pledge runs through Funding the same way a new pledge does: Funding recounts, and
the concluded total shows on each page of the project the next time it is loaded. Nothing is
pushed to a page that is already open; a viewer reloads it to see a change.
