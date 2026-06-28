# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned for MVP v2
- Timer and Quota System (US-014)
- Basic HUD/UI (US-015)
- Preparation Phase Flow (US-016)
- Death Phase & Meta-Progression (US-017)
- Basic Upgrade Selection (US-018)
- Autoclicker Upgrade (US-019)
- Click Multiplier Upgrade (US-020)
- Visual Feedback for Clicks (US-022)
- Shop Interaction (US-023)

---

## [0.1.0] - 2026-06-22

### Added
- **Core Clicking Mechanic (US-013):** Functional button that emits signals on interaction, integrated with GameManager autoload for centralized score tracking.
- **3D Room Environment (US-021):** First-person player controller with WASD movement, mouse-look camera, and raycast-based interaction system.
- **GameManager Autoload:** Centralized state management with `score_changed` signal for decoupled score tracking.
- **Click Button Entity:** Interactive 3D button with animation feedback (`Button_Clicked` animation) and collision detection via Area3D.
- **Monitor System:** 3D monitor prop with SubViewport-based display for showing game data (score label).
- **Score Label:** UI element with bounce animation (Tween) on score change, integrated with GameManager signals.
- **Input System:** Configured input actions for movement (WASD), mouse look, click interaction, and future interactions (jump, interact).
- **Physics Setup:** Jolt Physics engine integration with proper collision layers for interactable objects.
- **Blender Pipeline:** Working import pipeline for `.blend` models (monitor asset) into Godot 4.6.

### Changed
- **Project Pivot:** Completely transitioned from "Wolf and Sheep" (top-down stealth) concept to "Click to Live" (rogue-lite incremental) based on customer feedback from Week 2 Sprint Review.
- **Target Platform:** Shifted from multi-platform (Steam/Web/Mobile) to Steam-only for better market fit.
- **Target Audience:** Refined from "7-16 and 50+" to "Teens and Young Adults (13+)".
- **Art Direction:** Adopted claustrophobic dystopian 3D room setting inspired by CloverPit.

### Removed
- "Wolf and Sheep" game concept, user stories (US-001 to US-012), and associated assets (deprecated).

### Known Issues
- Timer and quota systems are not yet implemented.
- HUD/UI for displaying game state is missing.
- Preparation and Death phases are not functional.
- Upgrade system and shop are not implemented.

---

## [0.0.0] - 2026-06-08

### Added
- Initial repository setup.
- Godot 4.6.1 project structure (`gd-project/`).
- MIT License.
- Initial documentation structure (`docs/`, `reports/`).
- Issue and PR templates for GitHub workflow.
- Definition of Done (`docs/definition-of-done.md`).
- Roadmap (`docs/roadmap.md`).
- User stories index (`docs/user-stories.md`).

[0.1.0]: https://disk.yandex.ru/d/36-XD6MqxggnzQ
[0.0.0]: https://github.com/Team-33-GameDev/GameDevProject
