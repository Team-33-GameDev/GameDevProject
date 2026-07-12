# Sprint Retrospective

## Sprint Identification

- **Project:** Click to Live
- **Sprint:** Sprint 4 / Week 6 reporting period
- **Review date:** 12 July 2026
- **Approximate period:** 6–12 July 2026
- **Primary focus:** Big Button completion, factory-management UI, visual factory progression, audio expansion, room integration, and final-delivery clarification.

## Sprint Goal Assessment

**Goal:** Convert the previous sprint's separate gameplay prototypes into a more coherent multi-room increment and improve feedback through UI, visual progression, and audio.

**Assessment: Partially achieved.**

The repository and review contain evidence that the planned mechanics were implemented or substantially advanced. However, the review did not validate a stable end-to-end build. Room integration and final polish were still in progress on the review day, and the stakeholders requested a complete 10–15 minute experience before final acceptance.

## What Went Well

1. **The team responded directly to previous feedback.**
   The addition of multiple visual factory tiers addresses the earlier criticism that factory progression was represented mainly by changing numbers.

2. **Parallel feature ownership produced visible progress.**
   Factory UI, 3D models, audio, Big Button behavior, and shop interaction all advanced during the week.

3. **The factory-management interaction became closer to a real game feature.**
   The UI moved from test buttons toward an in-world interaction with navigation and upgrade screens.

4. **The Big Button mechanic was connected to the quota system.**
   The mechanic now affects a core game variable rather than existing only as a room prototype.

5. **An incorrect interaction boundary was fixed.**
   The shop UI no longer opens from any left-mouse click and instead uses the intended player raycast interaction.

6. **The team asked the right product-delivery questions.**
   The meeting clarified the expected final player experience, itch.io publication, repository/build handover, and pitch materials.

7. **Stakeholders confirmed that the concept remains promising.**
   The problem is final coherence and polish, not rejection of the product idea.

## What Did Not Go Well

1. **Integration happened too late.**
   The team was still joining rooms and polishing the build on the review day. This reduced the time available for regression testing and external validation.

2. **The review began as a verbal status report instead of a product inspection.**
   Stakeholders could not assess several claims until screen sharing began, and even then the build was described as unfinished.

3. **The sprint lacked a precise player-facing completion condition.**
   Features were implemented, but the team had not defined a clear start, progression, and end for the first 10–15 minute session.

4. **Audio and communication problems reduced meeting efficiency.**
   Participants had difficulty hearing one speaker, and the discussion had to restart.

5. **Evidence of testing was incomplete.**
   The meeting did not show:
   - a full clean-build playthrough;
   - automated test results;
   - acceptance-checklist results;
   - performance measurements; or
   - verification on a clean Windows environment.

6. **Definition of Done evidence was not assembled before the review.**
   The repository's Definition of Done requires review/merge, tests, manual target-platform verification, acceptance-criteria verification, and documentation/changelog updates. The review did not confirm all of these for the current increment.

7. **Long-term ownership remained unresolved.**
   The team likes the project but did not decide whether and how it will continue after the course.

8. **The presentation flow was not rehearsed.**
   The recording ends while the team is still asking how the game should be presented.

## Root Causes

| Problem | Likely root cause |
|---|---|
| Late integration | Work was divided by feature and integrated after substantial parallel development instead of through frequent end-to-end merges. |
| Weak end-to-end demo | The sprint goal was expressed mainly as implementation tasks rather than a demonstrable player journey. |
| Missing completion condition | Product scope was organized around rooms and mechanics, not around the experience of a new player. |
| Incomplete test evidence | No single release owner was responsible for collecting build, test, and acceptance evidence before the review. |
| Communication interruptions | Audio was not checked before the formal review began, and there was no fallback presenter. |
| Future-development uncertainty | The team has not separated the “course-complete portfolio version” decision from the “continue toward release” decision. |

## What Changed Compared with the Previous Sprint

The previous sprint focused on expanding gameplay depth through factories, the Big Button, upgrades, and room concepts. This sprint shifted toward:

- implementing visual factory progression;
- turning test UI into an in-world management interface;
- connecting the mechanics to core systems;
- adding and positioning sound;
- correcting interaction behavior;
- integrating rooms;
- clarifying final acceptance and distribution requirements.

The next step is another shift: from feature integration to **release stabilization and player-experience validation**.

## Start, Stop, Continue

### Start

