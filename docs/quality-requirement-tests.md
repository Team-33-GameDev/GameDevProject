# Quality Requirement Tests (QRT)

This document details the automated tests used to verify the Quality Requirements defined in `quality-requirements.md`. These tests run in the CI pipeline.

## QRT-01: Performance Load Test
**Verifies:** QR-01 (Performance Efficiency)

**Test Description:** An automated GUT (Godot Unit Test) script that instantiates 100 `ClickParticle` scenes, forces a physics frame process, and asserts that the total execution time is less than 16ms (ensuring 60 FPS capability under load).

**Location:** `gd-project/test/unit/test_performance_qrt.gd`

**Evidence Type:** Automated CI Test Run

## QRT-02: Save/Load Data Integrity Test
**Verifies:** QR-02 (Reliability)

**Test Description:** An automated GUT script that creates a mock player data dictionary, passes it to the `SaveManager` to write to a save file, reads it back, and asserts that all values match exactly without throwing errors.

**Location:** `gd-project/test/unit/test_reliability_qrt.gd`

**Evidence Type:** Automated CI Test Run

## QRT-03: HUD Operability Test
**Verifies:** QR-03 (Usability)

**Test Description:** An automated GUT script that instantiates the `HUD.tscn` scene, waits for the `ready` signal, and asserts that the `QuotaLabel`, `ScoreLabel`, and `TimerLabel` nodes are visible and contain non-empty text strings.

**Location:** `gd-project/test/unit/test_usability_qrt.gd`

**Evidence Type:** Automated CI Test Run
