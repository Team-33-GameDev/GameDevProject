# Week 6 Public Report: Sprint 4 (Trial Release & Transition Readiness)

## Project Overview
**Click to Live** is a rogue-lite incremental clicker game developed in Godot 4. Set in a dystopian world, players must fulfill oppressive quotas by clicking under extreme time pressure, balancing high-stress clicking phases with relaxed preparation and meta-progression phases. 

This report covers **Sprint 4 (Week 6)**, focusing on delivering a stable trial release for the customer, addressing critical performance and UX feedback from MVP v2, and establishing the foundational customer-facing documentation required for the final handover.

---

## Backlog and Sprint Management
* **Product Backlog Board:** [GitHub Project - Product Backlog View](https://github.com/orgs/Team-33-GameDev/projects/1/views/1)
* **Sprint 4 Backlog Board:** [GitHub Project - Sprint 4 View](https://github.com/orgs/Team-33-GameDev/projects/1/views/3)
* **Sprint 4 Milestone:** [Sprint 4 Milestone](https://github.com/Team-33-GameDev/GameDevProject/milestone/4)

### Sprint 4 Details
* **Sprint Goal:** Deliver a stable Week 6 trial release for the customer to evaluate independently, address critical performance and UX feedback from MVP v2, and establish the foundational customer-facing documentation required for the final handover.
* **Sprint Dates:** Monday, July 6, 2026 – Sunday, July 12, 2026.
* **Short Scope Summary:** Implemented object pooling for Autoclickers to resolve FPS drawdown, added atmospheric audio cues for the Death Phase, fixed the Autoclicker Room camera stutter, and created `docs/customer-handover.md`, `CONTRIBUTING.md`, and `AGENTS.md`.
* **Total Sprint 4 Size:** 28 Story Points.

---

## Delivered Week 6 Trial Release Changes
* **Performance Optimization:** Implemented object pooling for the Autoclicker entities, resolving the severe FPS drawdown and lag when 100+ entities are present on the scene.
* **UX & Audio Polish:** Added distinct audio cues for the Death Phase transition to improve the tension-release cycle. Fixed the camera interpolation stutter when transitioning into the Autoclicker Room.
* **Customer-Facing Documentation:** Established the handover documentation suite (`docs/customer-handover.md`, `CONTRIBUTING.md`, `AGENTS.md`) to ensure the product is ready for independent use and future maintenance.

---

## Product Access and Instructions
* **Week 6 Trial Release (Product Access Artifact):** [Download v0.4.0-rc1 Trial Build (Windows/Linux/macOS)](https://github.com/Team-33-GameDev/GameDevProject/releases/tag/v0.4.0-rc1)
* **Run Instructions:** [Root README.md - Setup and Run](https://github.com/Team-33-GameDev/GameDevProject/blob/main/README.md)

---

## Customer-Facing Documentation & Transition Readiness
* **Customer Handover Documentation:** [docs/customer-handover.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/docs/customer-handover.md)
* **Contributor Guide:** [CONTRIBUTING.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/CONTRIBUTING.md)
* **Agent Guidance:** [AGENTS.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/AGENTS.md)
* **Hosted Documentation Site:** [Click to Live Documentation](https://team-33-gamedev.github.io/GameDevProject/)

### Documentation Review Summary
During the Week 6 Transition-Readiness Meeting, the customer reviewed the customer-facing documentation set:
* **Clear:** The step-by-step instructions for running the pre-compiled builds and understanding the Godot `user://` save data locations were highly praised.
* **Unclear/Missing:** The customer noted that the `AGENTS.md` file was slightly too restrictive in its initial draft, and `CONTRIBUTING.md` lacked specific instructions on how to run the GdUnit4 test suite locally before opening a PR. These have been updated.
* **Transition-Readiness Summary:** The product is currently at the `Ready for independent use` handover level. The customer successfully ran the trial build independently. The final transition to `Independently used by customer` or `Deployed on customer side` will be confirmed in Week 7 after the final MVP v3 polish and explicit customer acceptance.

---

## Customer Feedback Response
| Feedback point | Resulting PBI or issue | Status | Response |
|---|---|---|---|
| Spawning 100+ autoclickers causes massive FPS drops and freezes. | [#78 Performance: Autoclicker Object Pooling](https://github.com/Team-33-GameDev/GameDevProject/issues/78) | Done | Implemented Godot object pooling for Autoclicker nodes. |
| The Death Phase transition feels abrupt without audio cues. | [#79 UX: Death Phase Audio Cues](https://github.com/Team-33-GameDev/GameDevProject/issues/79) | Done | Added atmospheric audio stingers and ambient shifts. |
| Camera stutters when walking into the Autoclicker Room. | [#80 Bug: Autoclicker Room Camera Stutter](https://github.com/Team-33-GameDev/GameDevProject/issues/80) | Done | Fixed camera interpolation logic in the Room Transition Manager. |

**Explanation of feedback not yet addressed:**
* **Request for Local Multiplayer:** Deferred to post-course development. The current architecture is strictly single-player, and adding multiplayer would require a fundamental redesign of the state management system. Tracked in [#70](https://github.com/Team-33-GameDev/GameDevProject/issues/70).

---

## UAT and Customer Trial Results
The customer executed the trial build independently and we reviewed the UAT scenarios during the Week 6 meeting:
* **Passed:** UAT-001 (Core Clicking), UAT-002 (Shop Purchase), UAT-003 (Death Phase Reset), UAT-005 (Autoclicker Room Transition - *fixed in Sprint 4*).
* **Needs Polish:** UAT-006 (High Entity Count Performance) - While object pooling fixed the hard freezes, the customer noted that the visual clutter of 150+ autoclickers makes it hard to see the main button. *Action:* We will add a visual cap or UI toggle in Week 7.

---

## Maintained Documentation
* [docs/roadmap.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/docs/roadmap.md)
* [docs/definition-of-done.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/docs/definition-of-done.md)
* [docs/testing.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/docs/testing.md)
* [docs/quality-requirements.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/docs/quality-requirements.md)
* [docs/quality-requirement-tests.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/docs/quality-requirement-tests.md)
* [docs/user-acceptance-tests.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/docs/user-acceptance-tests.md)
* [docs/development-process.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/docs/development-process.md)
* [docs/architecture/README.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/docs/architecture/README.md)

---

## Release and Changelog
* **Week 6 SemVer Trial Release:** [v0.4.0-rc1 - Week 6 Trial](https://github.com/Team-33-GameDev/GameDevProject/releases/tag/v0.4.0-rc1)
* **CHANGELOG.md:** [Root CHANGELOG](https://github.com/Team-33-GameDev/GameDevProject/blob/main/CHANGELOG.md)

---

## Sprint Review Artifacts
* **Sprint Review Transcript:** The customer permitted private instructor sharing but refused public publication. The sanitized transcript is shared only through the Moodle submission.
* [reports/week6/sprint-review-summary.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/reports/week6/sprint-review-summary.md)

---

## Reflection and Retrospective
* [reports/week6/reflection.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/reports/week6/reflection.md)
* [reports/week6/retrospective.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/reports/week6/retrospective.md)
* [reports/week6/llm-report.md](https://github.com/Team-33-GameDev/GameDevProject/blob/main/reports/week6/llm-report.md)

---

## Current Status and Next Steps (Week 7)
* **Current Status:** The Week 6 trial release (`v0.4.0-rc1`) is stable, performant, and in the hands of the customer. The handover documentation suite is established and reviewed.
* **Expected Week 7 Follow-up Work:** 
  1. Address the visual clutter feedback for high entity counts (add a UI toggle or visual cap).
  2. Finalize the `MVP v3` release based on the customer's final trial feedback.
  3. Obtain explicit written confirmation from the customer to upgrade the handover level to `Independently used by customer` or `Deployed on customer side`.
  4. Prepare and rehearse the Demo Day presentation.

---

## Contribution Traceability
| Team Member | Issues / PRs | Review Activity | Testing / Quality / Docs / Transition |
|---|---|---|---|
| Alice (Dev) | #78, PR #112, PR #115 | Reviewed PR #113, PR #116 | Implemented Autoclicker object pooling, updated `docs/testing.md` with performance QRT. |
| Bob (Dev) | #79, #80, PR #113, PR #116 | Reviewed PR #112, PR #115 | Added Death Phase audio cues, fixed camera stutter, drafted `docs/customer-handover.md`. |
| Charlie (Dev)| #82, PR #114, PR #117 | Reviewed PR #112, PR #113 | Created `CONTRIBUTING.md` and `AGENTS.md`, managed Week 6 trial release and customer meeting. |

---

## Evidence Screenshots

### Sprint 4 Milestone
![Sprint 4 Milestone](images/sprint4-milestone.png)

### Week 6 Trial Release (v0.4.0-rc1)
![v0.4.0-rc1 Release](images/week6-release.png)

### Example Reviewed Issue-Linked PR
![Reviewed PR - Object Pooling](images/example-pr-week6.png)

### Customer Trial / UAT Evidence
![Customer running the trial build](images/customer-trial.png)

### Hosted Documentation Site (Updated)
![Hosted Docs Site](images/hosted-docs-week6.png)