- Start every sprint/release goal with a playable user journey.
- Start integration at the beginning of the work period, not on review day.
- Start using a release checklist tied to the Definition of Done.
- Start recording the exact commit hash for every shared build.
- Start external playtesting before final polish.
- Start each remote review with a microphone and screen-share check.
- Start maintaining a short demo script and backup evidence.

### Stop

- Stop treating separately functioning scenes as a complete increment.
- Stop adding non-critical upgrades before the main experience is stable.
- Stop relying on verbal explanations when a build can provide evidence.
- Stop merging large integration changes without an immediate complete-path smoke test.
- Stop postponing the continuation/ownership decision.
- Stop using temporary content without clearly tracking what must be replaced for the final build.

### Continue

- Continue assigning clear feature ownership.
- Continue responding directly to stakeholder feedback.
- Continue using visual progression rather than only numeric feedback.
- Continue keeping core gameplay logic and interface interaction synchronized.
- Continue improving the in-world consistency of shop and factory interactions.
- Continue asking stakeholders to restate and confirm acceptance criteria.

## Definition of Done Gap Check

| Criterion | Current evidence | Status |
|---|---|---|
| Code reviewed and merged into `main` | Recent commits and merged pull requests are visible. | Mostly evidenced |
| No critical/high-severity bugs | Not demonstrated during the meeting. | Needs verification |
| Existing automated tests pass | Not shown in the review. | Needs evidence |
| New tests added where applicable | No review evidence for the new mechanics. | Needs review |
| Manual test on PC/Windows | Partial live demonstration, not a complete clean-build test. | Incomplete |
| Acceptance criteria verified | Final acceptance criteria were only clarified during the meeting. | Incomplete |
| Changelog updated | Current repository changelog must be checked against the final increment. | Needs verification |
| README/player documentation updated | itch.io controls and final player flow still need documentation. | Incomplete |

## Action Items

| ID | Improvement action | Owner | Deadline | Success measure |
|---|---|---|---|---|
| R-01 | Write the exact final player journey and completion condition. | Full team | Before further feature work | One-page flow accepted by the team |
| R-02 | Nominate one release owner and one independent release tester. | Team lead | Immediately | Names recorded in the issue/report |
| R-03 | Integrate all required rooms and systems in a release candidate. | Development team | Before final rehearsal | Complete playthrough without editor intervention |
| R-04 | Create a feature-freeze rule: only critical fixes after the release candidate. | Full team | At RC creation | No unapproved feature merges after freeze |
| R-05 | Add or update tests for quota reduction, resets, save state, and upgrade data where practical. | Feature owners | Before final tag | CI/test command passes |
| R-06 | Run a clean Windows export and smoke test. | Release owner + tester | Before itch.io upload | Build launches and completes the intended flow |
| R-07 | Conduct at least one new-player test without verbal guidance. | UX/playtest owner | Before final defense | Notes include confusion points and completion time |
| R-08 | Update README, changelog, controls, known issues, and build hash. | Documentation owner | Before submission | Documents match final tagged build |
| R-09 | Publish the itch.io page and verify download access. | Release owner | Before final presentation | Page and build accessible from another account/device |
| R-10 | Rehearse a timed demonstration and prepare backup media. | Presentation owner + full team | Before rehearsal/presentation | Demo fits timebox and survives build failure |
| R-11 | Decide the post-course project status and ownership. | Full team | Before pitch discussion | Written decision with repository/page owner |

## Experiments for the Final Iteration

### Experiment 1 — Unguided First Session

Give the build to a player who has not seen the game. Do not explain the controls or objective beyond what is present in the product.

Measure:

- time until the player understands the objective;
- time to first meaningful interaction in each room;
- whether the player can explain the quota and upgrade loop;
- whether the player reaches the ending;
- total session duration;
- points of confusion.

### Experiment 2 — Clean Build Verification

Export the game on one machine and run it on a different Windows environment or user profile.

Check:

- missing assets;
- incorrect resource paths;
- save-file behavior;
- audio;
- input focus;
- resolution/UI scaling;
- scene transitions;
- ending and restart behavior.

### Experiment 3 — Presentation Failure Drill

Rehearse once with the live build and once using backup video/screenshots. This ensures the team can still communicate the increment if the live build, audio, or screen sharing fails.

## Retrospective Outcome

The sprint succeeded in implementing important components, but the final iteration must be managed as a release, not as another feature sprint.

The single most important process improvement is:

> **Define and continuously test one complete player journey from launch to ending.**
