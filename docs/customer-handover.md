# Customer Handover

## Document Purpose

This is the canonical handover guide for **Click to Live**. It describes the delivered materials, source checkout, launch and export procedures, acceptance checks, release placeholders, known risks, and ownership information required by the customer or course representatives.

## Product Overview

**Click to Live** is a first-person rogue-lite incremental clicker developed in Godot. The player must satisfy escalating quotas, improve clicking and factory production, move between interconnected rooms, and use special mechanics such as the Big Button to survive a run.

## Technical Baseline

| Item | Value |
|---|---|
| Engine | Godot 4.7 |
| Renderer | Forward+ |
| Physics | Jolt Physics |
| Primary target | Windows Desktop x86_64 |
| Secondary export preset | Linux x86_64 |
| Project directory | `gd-project/` |
| Main project file | `gd-project/project.godot` |
| Repository | https://github.com/Team-33-GameDev/GameDevProject |
| License | MIT for team-created source and content; see `ATTRIBUTION.md` for third-party assets |

## Handover Package

### Public Repository Materials

- Source code and game project: `gd-project/`
- Root project overview: `README.md`
- Contributor registry: `CONTRIBUTORS.md`
- AI-agent repository instructions: `AGENTS.md`
- Third-party asset attribution: `ATTRIBUTION.md`
- Changelog: `CHANGELOG.md`
- Architecture and development documentation: `docs/`
- Week 6 public report: `reports/week6/`

### Private Submission Materials

These materials should normally be delivered through Moodle or another instructor-accessible private channel:

- Week 6 Moodle report PDF;
- Assignment 6 slide-deck PDF;
- rehearsed presentation video link;
- raw or identifiable meeting recordings;
- private transcript, unless all participants approve public publication;
- Week 7 updated slides and report.

## Release Identification

Complete this table before final handover.

| Field | Final value |
|---|---|
| Release name | `TODO_INSERT_RELEASE_NAME` |
| Git commit | `TODO_INSERT_FINAL_COMMIT_HASH` |
| Git tag | `TODO_INSERT_FINAL_TAG` |
| Build date | `TODO_INSERT_BUILD_DATE` |
| Windows build URL | `TODO_INSERT_BUILD_DOWNLOAD_LINK` |
| itch.io page | `TODO_INSERT_ITCH_IO_PAGE_LINK` |
| Release owner | `TODO_INSERT_RELEASE_OWNER` |

Do not describe a build as final unless the commit, tag, and distributed artifact have been verified to match.

## Repository Checkout

```bash
git clone https://github.com/Team-33-GameDev/GameDevProject.git
cd GameDevProject
```

Open:

```text
gd-project/project.godot
```

The project declares Godot **4.7** and the **Forward+** renderer. Opening it in an older engine version may modify project files or fail to load resources correctly.

## Running from the Editor

1. Install Godot 4.7 with export templates.
2. Open `gd-project/project.godot`.
3. Allow Godot to import resources.
4. Run the configured main scene.
5. Verify that no required-resource errors appear in the debugger.

Minimum command-line import check:

```bash
godot --headless --path gd-project --editor --quit
```

## Exporting a Release Build

The repository includes Windows Desktop and Linux export presets.

Example Windows export:

```bash
mkdir -p mvp3_builds/Windows
godot --headless --path gd-project \
  --export-release "Windows Desktop" \
  ../mvp3_builds/Windows/GDProject.exe
```

Verify the real output path and package every required `.pck` or supporting file produced by the export.

## Player Controls

| Input | Action |
|---|---|
| `W`, `A`, `S`, `D` | Move |
| Mouse | Look and aim |
| Left Mouse Button | Click or activate a supported interaction |
| `E` | Interact with supported world objects |
| Space | Jump |
| `R` | Restart where supported |
| `Esc` | Pause or close the current menu where supported |

The shipped build and itch.io page must contain a verified controls list matching the final implementation.

## Expected Product Flow

The final Assignment 6 build should provide a coherent short experience:

1. The player enters the game and understands the objective.
2. The player clicks and earns progress toward the quota.
3. The player uses upgrades and factories to improve production.
4. The player can move between the Main Room, Factory Room, and Big Button Room.
5. Quota, timer, audio, UI, and save-related state remain synchronized.
6. The player reaches a clear ending, completion, or reset state within the intended 10-15 minute session.

## Core Runtime Services

The project registers these autoloads:

- `GameManager`
- `QuotaManager`
- `AudioManager`
- `FpsManager`
- `SaveManager`

Changes to these services are cross-cutting and require validation of dependent UI, rooms, save behavior, and signals.

## Acceptance Checklist

### Source and Documentation

- [ ] Repository access works for the customer/instructors.
- [ ] Final commit and tag are recorded.
- [ ] `README.md` reflects the delivered version.
- [ ] `CHANGELOG.md` contains the delivered changes.
- [ ] `CONTRIBUTORS.md`, `AGENTS.md`, and `ATTRIBUTION.md` are present.
- [ ] Week 6 report links are valid.

### Build

- [ ] Windows release build launches on a clean environment.
- [ ] No missing-resource errors appear.
- [ ] Main Room loads.
- [ ] Movement, looking, jumping, clicking, and interaction work.
- [ ] Quota and timer update correctly.
- [ ] Shop and upgrades work.
- [ ] Factory manager navigation and purchases work.
- [ ] Factory visual tiers match gameplay state.
- [ ] Big Button behavior updates the intended quota state.
- [ ] Audio and settings behave correctly.
- [ ] Save and restart behavior is acceptable.
- [ ] The intended run has a clear completion or reset path.

### Distribution

- [ ] itch.io page is accessible.
- [ ] Download link serves the same verified build.
- [ ] Controls and minimum requirements are documented.
- [ ] Screenshots or gameplay media represent the delivered build.
- [ ] Known limitations are disclosed.
- [ ] Private materials are not exposed publicly without consent.

## Known Release Risks

- The final build must be tested as one connected experience, not only as separate scenes.
- Large 3D and audio assets can expose missing-import or packaging problems on a clean machine.
- The final build URL, itch.io URL, release tag, and video link still require human insertion.
- Transcript and meeting-video publication require an explicit privacy decision.
- A late feature merge invalidates earlier smoke-test evidence; repeat the checklist after the final merge.

## Maintenance and Ownership

Complete before handover.

| Area | Primary owner | Backup owner |
|---|---|---|
| Repository administration | `TODO` | `TODO` |
| Release/export process | `TODO` | `TODO` |
| itch.io page | `TODO` | `TODO` |
| Godot gameplay systems | `TODO` | `TODO` |
| 3D assets and materials | `TODO` | `TODO` |
| Audio | `TODO` | `TODO` |
| Documentation | `TODO` | `TODO` |

## Customer Acceptance Record

| Field | Value |
|---|---|
| Handover date | `TODO` |
| Accepted commit/tag | `TODO` |
| Accepted build link | `TODO` |
| Customer/instructor representative | `TODO` |
| Outstanding conditions | `TODO` |
| Acceptance status | `Pending` |

## Related Documents

- [README](README.md)
- [Contributors](CONTRIBUTORS.md)
- [Agent Instructions](AGENTS.md)
- [Attribution](ATTRIBUTION.md)
- [Definition of Done](docs/definition-of-done.md)
- [Development Process](docs/development-process.md)
- [Week 6 Report](reports/week6/README.md)
