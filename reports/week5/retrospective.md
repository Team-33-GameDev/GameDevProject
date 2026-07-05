# Sprint 3 Retrospective

## What went well
1. **Architecture Discovery through Documentation:** Documenting the Godot SceneTree using PlantUML forced us to critically evaluate our node structure. This directly uncovered the `GameManager` singleton bottleneck and led to ADR-002 (Signal-based decoupling), significantly improving our maintainability.
2. **Core Loop Validation:** The customer confirmed during the MVP v2 review that our designed "tension-release" cycle is highly effective and creates the right atmospheric pressure for the game.
3. **Successful MVP v2 Delivery:** We successfully delivered and integrated the Autoclickers, Big Button, and Shop mechanics into a playable build, allowing the customer to test the main loop.

## What did not go well
1. **Incorrect Gameplay Assumptions:** We incorrectly assumed that the newly added Autoclicker and Big Button mechanics would be sufficient to create a complete and engaging gameplay loop. The customer rejected this, stating the game requires more engaging mechanics.
2. **Performance Oversight (FPS Drawdown):** We failed to anticipate the performance impact of high entity counts. Spawning 100+ autoclickers on the scene causes significant FPS drawdowns, freezes, and lags.
3. **Lack of Gameplay Depth:** The current gameplay loop lacks variety and depth. The customer explicitly demanded more engaging mechanics and better polish of current ones, which we did not prioritize enough in this Sprint.

## What changed compared to previous sprint
* **Focus Shift:** In Sprint 3, the focus shifted heavily to game design refinement (mechanic engagement) and visual identity, based directly on customer feedback.

## Action points
1. **Performance Optimization for Autoclickers:** Implement object pooling or a more efficient rendering/update strategy for the Autoclicker entities to resolve the FPS drawdown and lag when 100+ are present on the scene.
2. **Gameplay Brainstorming and Prototyping:** Dedicate time in the next Sprint to brainstorming and prototyping new, engaging mechanics to address the customer's feedback that the current loop lacks depth and variety.
