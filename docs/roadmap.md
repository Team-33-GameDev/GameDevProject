
## Product Goal
Deliver a rogue-lite incremental game with a dystopian setting where the player must fulfill quotas by clicking under time pressure, with meta-progression through permanent upgrades.

## Sprint 1 — Core Loop Foundation (MVP v1 - PARTIALLY COMPLETED)
**Status:** Completed  
**Goal:** Implement the core clicking mechanic and 3D environment.

**Completed Scope:**
- US-013: Core Clicking Mechanic
- US-021: 3D Room Environment & Movement

**Deferred to Sprint 2 (Customer Approved):**
- US-014: Timer and Quota System
- US-015: Basic UI
- US-016: Preparation Phase Flow
- US-017: Death Phase & Meta-Progression
- US-018: Basic Upgrade Selection

**Deliverable:** Partial MVP v1 with clickable button in 3D room (demonstrated to customer on June 22, 2026).

---

## Sprint 2 — Core Loop Completion (MVP v2)
**Status:** Completed  
**Goal:** Complete all remaining Must Have stories to establish a fully playable core loop, then begin implementing Should Have features.

**Scope (Priority 1 - Deferred Must Haves):**
- US-014: Timer and Quota System
- US-015: Basic UI
- US-016: Preparation Phase Flow
- US-017: Death Phase & Meta-Progression
- US-018: Basic Upgrade Selection

**Scope (Priority 2 - Should Haves):**
- US-019: Autoclicker Upgrade
- US-020: Click Multiplier Upgrade
- US-022: Visual Feedback for Clicks
- US-023: Shop Interaction
- US-027: Save/Load System

**Scope (Priority 3 - Could Haves):**
- US-024: Shop Item - Overtime
- US-025: Shop Item - Grace Period
- US-026: Lucky Bonus Upgrade

**Quality & Automation Scope:**
- Define 3 ISO/IEC 25010 Quality Requirements.
- Implement automated Quality Requirement Tests (QRTs) for Performance, Reliability, and Usability.
- Set up CI pipeline with automated testing and coverage checks.

**Deliverable:** MVP v2 — Fully playable build with complete core loop (timer, quota, HUD, all three phases) and initial upgrade/shop mechanics.

---

## Sprint 3: Progression Depth & MVP v2 (Assignment 5 Increment)
**Status:** Completed  
**Goal:** Deliver MVP v2 by expanding the meta-progression system, finalizing the death/upgrade loop, and hardening the software architecture.

**Key Deliverables (MVP v2 Scope):**

* **Core Loop Finalization:** US-017 (Death Phase & Meta-Progression), US-022 (Visual Feedback for Clicks), US-033 (Big Button).
* **Shop & Upgrades:** US-024 (Overtime), US-025 (Grace Period), and the newly expanded Autoclicker suite (US-036 to US-043, including Autoclicker Manipulators, Shop Displays, and Autoclicker Rooms).
* **UX/UI Improvements:** Main Menu integration (PR #162), Pause Menu (US-041), and Better Main Display (US-039).
* **Architecture & Process:** Finalizing Godot component/sequence diagrams, creating Architecture Decision Records (ADRs) for Godot scene-tree structures, and hosting the documentation site.

---

## 4. Next Expected Increment: Future Development (MVP v3 / Post-MVP v2)

**Status:** Planned / Backlog  
**Goal:** Expand endgame content, introduce adversarial elements, and polish the dystopian atmosphere.  
**Key Deliverables:**  
* **US-028:** AI Jailer (Boss) Presence – introducing an adversarial element that disrupts the player's clicking rhythm.
* **Atmosphere:** Final sound design, music integration, and visual variety for new room environments.

---

## Key Development Principles
1. **Core Loop First:** Complete the fundamental clicking → quota → upgrade → death cycle before expanding features
2. **Progressive Enhancement:** Each MVP version should be playable and testable on its own
3. **Player Agency:** Maintain the design pillar that almost every action requires player input and attention
4. **Tension-Release Cycle:** Preserve the balance between high-stress Clicking Phase and relaxed Preparation Phase
