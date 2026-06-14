# User Stories and Product Scope

## Relevant User Roles / Personas
Plaryer 

## Initial proposed MVP v1 scope
The initial MVP v1 focuses on the core "Reverse Pac-Man" movement, basic objective collection, and one enemy type to establish the core loop.
Selected IDs: **US-01, US-02, US-03, US-04**

---

## US-01: Grid-Based Movement
**Requirement status:** Active  
**MoSCoW priority:** Must Have  
**Implementation workflow:** To Do  

As a Player,
I want to move my wolf character one tile at a time on a 16x16 grid,
so that I can tactically position myself and plan my routes.

### Notes and constraints
- Movement is restricted to 4 directions (Up, Down, Left, Right).
- The input must feel responsive but distinctly turn-based/grid-based.

## US-02: Farmer Enemy Patrol
**Requirement status:** Active   
**MoSCoW priority:** Must Have    
**Implementation workflow:** To Do  

As a Player,
I want to see the Farmer enemy moving in predictable patrol patterns with a visible vision cone,
so that I can learn his route and avoid being caught.

### Notes and constraints
- Vision cone will be highlighted in bright yellow for high contrast.
- If the wolf enters the cone, the player loses 1 HP.

## US-03: Sheep Collection
**Requirement status:** Active  
**MoSCoW priority:** Must Have  
**Implementation workflow:** To Do  

As a Player,
I want to capture sheep by moving onto their tile,
so that I can complete the level objective.

### Notes and constraints
- Carrying a sheep reduces movement speed.
- The player must deliver the sheep to the starting zone/lair to score.

## US-04: Scent Mechanic (Radar)
**Requirement status:** Active  
**MoSCoW priority:** Must Have  
**Implementation workflow:** To Do  

As a Player,
I want to use my "Scent" ability to see colored icons for hidden points of interest in the dark,
so that I can navigate toward objectives without knowing exactly what they are until I get close.

### Notes and constraints
- UI requirement: Small green circles.
- Scent does not differentiate between standard sheep, traps, or mimic dogs until the player is adjacent.

## US-05: Health and Game Over System
**Requirement status:** Active  
**MoSCoW priority:** Must Have  
**Implementation workflow:** To Do  

As a Player,
I want to have 3 Health Points (Hearts) and lose one when caught by an enemy or trap,
so that I have a margin for error before failing the level.

### Notes and constraints
- Reaching 0 HP triggers a "Game Over" screen and resets the level.

## US-06: Bush Hiding Spot
**Requirement status:** Active  
**MoSCoW priority:** Should Have  
**Implementation workflow:** To Do  

As a Player,
I want to hide inside bushes to become invisible to passing enemies,
so that I can safely wait for patrol routes to clear.

### Notes and constraints
- Bushes only hide the player if they entered *before* the enemy's vision cone touched them.

## US-07: Guard Dogs Response
**Requirement status:** Active
**MoSCoW priority:** Should Have
**Implementation workflow:** To Do  

As a Player,
I want dogs to leave their kennels and chase me if I trigger an alarm or make noise,
so that the game creates moments of high tension and forces me to adapt my plan.

### Notes and constraints
- Dogs move faster than the Farmer but follow a direct pathfinding logic rather than a patrol route.

## US-08: Sheepskin Camouflage
**Requirement status:** Active  
**MoSCoW priority:** Should Have  
**Implementation workflow:** To Do  

As a Player,
I want to earn and use a Sheepskin item after delivering a sheep,
so that I can camouflage myself in plain sight for a short duration.

### Notes and constraints
- Single-use consumable. 
- While active, the Farmer will ignore the player inside his vision cone.

## US-09: Black Sheep 
**Requirement status:** Active  
**MoSCoW priority:** Could Have  
**Implementation workflow:** To Do  
As a Player,
I want to encounter Black Sheep that grant bonus points, but scream when picked up,
so that I can choose whether to risk alerting nearby dogs for a higher score.

### Notes and constraints
- The scream acts as an area-of-effect alarm.

## US-10: Bear Traps
**Requirement status:** Active  
**MoSCoW priority:** Could Have  
**Implementation workflow:** To Do  
As a Player,
I want to navigate around hidden bear traps that slow my movement,
so that the environment poses a passive threat alongside active enemies.

### Notes and constraints
- Traps appear as green scent blips from afar, identical to sheep.

## US-11: Bell Traps
**Requirement status:** Active  
**MoSCoW priority:** Could Have  
**Implementation workflow:** To Do  
As a Player,
I want to navigate around hidden bell traps that lure the dog,
so that the environment poses a passive threat alongside active enemies.

### Notes and constraints
- Traps appear as green scent blips from afar, identical to sheep.

## US-12: Custom Level Editor
**Requirement status:** Removed  
**Previous MoSCoW priority:** Won't Have  
**Implementation workflow:** To Do  

As a Player,
I want to create my own farm layouts and place enemies,
so that I can share custom levels with friends.

**Reason:** This feature was initially brainstormed but was removed from the scope. The Fact Sheet explicitly states "Level Editor: Not planned." It is technically unfeasible within the course timeframe and detracts from the core gameplay loop polish.