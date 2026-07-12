# Sprint Review Summary

## General Information

| Field | Value |
|---|---|
| Project | **Click to Live** |
| Team | Team 33 |
| Review date | 12 July 2026 |
| Review period | Work completed since the previous review, approximately 6–12 July 2026 |
| Format | Remote meeting with screen sharing |
| Recorded duration | Approximately 18 minutes 37 seconds |
| Product | A dystopian rogue-lite incremental clicker developed in Godot 4 |
| Repository | [https://github.com/Team-33-GameDev/GameDevProject](https://github.com/Team-33-GameDev/GameDevProject) |

> The source recording was automatically transcribed. Speaker identities were not reliably mapped, so this report uses roles and speaker numbers where necessary. Any public release of the full transcript should be preceded by a publication-consent check.

## Review Purpose

The team asked the stakeholders to clarify the final acceptance criteria and presented the work completed during the week. The review focused on whether the separate gameplay systems were becoming a coherent, presentable product increment rather than a collection of isolated prototypes.

## Sprint Objective

The effective objective of this sprint was to integrate the previously created mechanics into a coherent multi-room playable slice and to improve feedback, presentation, and usability before the final project defense.

The work reported or demonstrated during the review included:

- a Big Button mechanic that decreases the current quota;
- an in-world factory-management interface;
- selectable factory and click upgrades;
- visual factory progression through multiple model and material tiers;
- an expanded audio system with interaction sounds;
- shop interaction fixes;
- integration of the main room, factory room, and Big Button room;
- preparation for a distributable build and final presentation.

## Increment Reviewed

| Increment area | What was reported or demonstrated | Repository evidence |
|---|---|---|
| Big Button | The player jumps on the Big Button to reduce the current target quota by a percentage. The team discussed possibly making the trigger probabilistic rather than constant. | [`4c84bbb`](https://github.com/Team-33-GameDev/GameDevProject/commit/4c84bbb84d1c4f6afd030b54f75653b386e1805b), merged through [`eee7a6c`](https://github.com/Team-33-GameDev/GameDevProject/commit/eee7a6c34ebd1906ff4071d88f2bca7f65df98e9) |
| Factory manager | A 2D management interface can be opened and operated from the 3D environment. It supports navigation, factory selection, and upgrades. | [`17cfb8c`](https://github.com/Team-33-GameDev/GameDevProject/commit/17cfb8cd501bf1a3c0819e8e72e38eb4ca1b16b7), [`d9b54d5`](https://github.com/Team-33-GameDev/GameDevProject/commit/d9b54d59db2a3afe1338fa58fdfa6df31823cdae) |
| Visual progression | Factory models and textures represent wooden, stone, copper, metal/iron, gold, and glass progression tiers. | [`e85bc60`](https://github.com/Team-33-GameDev/GameDevProject/commit/e85bc60c9173e2de336f6fb9a92c9c5ab71f3088) |
| Audio | Sounds were added for factory interaction, footsteps, buttons, and other game effects. | [`3ca45e8`](https://github.com/Team-33-GameDev/GameDevProject/commit/3ca45e8d088232d0866843dca4642df5d0c16047) and related sound-position work |
| Shop interaction | The shop UI was changed so that it opens through the player's raycast interaction instead of responding to the left mouse button everywhere. | [`81e1268`](https://github.com/Team-33-GameDev/GameDevProject/commit/81e1268afaf63c7ac73e7a7b4dba9071d881ff04) |
| Room integration | The team was combining formerly separate rooms into one connected game-space and integrated the complete Game Room scene with factory models. | [`e85bc60`](https://github.com/Team-33-GameDev/GameDevProject/commit/e85bc60c9173e2de336f6fb9a92c9c5ab71f3088) |

## Demonstration Outcome

The team showed parts of the factory room and its interactive controls through screen sharing. The stakeholders noted that a verbal description was insufficient for full assessment and expected a playable build later that day. The review therefore confirmed progress, but did not constitute complete acceptance testing of the integrated build.

## Stakeholder Feedback

### Product and Gameplay

1. **Provide a coherent beginning and ending.**
   The game must communicate where the player's progression starts and where the first complete run ends.

2. **Deliver a meaningful 10–15 minute experience.**
   The final slice should be understandable and satisfying within the time available to a new player.

3. **Prioritize integration and polish over additional disconnected features.**
   The stakeholders wanted to evaluate the complete build, not only separate rooms and systems.

4. **The visual direction is improving.**
   The updated interface was described as more authentic, but it still needs to be evaluated inside the complete game.

### Distribution and Handover

1. Create an **itch.io page** and publish the game build there.
2. Provide the client/instructors with:
   - access to the Git repository; and
   - a runnable build.
3. For the later pitch, prepare:
   - a presentation; and
   - a project trailer.

### Project Continuation

The stakeholders asked whether the team intended to continue developing the game after the course. The team explained that the project is liked by the members, but the next academic semester will significantly limit available time. No final continuation decision was made during the review.

The pitch was reframed primarily as:

- experience presenting to a publisher;
- an opportunity to receive an external product assessment; and
- a stronger portfolio artifact,

rather than an expectation of immediate funding or release.

## Decisions and Acceptance Criteria

The meeting produced the following working acceptance criteria for the final presentation:

- [ ] The game provides a coherent beginning, progression, and ending.
- [ ] A first-time player can experience the intended core loop in approximately 10–15 minutes.
- [ ] The connected rooms and key systems work together in one build.
- [ ] The project has an accessible itch.io page.
- [ ] The team provides repository access and a runnable build.
- [ ] The team can explain the future status of the project: continued development, maintenance-only, or completion after the course.

For the later pitch:

- [ ] A presentation is prepared.
- [ ] A project trailer is prepared.
- [ ] The art and product presentation receive an additional polish pass.

## Approved Direction

The stakeholders did not reject the project concept. They explicitly described the concept positively and accepted the following direction:

- continue integrating the Big Button, factory, shop, and room systems;
- make the first play session self-contained;
- publish the project on itch.io;
- use the final week to produce a stable, coherent version;
- obtain additional playtest feedback when possible.

## Action Items

| Priority | Action | Suggested owner | Due |
|---|---|---|---|
| Critical | Freeze the final gameplay scope and define the exact start and end of a 10–15 minute session. | Full team | Before final build integration |
| Critical | Connect and verify the Main Room, Factory Room, and Big Button Room in one playable flow. | Full development team | Final presentation build |
| Critical | Produce and smoke-test a runnable Windows build. | Release owner + one independent tester | Before upload |
| Critical | Create and populate the itch.io page, including controls, screenshots, build, and known limitations. | Documentation/release owner | Before final presentation |
| High | Complete factory UI integration and verify every upgrade/navigation action from the 3D world. | Rustam + integration reviewer | Before build freeze |
| High | Verify that factory visual tiers change correctly and that model/animation transitions match gameplay state. | David + integration reviewer | Before build freeze |
| High | Verify Big Button quota reduction, including repeated-use and boundary cases. | Yaroslav + tester | Before build freeze |
| High | Validate audio triggers, volume balance, and missing-file behavior. | Bogdan + tester | Before build freeze |
| High | Confirm that shop UI opens only through intended player interaction. | Yaroslav + tester | Before build freeze |
| High | Conduct a short external playtest and record observations against the 10–15 minute experience goal. | Full team | Before final defense |
| Medium | Decide and document whether development will continue after the course. | Full team | Before pitch discussion |
| Medium | Prepare the presentation and trailer for the pitch. | Full team | Pitch deadline |

## Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Late integration | Features work separately but fail in the final scene. | Freeze scope, integrate early, and run a complete-path smoke test after every merge. |
| Insufficient evidence at review | Stakeholders cannot validate claims from a verbal report. | Always bring a known-good build and a short scripted demonstration. |
| Art and audio inconsistency | The product feels unfinished despite functioning mechanics. | Perform one focused polish pass after the build is feature-complete. |
| Schedule pressure | Final-week fixes may create regressions. | Use a release branch/tag, assign a build owner, and stop adding non-critical features. |
| Unverified publication consent | A public transcript may expose meeting participants without explicit approval. | Keep speaker IDs, remove personal information, and confirm consent before committing the transcript publicly. |
| Documentation drift | Reports, changelog, tests, and the current build may disagree. | Update documentation from the final tagged commit and record the exact build hash. |

## Review Result

**Result: conditionally accepted as progress, not yet accepted as a final integrated increment.**

The team demonstrated meaningful implementation progress, and the repository contains corresponding changes. The remaining objective is not to add a large amount of new functionality, but to turn the existing systems into a stable, coherent, distributable experience that can be completed and understood by a new player.
