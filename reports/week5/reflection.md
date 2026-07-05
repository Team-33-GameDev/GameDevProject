# Week 5 Reflection

## Learning points
* **Architecture Documentation in Godot:** Documenting our Godot SceneTree using PlantUML forced us to critically evaluate our node structure. We realized that while our modular room-based design is highly cohesive, the `GameManager` singleton was becoming a bottleneck for state changes. This realization directly led to ADR-002 (Signal-based decoupling), which will significantly improve our maintainability.
* **Customer Validation of Core Loops:** Watching the customer play MVP v2 was eye-opening. We learned that the "tension-release" cycle we designed is highly effective, but the gameplay still needs more interesting mechanics.

## Validated assumptions
* **Assumption:** We assumed that recently added mechanics of autoclickers and Big Button would be enough to create engaging and complete gameplay loop. 
  * **Validation:** Rejected. The customer stated the game requires more engaging mechanics to be interesting. 

## Friction and gaps
* **FPS Drawdown:** We discovered that at least 100 autoclickers on scene cause freezes and lags.
* **Gameplay Loop:** The customer demands more engaging gameplay, which includes creation of new mechanics and their implementation while also polishing current mechanics.

## Planned response
* **Bug Fix for FPS:** We will find a way to optimize autoclickers to avoid lags.
* **Brainstorming:** We will find new ideas and mechanics for our game to satisfy customer demands.
