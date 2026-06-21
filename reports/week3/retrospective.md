## Learning Points

- **Product Backlog Migration:** Migrating user stories into individual GitHub issues highlighted the importance of atomic, traceable requirements. Each story now has a stable ID, clear acceptance criteria, and a direct link to its implementation.
- **Pivot Execution:** Transitioning from "Wolf and Sheep" to "Click to Live" required rapid re-scoping. The team concluded that a successful pivot requires aligning on a single reference and target audience before development begins.
- **Estimation:** Estimating the initial 15+ PBIs highlighted the difficulty of assessing unknown mechanics (e.g., AI Jailer). The team learned to split uncertain stories into smaller research tasks before sprint commitment.
- **Godot 3D Workflow:** Implementing the first-person controller and 3D room revealed a need for deeper Godot expertise. The team adopted built-in CharacterBody3D and raycast systems to optimize development time.
- **Customer Collaboration:** The Sprint Review demonstrated that transparent communication about delays and scope adjustments builds trust. The customer appreciated honest progress reporting over overpromising.

## Validated Assumptions

- **Technical Feasibility in Godot 4.6:** Validated. The core FPS controller, raycast-based interaction, and autoload-based GameManager architecture function as expected. The `score_changed` signal ensures decoupled code.
- **Platform Choice (Steam):** Validated during customer review. While Web was suggested for the previous concept, the dystopian 3D setting and pay-to-download model of "Click to Live" align better with the Steam audience.
- **Core Loop Viability:** Validated. The 30-second clicking phase generates player tension, as confirmed by early prototype playtests. The "physical attention as survival" USP is effective.
- **3D Art Style Direction:** Validated. The claustrophobic room with minimal lighting effectively establishes the dystopian atmosphere without requiring complex asset production.
- **Concept Pivot Decision:** Validated by customer approval. The "Click to Live" concept received explicit customer endorsement as a market-viable direction, confirming that the pivot was the correct strategic decision.
- **Market References:** The customer provided specific game references (Berry Bury Berry and CloverPit) to guide future development of incremental mechanics and atmospheric design.

## Friction and Gaps

- **Pivot Delay:** One week was allocated to the "Wolf and Sheep" concept before customer rejection. This delayed the start of "Click to Live" and severely compressed the Sprint 1 timeline.
- **Incomplete MVP v1 Delivery:** Due to the pivot delay and the technical complexity of the 3D environment, the team was unable to complete all "Must Have" stories within Sprint 1. Only US-013 (Core Clicking Mechanic) and US-021 (3D Room Environment & Movement) reached "Done" status. The remaining core features (US-014, US-015, US-016, US-017, US-018) were deferred to Sprint 2.
- **Technical Underestimation:** Implementing the first-person controller, raycast interactions, and 3D scene instancing in Godot 4.6 required significantly more time than initially estimated.
- **Premature Implementation:** Some Sprint 1 PBIs were started before their acceptance criteria were fully refined, resulting in rework during PR review.

## Planned Response

- **Immediate Sprint 2 Focus:** The highest priority for Sprint 2 is to complete the deferred "Must Have" stories (US-014 to US-018) to establish a fully playable core loop before implementing any "Should Have" features.
- **Deferred Features Integration:** Integrate the "Should Have" items (US-019, US-020, US-022) only after the core loop is fully functional.
- **Balance Tuning:** Allocate the initial days of Sprint 2 to playtesting and adjusting the quota curve based on empirical player data.
- **Market Research:** Study Berry Bury Berry and CloverPit to extract best practices for incremental progression and atmospheric tension.
- **Strict "Ready" Definition:** Enforce a policy that no PBI moves to `In Progress` until its acceptance criteria are written and reviewed by the team.
- **Affected PBIs:**
  - US-014 to US-018: [Issues #15 to #19](...) — Moved to the top of the Sprint 2 backlog with customer approval.
  - US-023: [Issue #24](...) — Shop interaction deferred; the gap will be documented in the README.
