# Sprint Review Notes

## Meeting Metadata

- **Project:** Click to Live
- **Team:** Team 33
- **Date:** 12 July 2026
- **Format:** Remote review with screen sharing
- **Recording:** Yes; source transcript duration is approximately 18:37
- **Repository:** [https://github.com/Team-33-GameDev/GameDevProject](https://github.com/Team-33-GameDev/GameDevProject)
- **Source quality:** The recording was automatically transcribed. Speaker attribution and several short phrases are uncertain.
- **Privacy:** Speaker numbers are retained. Confirm permission before publishing the full transcript in a public repository.

## Participants

The exact mapping between speaker numbers and names was not confirmed.

- **Team roster in the repository:** Bogdan, Rustam, Varvara, Yaroslav, and David.
- **Meeting roles represented:** development team, client/customer representative, and course/instructor representatives.
- **Transcript labels:** Speakers 0–5.

## Agenda

1. Clarify the final project acceptance criteria.
2. Review work completed during the week.
3. Demonstrate the current factory-room implementation.
4. Discuss the expected final build, itch.io publication, and product handover.
5. Discuss the optional publisher pitch and whether the team plans to continue the project.

## Chronological Notes

### 00:00–00:55 — Opening and Review Goal

- Recording starts.
- The team asks what must be present in the final version and which criteria are critical.
- The discussion shifts first to the work completed during the week.
- There are early audio-quality problems.

### 00:56–02:38 — Big Button and Upgrade UI

- The team reports implementation of a Big Button mechanic.
- Jumping on the button reduces the current quota by a percentage.
- A possible refinement is discussed: make the effect probabilistic instead of triggering in a fixed way.
- Rustam is credited in the meeting with completing the upgrade-selection UI.
- The UI is a 2D interface operated from the 3D game world.
- The same interface is intended to support:
  - factory upgrades;
  - click upgrades; and
  - Big Button upgrades, if such upgrades are retained.

### 02:39–04:37 — Audio and Factory Visual Progression

- The sound system was expanded.
- Current sound categories include:
  - factory clicks/interactions;
  - footsteps;
  - regular button clicks; and
  - other game effects.
- Stock sounds are being used as temporary assets and can be replaced later.
- David is credited in the meeting with completing factory models and textures.
- Factory progression is represented visually using different tiers:
  - wood;
  - stone;
  - copper;
  - iron/metal;
  - gold;
  - glass.
- Work had started on synchronizing visual models and animations with the factory system.
- Factory UI integration with the existing factory logic was close to completion.

### 04:38–06:29 — Partial Demonstration and Integration Status

- Audio quality is checked again.
- A stakeholder says that the current explanation is difficult to assess without the build.
- The team begins screen sharing.
- The team explains that the rooms were still separate and needed to be joined into a connected game space.
- The factory machine and interactive buttons are shown.
- The team says the build is still being polished and is not final.

### 06:30–08:32 — Final Requirements and Pitch Timing

- The team asks what is required to receive the highest possible grade.
- The stakeholders first ask whether the team wants to continue developing the game after the course.
- The team asks:
  1. when the pitch will take place; and
  2. how continuation is expected to fit around a very demanding next semester.
- A pitch date around the 26th–27th is mentioned, with the possibility of a later date.
- The pitch requires:
  - a presentation; and
  - a project trailer.
- The team notes that continuing development for another four months would be difficult because of academic workload.

### 08:33–11:49 — Purpose of Continued Development

- A stakeholder says that a project not continued now is unlikely to be resumed several months later.
- The team clarifies that the members like the project; the constraint is time.
- The pitch is described primarily as a learning and portfolio opportunity.
- The team should not assume that a pitch immediately leads to funding or a Steam release.
- A stronger art presentation would be needed for a serious publisher submission.
- The team is asked to discuss internally whether it wants to continue.

### 11:50–14:31 — Required Final Player Experience

- The stakeholders request a coherent beginning and ending.
- A cinematic introduction is not required.
- The player must understand:
  - how progression starts;
  - where it ends; and
  - what completion means.
- One example is a fixed sequence of four quotas followed by a clear end message.
- The complete intended experience should fit within approximately 10–15 minutes.
- The updated interface is considered more authentic, but should be evaluated in the actual build.
- The project must have an itch.io page.
- The team summarizes the key criteria as:
  1. coherent beginning and end;
  2. a meaningful player experience; and
  3. an itch.io page.

### 14:32–16:29 — itch.io and Course Learning Goals

- The team agrees that an itch.io page is useful as a persistent portfolio artifact.
- Uploading should be straightforward because the project does not rely on external add-ons.
- The stakeholders distinguish the mandatory final project work from the optional longer-term pitch work.
- The course objective is described as learning collaborative product development, not only game-specific implementation.
- The team is asked to provide a decision about future development.
- The concept is described positively.
- The final version remains the team's focus for the next week.

### 16:30–17:32 — Product Handover

- The team asks how the product should be handed over to the client.
- The answer is:
  - Git repository access; and
  - a runnable build.
- The team restates the final delivery package:
  - coherent gameplay experience;
  - itch.io page;
  - repository access;
  - build.
- The stakeholders confirm this understanding.

### 17:33–18:37 — Immediate Next Steps and External Playtest

- The team plans to combine its work into a coherent version by the end of the day.
- A possible demonstration at 19:00 at a venue transcribed as “Shokes” is discussed.
- Other students could play the game and provide feedback.
- The recording ends while the team is asking how best to present the game.

## Demonstrated or Reported Increment

- Big Button quota-decrease mechanic.
- Factory manager overlay and navigation.
- In-world 2D upgrade interface.
- Factory visual tiers.
- Factory-room controls.
- Expanded sound system.
- Work toward connecting all rooms.
- Shop interaction correction.

## Decision Log

| ID | Decision | Status | Evidence |
|---|---|---|---|
| D-01 | The final game must have a coherent beginning and ending. | Confirmed | 12:04–13:53 |
| D-02 | The intended first session should provide a meaningful experience in roughly 10–15 minutes. | Confirmed | 12:49–12:53 |
| D-03 | The project must have an itch.io page. | Confirmed | 13:16–14:47 |
| D-04 | Product handover consists of repository access plus a runnable build. | Confirmed | 16:30–17:26 |
| D-05 | The pitch requires a presentation and trailer. | Confirmed | 07:55–08:05 |
| D-06 | The team must decide whether it wants to continue the project after the course. | Open team decision | 06:56–16:20 |
| D-07 | The remaining week should prioritize a final coherent version. | Confirmed | 15:49–17:33 |
| D-08 | External playtesting before the final defense is desirable. | Proposed | 18:07–18:35 |

## Feedback Register

| Category | Feedback | Required response |
|---|---|---|
| Product completeness | Separate mechanics are not enough; stakeholders need to evaluate one coherent build. | Integrate rooms and systems, then test the complete path. |
| Onboarding and ending | The player needs to understand how a run starts and ends. | Add clear start-state guidance, progress communication, and completion feedback. |
| Session length | The core experience should fit into 10–15 minutes. | Tune quota count, timing, prices, and progression speed. |
| Presentation | A verbal report is difficult to assess. | Prepare a scripted live demo and a known-good build. |
| Distribution | The project needs an itch.io page. | Create page, upload build, and document controls/requirements. |
| Handover | Git access and a build are sufficient. | Record exact commit/build version and share access. |
| Pitch readiness | Art requires additional polish for a publisher-facing pitch. | Prepare a separate polish backlog, trailer, and presentation. |
| Long-term ownership | Waiting four months may effectively end development. | Make an explicit team decision and document ownership. |

## Action Register

| ID | Action | Owner | Priority | Verification |
|---|---|---|---|---|
| A-01 | Define the exact 10–15 minute final flow, including start and completion condition. | Full team | Critical | Written flow plus successful playthrough |
| A-02 | Integrate all rooms and key systems into one build. | Development team | Critical | Player can traverse and use all required systems |
| A-03 | Test Big Button quota reduction and its limits. | Feature owner + independent tester | High | Test notes for normal, repeated, minimum-quota, and reset cases |
| A-04 | Test every factory manager screen and upgrade path. | Feature owner + independent tester | High | Upgrade/navigation checklist passes |
| A-05 | Verify every factory model tier and animation transition. | Art/integration owner | High | Visual progression checklist passes |
| A-06 | Verify audio triggers and volume balance. | Audio owner | High | Audio checklist passes with no missing resources |
| A-07 | Verify intended shop interaction through raycast. | Feature owner + tester | High | UI does not open from unrelated clicks |
| A-08 | Build and upload the project to itch.io. | Release owner | Critical | Public/private page opens and build launches |
| A-09 | Provide repository access and exact build artifact. | Team lead/release owner | Critical | Client/instructors can access both |
| A-10 | Run an external playtest and record observations. | Full team | High | At least one test session with notes |
| A-11 | Decide whether development continues after the course. | Full team | Medium | Decision recorded in project documentation |
| A-12 | Prepare presentation and trailer for the pitch. | Full team | Medium | Review-ready slide deck and video |

## Final Delivery Checklist

### Gameplay

- [ ] One connected playable flow.
- [ ] Clear start state.
- [ ] Understandable objective and quota progression.
- [ ] Clear completion/end state.
- [ ] Intended duration approximately 10–15 minutes.
- [ ] No critical blockers during a full playthrough.

### Product Distribution

- [ ] itch.io page exists.
- [ ] Correct build is uploaded.
- [ ] Controls and system requirements are documented.
- [ ] Screenshots or short gameplay media are present.
- [ ] Known issues are disclosed.

### Handover

- [ ] Repository access is confirmed.
- [ ] Exact commit/tag is recorded.
- [ ] Runnable build is provided.
- [ ] Basic launch instructions are included.

### Presentation

- [ ] Known-good demo build.
- [ ] Scripted presentation order.
- [ ] Backup recording/screenshots.
- [ ] Pitch presentation and trailer prepared when required.

## Open Questions

1. Has every participant approved public publication of the transcript?
2. What exact commit or tag will identify the final submitted build?
3. Who is the release owner for itch.io and build handover?
4. What is the exact completion condition in the final 10–15 minute experience?
5. Will the team continue development after the course, and under whose ownership?
6. What final date and format apply to the publisher pitch?
