# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Planned for MVP v3

- Basic HUD/UI (US-015)
- Preparation Phase Flow (US-016)
- Death Phase & Meta-Progression (US-017)
- Shop UI: Now includes separate sections for click upgrades, factory purchases, and special items (Overtime, Grace Period, Lucky Bonus).
- Implement 3D models 

## [0.2.0] - 2026-06-28

### Added
- **Timer and Quota System (US-14):** A 30-second countdown timer and a quota tracker. The clicking phase starts when the player clicks the button; if score ≥ quota at timer end – success (Preparation Phase), otherwise – failure (Death Phase).
- **Shop Interaction (US-23):** Full shop interface accessible by walking up to the shop on the opposite wall. Players can buy items using surplus click-points.
- **Shop Item – Grace Period (US-25):** Purchaseable item that reduces the current required quota.
- **Lucky Bonus Upgrade (US-26):** A new upgrade type that gives a random chance to earn a large amount of click-points in a single click.
- **Lose/Restart System (US-30):** When the player fails a quota (Death Phase), they can restart the run. All current run variables (score, timer, upgrades) are reset, but permanent meta-progression is retained. Restart returns the player to the Preparation Phase.
- **Main Menu and Settings UI (US-32):** Full title screen with game logo, Start/Settings/Exit buttons. Settings screen with audio volume sliders and graphics toggles; settings are saved persistently.
- **Audio (US-29):** Background music/ambient loop, sound effects for clicks, purchases, and game state transitions (e.g., Death Phase changes audio).
- **Click Upgrade System (expanded):** In addition to additive, multiplicative, percent-based, and critical upgrades, now includes the "Lucky Bonus" upgrade as a separate purchasable option.
- **Autoclicker Factories (US-19):** Players can buy factories that automatically generate click-points at a set interval. Each factory has HP, damage, and upgradable parameters (click power, HP, damage, interval, and restore per click).
- **Factory Upgrades (US-18, US-20):** Each factory can be upgraded in five categories with linearly increasing costs.
- **3D Model of the Player Room:** The basic main models for the room was created such as monitor, door, floor, сlothing rack, ventilation, table, and button for click

### Changed
- **GameManager:** Encapsulate main work with global 
- **QuotaManager** Support timer, quota, meta-progression

- **Interaction System:** The player can now walk to the shop and interact with it (raycast), opening the shop interface.
- **Audio Integration:** Added audio bus and volume controls; sound effects triggered on relevant actions.

### Fixed
- Factory timers properly clean up on removal.
- Score label updates smoothly with tween animations.
- Not implemented 3D into the scenes

### Known Issues
- Meta-progression save system is not yet fully tested.
- Some UI elements may not scale correctly at different resolutions.
- No visual indicator for active timer/quota in the 3D scene yet.

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

[0.2.0]: https://disk.yandex.ru/d/36-XD6MqxggnzQ
[0.1.0]: https://disk.yandex.ru/d/36-XD6MqxggnzQ
[0.0.0]: https://github.com/Team-33-GameDev/GameDevProject
