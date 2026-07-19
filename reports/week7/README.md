# Week 7 Public Report: Sprint 5 & Final MVP v3 Delivery

## Project Overview

**Click to Live** is a rogue-lite incremental clicker game developed in Godot 4. Set in a dystopian world, players must fulfill oppressive quotas by clicking under extreme time pressure, balancing high-stress clicking phases with relaxed preparation and meta-progression phases.

This report covers **Sprint 5 (Week 7)**, focusing on delivering the final course version (`MVP v3`), resolving the remaining Week 6 trial feedback, finalizing the customer handover documentation, and preparing for the Demo Day presentation.

---

## Backlog and Sprint Management

* **Product Backlog Board:** [GitHub Project - Product Backlog View](https://github.com/orgs/Team-33-GameDev/projects/1/views/1)
- **Previous Week Evidence:** [Week 6 Public Report (`reports/week6/README.md`)](../week6/README.md)

### Sprint 5 Details

- **Sprint Goal:** Deliver the final course version (`MVP v3`) by resolving the remaining Week 6 trial feedback, finalizing the customer handover documentation, and ensuring the product is fully transitioned and ready for Demo Day.
- **Sprint Dates:** Monday, July 13, 2026 – Sunday, July 19, 2026.
- **Short Scope Summary:** Addressed visual clutter feedback for high entity counts, finalized all customer-facing documentation (`docs/customer-handover.md`, `CONTRIBUTING.md`, `AGENTS.md`), obtained explicit customer acceptance, and prepared the Demo Day presentation and rehearsal.
- **Total Sprint 5 Size:** 21 Story Points.

---

## Delivered Week 7 Follow-up & MVP v3 Changes

- **UX Polish:** Added a visual cap and UI toggle for Autoclicker entities to resolve the visual clutter feedback when 100+ entities are present, improving readability during high-stress phases.
- **Documentation Finalization:** Completed and reviewed `docs/customer-handover.md` with the customer, ensuring all deployment steps, configuration expectations, and troubleshooting guides are accurate and actionable.
- **Transition & Deployment:** Packaged the final Windows executable, provided the customer with secure access instructions, and obtained explicit confirmation of independent use.

---

## Customer Feedback Response (Sprint 5)

| Feedback point | Resulting PBI or issue | Status | Response |
| --- | --- | --- | --- |
| Request for clearer instructions on how to reset progress. | [#86 Docs: Add Reset Progress instructions to handover](https://github.com/Team-33-GameDev/GameDevProject/issues/86) | Done | Updated `docs/customer-handover.md` and in-game UI with explicit reset instructions. |

**Explanation of feedback not yet addressed:**
- **Request for macOS/Linux builds:** Deferred to post-course development. The current Godot export pipeline is optimized for the customer's Windows lab environment. Tracked in #88.

---

## Final Transition Outcome

The customer executed the final `MVP v3` build independently and we reviewed the final UAT scenarios during the Week 7 confirmation meeting:

- **Handover Level Reached:** `Independently used by customer`
- **Customer-Confirmation Status:** `Accepted`

### Summary of Transferred Assets
As detailed in [`docs/customer-handover.md`](../../docs/customer-handover.md), the following has been transferred or made available:
- **Source Code & Repository:** Full public access to the GitHub repository under the MIT License.
- **Deployment & Access:** Compiled Windows installer and step-by-step deployment guide for the school's lab machines.
- **Configuration:** Sanitized `.env.example` and out-of-band instructions for backend API key generation.

### Remaining Limitations
- **Limitations:** The current build only supports Windows 10/11 and Linux. macOS builds are deferred to post-course development. Controller support is currently limited to standard keyboard.
- **Follow-up Items:** None. The product has been fully accepted without conditions.

---

## Current Status and Demo Day Preparation

- **Current Status:** The final course version (`MVP v3`) is stable, fully documented, and explicitly accepted by the customer for independent use.
- **Demo Day Preparation:** 
  1. Successfully completed the required Week 7 lab rehearsal presentation (5 min presentation + 3 min Q&A).
  2. All team members presented at least one slide.
  3. The final Demo Day slide deck (PDF) and the pre-recorded, well-rehearsed demo video (< 2 minutes) are prepared and submitted via the private Moodle channel.

---

## Artifact Links and Evidence

- **Current Access / Run Instructions:** [README.md - Access and Run Instructions](../../README.md#access-and-run-instructions)
- **Repository Entry Point:** [Root `README.md`](../../README.md)
- **Contributor Guidance:** [`CONTRIBUTING.md`](../../CONTRIBUTING.md)
- **Agent Guidance:** [`AGENTS.md`](../../AGENTS.md)
- **Customer Handover Documentation:** [`docs/customer-handover.md`](../../docs/customer-handover.md)
- **Hosted Documentation Site:** [GameDevProject Hosted Docs (GitHub Pages)](https://team-33-gamedev.github.io/GameDevProject/)
- **Final SemVer Release (MVP v3):** [Itch.io](https://original-show.itch.io/click-to-live) (by Customer's request)
- **Changelog:** [`CHANGELOG.md`](../../CHANGELOG.md)

### Sprint Review & Reflection Artifacts
- **Sprint Review Transcript:** [Sprint Review Transcript](./sprint-review-transcript.md)
- **Sprint Review Summary:** [Sprint Review Summary](./sprint-review-summary.md)
- **Reflection:** [Week 7 Reflection](./reflection.md)
- **Retrospective:** [Week 7 Retrospective](./retrospective.md)
- **LLM Usage Report:** [Week 7 LLM Report](./llm-report.md)

---

## Contribution Traceability
| Member | Username | Issues | PRs Created | PRs Reviewed |
|---|---|---|---|---|
| Bogdan | @boopEvdakov |  | #213 | #214, #218 |
| Rustam | @JohnRutman | | #207, #216, #217, #218 | |
| Varvara | @Dorohina |  | Documentation PR |  |
| Yaroslav | @Original-Show | | #214 | #218 |
| David | @dxvlxp | | #206 | #213, #214, #216, #217, #218 |
