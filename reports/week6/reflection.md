# Reflection

## Context

This reflection covers the work and feedback reviewed on 12 July 2026. During the week, the team moved beyond isolated prototypes and worked on connecting the Big Button, factory-management UI, factory visual tiers, sound system, shop interaction, and multi-room environment.

The most important outcome of the review was a change in perspective: the final product will not be judged mainly by how many mechanics exist. It will be judged by whether those mechanics form one understandable and complete player experience.

## What We Learned About the Product

### Coherence Is a Feature

We previously treated room integration as the final technical step after the “real” features were complete. The review showed that integration is itself a product feature. A player does not experience our scripts, scenes, and individual mechanics separately. The player experiences transitions, pacing, feedback, and the relationship between systems.

A factory interface can function correctly, a Big Button can reduce a quota correctly, and a shop can open correctly, while the product still feels incomplete if the player does not understand why to use them or how they contribute to finishing a run.

### The First Session Needs an Explicit Contract

The stakeholders asked for a meaningful experience within approximately 10–15 minutes. This gives us a useful design constraint. We need to define:

- what the player sees and understands in the first minute;
- what the player is trying to achieve;
- how progress is communicated;
- how the rooms and upgrades support that objective;
- what the player sees when the objective is completed.

This is more valuable than adding another upgrade type without a clear place in the session.

### Visual Progression Was the Right Response

In the previous review, the team received feedback that number-only factory upgrades were not rewarding enough. The addition of wood, stone, copper, metal, gold, and glass factory tiers is a direct response to that feedback.

The implementation does not yet prove that the progression is satisfying, but it improves the game's ability to communicate change without requiring the player to read every value. The next step is validation: the model changes, statistics, animation, sound, and price progression must all agree.

### Distribution Is Part of Product Readiness

The itch.io requirement makes delivery visible. A build on a project page forces the team to answer practical questions that are easy to ignore during development:

- Does the game launch on a clean machine?
- Are the controls explained?
- Is the correct version uploaded?
- Can a new player understand what to do?
- Are known limitations documented?
- Is the page visually consistent with the game?

The page is not only a submission location; it is part of the portfolio and the first user-facing layer of the product.

## Assumptions Reviewed

### Assumption 1: Separate Working Systems Are Enough for a Successful Review

**Result: Rejected.**

The stakeholder explicitly said that it was difficult to assess the product from verbal descriptions. Separate rooms and systems must be integrated into a build that can be played from beginning to end.

### Assumption 2: More Functionality Is the Main Path to a Better Final Grade

**Result: Rejected or strongly revised.**

The confirmed priorities were a coherent beginning and end, a meaningful short experience, an itch.io page, and a reliable handover. New functionality is valuable only when it strengthens those priorities.

### Assumption 3: Visual Factory Tiers Improve Upgrade Feedback

**Result: Plausible but not yet validated.**

The implementation directly addresses earlier stakeholder feedback, but the meeting did not include enough hands-on playtesting to validate whether the tiers are clear and rewarding. This should be tested with players.

### Assumption 4: A Publisher Pitch Primarily Means a Chance of Immediate Funding

**Result: Reframed.**

The stakeholders described the pitch primarily as professional practice, external feedback, and portfolio development. A pitch-ready package is valuable even when it does not result in funding.

### Assumption 5: The Team Can Pause for Several Months and Resume Easily

**Result: High risk.**

The discussion highlighted that a four-month pause is likely to end active development because team members will have new academic commitments and personal plans. The team needs an explicit continuation or closure decision.

## Technical Learning

### 2D UI in a 3D Interaction Flow

The factory manager work demonstrates that a 2D overlay can be controlled from an in-world 3D interaction point. The technical challenge is not only opening the interface. The implementation must also handle:

- input focus;
- player movement while the UI is open;
- opening and closing conditions;
- navigation between factory slots;
- synchronization with game state;
- safe behavior when referenced nodes are missing;
- consistent behavior after scene transitions.

### Interaction Boundaries Matter

The shop interaction fix is a useful example of input-scope correctness. Opening the shop from any left-mouse click created behavior that was technically responsive but logically wrong. Restricting it to the player's raycast makes the interaction consistent with the 3D world.

This is a reminder to test not only the intended action, but also unrelated actions that must not trigger the feature.

### Asset Integration Has Product and Performance Costs

The final room-integration commit added multiple 3D factory tiers and scene changes. Visual variety improves feedback, but large assets also affect repository size, import time, build size, memory use, and loading behavior. The final build should be tested from a clean export rather than only from an already-imported editor project.

### Audio Needs System-Level Testing

Adding many sound files is not equivalent to completing audio integration. The final pass should verify:

- the right sound plays at the right event;
- no sound triggers repeatedly by accident;
- volume levels are balanced;
- the settings menu affects all relevant buses;
- missing resources do not break the game;
- sounds do not continue across incorrect scene states.

## Team and Process Learning

### What Helped

- Feature ownership was visible: UI, models, audio, and interaction mechanics progressed in parallel.
- The team responded to previous stakeholder feedback about visual progression.
- The meeting asked concrete acceptance and handover questions instead of only reporting status.
- Recent work was merged into the main branch before or during the review day.
- The team was open about uncertainty regarding future availability.

### What Limited the Review

- Integration was still being completed on the day of the review.
- The team relied heavily on verbal explanation before showing the build.
- Audio problems interrupted the opening and reduced clarity.
- There was no stable mapping between speaker numbers and participant names.
- The build shown was explicitly not final.
- The meeting ended before the final presentation question was answered.
- The review did not provide evidence of a full clean-build playthrough or automated test results.

## Response Plan

For the final week, we should:

1. Freeze the critical gameplay scope.
2. Define a written 10–15 minute flow with an explicit completion condition.
3. Integrate all required rooms and systems early.
4. Run a complete playthrough after every integration merge.
5. Use the Definition of Done as an actual release checklist:
   - merged and reviewed code;
   - no critical defects;
   - applicable tests passing;
   - manual Windows verification;
   - acceptance criteria checked;
   - changelog and user documentation updated.
6. Create the itch.io page before the last day so that export and upload problems are discovered early.
7. Conduct at least one external playtest with a new player.
8. Prepare a scripted demonstration and a backup video or screenshots.
9. Record the exact commit/tag used for the final build.
10. Make and document the team's continuation decision.

## Reflection on Future Development

The team appears interested in the project, but interest alone is not a sustainable plan. Continued development requires:

- a product owner or decision maker;
- a realistic scope;
- explicit ownership of the repository and itch.io page;
- a schedule compatible with the next semester;
- agreement on whether the target is a portfolio build, a pitch prototype, or a commercial release.

A responsible decision may be to finish a strong portfolio version and stop active development. It may also be to continue with a smaller subset of the team. What matters is that the decision is explicit rather than postponed until the project becomes impossible to resume.

## Main Reflection

The sprint produced real progress, but the review taught us that product completeness is not the sum of completed features. Completeness is the player's ability to enter the game, understand the objective, use the systems, experience progression, and reach a clear ending without developer explanation.

Our final work should therefore optimize for one reliable player journey, not for the largest possible feature list.
