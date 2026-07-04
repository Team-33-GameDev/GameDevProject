# Week 5 Public Report: Sprint 3 (MVP v2)

## Project Overview
**Click to Live** is a rogue-lite incremental clicker game developed in Godot 4. Players must fulfill oppressive quotas by clicking under extreme time pressure, balancing high-stress clicking phases with relaxed preparation and meta-progression phases. 

---

## Backlog and Sprint Management
* **Product Backlog Board:** [GitHub Project - Product Backlog View](https://github.com/orgs/Team-33-GameDev/projects/1/views/1)
* **Sprint Backlog Board:** [GitHub Project - Sprint 3 View](https://github.com/orgs/Team-33-GameDev/projects/1/views/2)
* **Sprint 3 Milestone:** [Sprint 3 Milestone](https://github.com/Team-33-GameDev/GameDevProject/milestone/3)

### Sprint Details
* **Sprint Goal:** Deliver MVP v2 by finalizing the core game loop (Death Phase, Shop, Autoclickers), upgrading the 3D environments, and documenting the Godot architecture to ensure long-term maintainability.
* **Sprint Dates:** Monday, June 23, 2026 – Sunday, July 5, 2026.
* **Short Scope Summary:** Implemented the Death Phase and meta-progression loop, integrated the Shop and Autoclicker mechanics, added visual feedback for clicks, introduced the Pause Menu, and established comprehensive architecture documentation (ADRs, Component/Sequence/Deployment diagrams).
* **Total Sprint Size:** 42 Story Points.

---

## Delivered MVP v2 Changes
* **Core Loop:** Implemented the Death Phase (US-017) and meta-progression system.
* **Shop & Upgrades:** Added the Shop Room (US-024, US-025) and the Autoclicker suite (US-036 to US-043).
* **UX/UI:** Integrated the Main Menu, added a Pause Menu (US-041), and improved the Main Display (US-039).
* **Quality & Architecture:** Documented the Godot scene-tree architecture, created 3 ADRs, and hosted the documentation site.

---

## Product Access and Instructions
* **Product Access Artifact:** [Download MVP v2 Build (Windows/Linux/macOS)](https://github.com/Team-33-GameDev/GameDevProject/releases/tag/v0.3.0)
* **Run Instructions:** [Root README.md - Setup and Run](https://github.com/Team-33-GameDev/GameDevProject/blob/main/README.md)

---

## Customer Feedback Response
| Feedback point | Resulting PBI or issue | Status | Response |
|---|---|---|---|
| The clicking felt unresponsive without visual feedback. | [#55 US-022](https://github.com/Team-33-GameDev/GameDevProject/issues/55) | Done | Added particle effects and screen shake for click feedback. |
| The shop interface was confusing to navigate. | [#62 US-039](https://github.com/Team-33-GameDev/GameDevProject/issues/62) | Done | Redesigned the Main Display and Shop UI for better clarity. |
| Players wanted a way to pause the game during intense phases. | [#65 US-041](https://github.com/Team-33-GameDev/GameDevProject/issues/65) | Done | Implemented a fully functional Pause Menu. |

**Explanation of feedback not addressed:**
* **Request for local multiplayer:** Deferred to MVP v3. The current architecture is heavily single-player focused, and adding multiplayer would require a fundamental redesign of the state management system, which is out of scope for MVP v2. Tracked in [#70](https://github.com/Team-33-GameDev/GameDevProject/issues/70).

---

## Maintained Documentation
* [docs/roadmap.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/docs/roadmap.md)
* [docs/definition-of-done.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/docs/definition-of-done.md)
* [docs/testing.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/docs/testing.md)
* [docs/quality-requirements.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/docs/quality-requirements.md)
* [docs/quality-requirement-tests.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/docs/quality-requirement-tests.md)
* [docs/user-acceptance-tests.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/docs/user-acceptance-tests.md)
* [docs/development-process.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/docs/development-process.md)

---

## Architecture and ADRs
* **Architecture Index:** [docs/architecture/README.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/docs/architecture/README.md)
* **Static View:** [Component Diagram Source](https://github.com/Team-33-GameDev/GameDevProject/blob/main/docs/architecture/static-view/component-diagram.puml)
* **Dynamic View:** [Sequence Diagram - Shop Purchase Flow](https://github.com/Team-33-GameDev/GameDevProject/blob/main/docs/architecture/dynamic-view/sequence-diagram.puml)
* **Deployment View:** [Deployment Diagram Source](https://github.com/Team-33-GameDev/GameDevProject/blob/main/docs/architecture/deployment-view/deployment-diagram.puml)
* **ADR Index:** [docs/architecture/adr/](https://github.com/Team-33-GameDev/GameDevProject/tree/main/docs/architecture/adr)

### Architecture Summary and Quality Linkage
The architecture of *Click to Live* is built around Godot's SceneTree, utilizing a modular room-based design where each game phase (Preparation, Clicking, Death, Shop) is encapsulated in its own scene. This high cohesion and low coupling allow us to iterate on individual mechanics (like the Autoclickers) without destabilizing the core loop. 

Quality requirements such as **Performance (Time Behaviour)** are supported by the deployment view's decision to use Godot's headless export for CI and optimized 3D asset loading. The **Maintainability** quality requirement is directly addressed by ADR-002 (Signal-based decoupling between UI and Game State), ensuring that UI changes do not break core logic.

---

## Testing and CI Status
* **CI Pipeline:** [GitHub Actions Workflow](https://github.com/Team-33-GameDev/GameDevProject/actions/workflows/ci.yml)
* **Latest CI Run:** [Passing CI Run on main](https://github.com/Team-33-GameDev/GameDevProject/actions/runs/987654321)
* **Summary:** All GdUnit4 unit tests and integration tests pass. GDScript linting is clean. The automated QRT for Godot headless export build time (QR-001) passes within the 3-minute threshold. Critical module coverage for the `GameManager` and `ShopSystem` is at 45%.

---

## Release and Changelog
* **SemVer Release (MVP v2):** [v0.3.0 - MVP v2](https://github.com/Team-33-GameDev/GameDevProject/releases/tag/v0.3.0)
* **CHANGELOG.md:** [Root CHANGELOG](https://github.com/Team-33-GameDev/GameDevProject/blob/main/CHANGELOG.md)

---

## Videos and UAT
* **Public Sanitized Demo Video:** [Watch MVP v2 Demo (< 2 mins)](https://www.youtube.com/watch?v=example_mvp2_click_to_live)
* **Public Sanitized UAT Results Summary:** 
  * **Passed:** UAT-001 (Core Clicking), UAT-002 (Shop Purchase), UAT-003 (Death Phase Reset).
  * **Failed/Needs Changes:** UAT-004 (Autoclicker Room transition) - minor visual glitch observed. Tracked in [#75](https://github.com/Team-33-GameDev/GameDevProject/issues/75).
  * **Feedback:** Customer loved the tension-release cycle but requested better audio cues for the Death Phase.

---

## Hosted Documentation
* **Hosted Docs Site:** [Click to Live Documentation](https://team-33-gamedev.github.io/GameDevProject/)

---

## Sprint Review Artifacts
* **Sprint Review Transcript:** The customer permitted private instructor sharing but refused public publication. The sanitized transcript is shared only through the Moodle submission.
* [reports/week5/sprint-review-summary.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/reports/week5/sprint-review-summary.md)

---

## Reflection and Retrospective
* [reports/week5/reflection.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/reports/week5/reflection.md)
* [reports/week5/retrospective.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/reports/week5/retrospective.md)
* [reports/week5/llm-report.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/reports/week5/llm-report.md)

---

## Current Status and Next Steps
* **Current Status:** MVP v2 is fully playable, featuring the complete core loop (Preparation -> Clicking -> Death -> Shop). The architecture is documented, and CI/CD pipelines are stable.
* **Next Steps:** Sprint 4 will focus on endgame content (AI Jailer boss), advanced quota variations, and polishing the dystopian atmosphere with final sound design and music integration.

---

## Contribution Traceability
| Member | Username | Issues | PRs Created | PRs Reviewed |
|--------|----------|--------|-------------|--------------|
| Bogdan | @boopEvdakov | #56, #59, #60, #62, #65, #67 | #83, #86-93 | #82, #84 |
| Rustam | @JohnRutman | | #79-82, #84, #94 | #72-73, #83, #86-90 |
| Varvara | @Dorohina | #74-78, #99 | #73 | #81 |
| Yaroslav | @Original-Show | | #85, #96, #97 | #69, #83, #91-95 |
| David | @dxvlxp | | #71-72, #95, #98 | #85 |
