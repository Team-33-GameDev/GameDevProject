# Product Roadmap

## Product Goal
Deliver a rogue-lite incremental game with a dystopian setting where the player must fulfill quotas by clicking under time pressure, with meta-progression through permanent upgrades and environmental interactions.

---

## Sprint 1 — Core Loop Foundation (MVP v1)
- **Dates:** 15.06.2026 – 21.06.2026
- **Sprint Goal:** Implement the core clicking mechanic and 3D environment to establish a foundational, testable game loop.
- **Focus/Outcome:** Delivered a partial MVP v1 with a clickable button in a 3D room, establishing the base for the tension-release cycle.
- **Key Items:** 
  - Core Clicking Mechanic & 3D Room Environment
  - *(Deferred to later Sprints with customer approval: Menu, Upgrades, Quota System)*

---

## Sprint 2 — Quality, Automation & Core Loop Refinement (Assignment 4)
- **Dates:** 22.06.2026 – 28.06.2026
- **Sprint Goal:** Harden the product foundation by implementing automated quality gates, CI pipelines, and refining the core loop based on initial feedback.
- **Focus/Outcome:** Established measurable quality requirements (ISO/IEC 25010), automated Quality Requirement Tests (QRTs), and CI checks, while progressing on menu, upgrades, and the quota system.
- **Key Items:**
  - QR-001, QR-002, QR-003: Quality Requirements
  - QRT-001, QRT-002, QRT-003: Automated Quality Tests
  - CI/CD setup and core loop refinements

---

## Sprint 3 — Progression Depth & MVP v2 (Assignment 5)
- **Dates:** 29.06.2026 – 05.07.2026
- **Sprint Goal:** Deliver MVP v2 by expanding the meta-progression system, finalizing the death/upgrade loop, and hardening the software architecture.
- **Focus/Outcome:** Delivered a fully playable build with a complete core loop (timer, quota, HUD, all three phases), expanded shop/autoclicker mechanics, and documented architecture (static, dynamic, deployment views + ADRs).
- **Key Items:**
  - Death Phase & Meta-Progression Mechanics
  - Visual Feedback for Clicks & Shop Displays
  - ADR-001, ADR-002, ADR-003: Architecture Decision Records

---

## Sprint 4 — Trial Release & Transition Readiness (Assignment 6, Week 6)
- **Dates:** 06.07.2026 – 12.07.2026
- **Sprint Goal:** Produce a stable trial/handover-candidate release, refine core gameplay loops, and prepare customer-facing documentation for transition readiness.
- **Focus/Outcome:** Delivered a stable trial increment for customer evaluation, integrated major visual/gameplay features, and updated handover documentation.
- **Key Items (Synthesized from PRs):**
  - **PBI: Game Room Integration & Visual Polish:** Integrated complete Game Room scene (Main Room, Factory Room, Big Button Room), added 6 animated factory models with materials, and updated room geometry/scene layout.
  - **PBI: Core Gameplay Mechanics (Big Button):** Added a "Big Button" in the main room scene that decreases the quota, providing a tangible, interactive gameplay element.
  - **PBI: UI/UX Adjustments:** Adjusted shop screen size for better visibility and usability during the trial phase.
  - **PBI: Documentation & Handover Preparation:** Created/updated root `README.md` and `CHANGELOG.md` (v0.3.0) to prepare for the trial release and customer handover.
  - **PBI: Architecture & Code Quality:** Updated ADR-001 (signal decoupling) to ensure maintainable architecture practices.

---

## Sprint 5 — Final Transition & MVP v3 Delivery (Assignment 6, Week 7)
- **Dates:** 13.07.2026 – 19.07.2026
- **Sprint Goal:** Incorporate Week 6 trial feedback, complete final product transition, and deliver the final course version (`MVP v3`) ready for Demo Day.
- **Focus/Outcome:** Delivered `MVP v3` with all critical fixes, enriched environmental interactions, finalized handover status, and prepared Demo Day presentation materials.
- **Key Items (Synthesized from PRs):**
  - **PBI: Gameplay Balancing & Fixes:** Rebalanced factory DPS (production rate) and adjusted screen sizes based on customer trial feedback.
  - **PBI: Input & Phase Logic Refinement:** Fixed game logic so the "clicking phase" now only initiates from direct player input, improving control and predictability.
  - **PBI: Factory Statistics Display:** Added factory statistics displays and big button information displays to provide players with clear meta-progression and production feedback.
  - **PBI: Environmental Interaction Mechanics:** Added a crowbar interaction system (pick up, throw, destroy wooden plates) and an interactive door (opened with 'E' key) to enrich the game environment.
  - **PBI: Visual Polish:** Added a new menu background to finalize the game's presentation.
  - **PBI: Final MVP v3 Release Preparation:** Finalized `CHANGELOG.md`, ensured all CI checks passed, and prepared the final `MVP v3` SemVer release for Demo Day.

---

## Key Development Principles
1. **Core Loop First:** Complete the fundamental clicking → quota → upgrade → death cycle before expanding features.
2. **Progressive Enhancement:** Each MVP version is playable, testable, and incrementally richer than the last.
3. **Player Agency:** Maintain the design pillar that almost every action requires player input and attention.
4. **Tension-Release Cycle:** Preserve the balance between high-stress Clicking Phase and relaxed Preparation Phase.
5. **Maintainability:** All architecture decisions, quality gates, and CI checks are treated as living assets, updated alongside feature development.
