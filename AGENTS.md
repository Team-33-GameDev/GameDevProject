# AGENTS.md

## Scope

These instructions apply to the whole `GameDevProject` repository unless a more specific `AGENTS.md` exists in a subdirectory.

This repository contains **Click to Live**, a Godot 4.7 Forward+ project. The playable project is under `gd-project/`; architecture and process documentation are under `docs/`; weekly reports are under `reports/`.

## Primary Objective

Make the smallest safe change that satisfies the issue while preserving the complete player journey:

```text
launch -> understand objective -> click/earn -> upgrade/use factories ->
use room mechanics -> reach a clear completion or reset state
```

Do not optimize only for an isolated scene or script when the change affects the integrated build.

## Technical Baseline

- Engine: Godot 4.7
- Renderer: Forward+
- Physics: Jolt Physics
- Project: `gd-project/project.godot`
- Primary export: `Windows Desktop`
- Secondary export: `Linux`
- Main language: GDScript

Important autoloads:

- `GameManager`
- `QuotaManager`
- `AudioManager`
- `FpsManager`
- `SaveManager`

Treat changes to autoloads as cross-cutting.

## Repository Map

```text
.
|-- gd-project/
|   |-- assets/
|   |-- resources/
|   |-- scenes/
|   |-- scripts/
|   |-- test/unit/
|   |-- project.godot
|   `-- export_presets.cfg
|-- docs/
|-- reports/
|-- .github/
|-- README.md
|-- CUSTOMER_HANDOVER.md
|-- CONTRIBUTORS.md
|-- ATTRIBUTION.md
`-- CHANGELOG.md
```

## Required Reading Before Major Changes

- `README.md`
- `docs/development-process.md`
- `docs/definition-of-done.md`
- `docs/architecture/README.md`
- `docs/user-stories.md`
- `CHANGELOG.md`
- `ATTRIBUTION.md`

For Assignment 6 work, also read:

- `reports/week6/README.md`
- `reports/week6/sprint-review-summary.md`
- `CUSTOMER_HANDOVER.md`

## Working Rules

### Do

- Keep changes focused on the issue and acceptance criteria.
- Reuse existing signals, managers, resources, and scene patterns.
- Prefer typed GDScript where it improves correctness.
- Preserve signal-based decoupling between UI and game state.
- Update documentation when behavior, controls, architecture, exports, or handover steps change.
- Update `CHANGELOG.md` for user-visible changes.
- Update `ATTRIBUTION.md` when adding third-party assets.
- Keep the final 10-15 minute player experience in mind.

### Do Not

- Do not commit secrets, tokens, personal contacts, or private Moodle links.
- Do not commit presentation recordings or identifiable meeting media publicly.
- Do not publicly commit a transcript without required participant consent.
- Do not add generated builds, `.godot/` caches, or unrelated archives.
- Do not manually edit generated `.import` files.
- Do not delete Godot UID metadata without understanding references.
- Do not casually rename scenes, nodes, signals, input actions, or autoloads.
- Do not make broad formatting changes in unrelated files.
- Do not replace working team assets with generated content without approval.
- Do not claim a test or build passed unless it was run.

## Godot Conventions

- Keep scene-specific behavior close to its scene/script.
- Use autoloads only for genuinely global state.
- Prefer signals over hard-coded node-path coupling across major systems.
- Keep UI synchronized with game state and save state.
- Check exported node references before dereferencing them.
- Avoid frame-dependent gameplay logic; use `delta`, timers, or physics callbacks.
- Preserve input actions in `project.godot`:
  - `up`
  - `down`
  - `left`
  - `right`
  - `jump`
  - `interact`
  - `click`
  - `restart_game`

## Assets

Before adding or replacing an asset:

1. confirm its source and license;
2. place it in the correct `gd-project/assets/` subdirectory;
3. update `ATTRIBUTION.md`;
4. verify import settings;
5. verify a clean export;
6. avoid duplicate archives or source bundles unless required.

Check large models, textures, and audio for repository size, import time, memory use, missing-resource errors, and export packaging.

## Testing and Validation

Run the narrowest relevant test first, then validate the integrated flow.

Minimum import check:

```bash
godot --headless --path gd-project --editor --quit
```

Existing automated tests are stored under `gd-project/test/unit/` and related test directories. Use the project's configured runner; do not introduce a new framework for one change without approval.

For release-affecting work:

1. open the project in Godot 4.7;
2. run the main scene;
3. inspect the debugger;
4. test the affected feature;
5. smoke-test the main player path;
6. export and run a clean Windows build when practical.

Example Windows release export:

```bash
godot --headless --path gd-project \
  --export-release "Windows Desktop" \
  ../mvp3_builds/Windows/GDProject.exe
```

The presence of an output file is not enough. Launch it and verify behavior.

## Feature-Specific Regression Areas

### Quota and Big Button

Check quota amount, boundaries, timer interaction, repeated activation, reset/restart, save/load consistency, UI, and audio.

### Factory Manager and Upgrades

Check intended opening interaction, mouse/input focus, close/back behavior, previous/next navigation, affordability, purchases, statistic updates, model tier updates, and persistence.

### Shop

Check that intended raycast interaction opens the shop, unrelated clicks do not, purchases update once, insufficient-funds behavior is clear, and closing restores control.

### Audio

Check event mapping, duplicate triggers, volume buses, pause/menu behavior, transitions, and missing resources.

### Save System

Check first run, valid save, malformed or old save, reset, new fields, and state synchronization after loading.

## Documentation and Reports

Public files must not contain real private links. Use placeholders only in private templates and replace them before submission.

Keep these consistent:

- `README.md`
- `CUSTOMER_HANDOVER.md`
- `reports/week6/README.md`
- private `week6-moodle-report.md`
- private `SUBMISSION_LINKS.md`

## Pull Request Checklist

- [ ] Issue and acceptance criteria understood.
- [ ] Change is focused.
- [ ] Project imports without new errors.
- [ ] Relevant tests were run.
- [ ] Integrated player flow was considered.
- [ ] User-visible behavior was manually verified.
- [ ] Documentation/changelog updated where necessary.
- [ ] External assets attributed.
- [ ] No private materials or secrets added.
- [ ] Final response states what was and was not tested.

## Response Format for Coding Agents

A final agent response should include:

1. concise change summary;
2. main files modified;
3. tests/checks actually run;
4. remaining risks or unverified behavior;
5. manual steps required from the team.

Never fabricate results.
