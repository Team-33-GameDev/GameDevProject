# MVP v0 Report: "Evil Wolf" Game

## Purpose and Description
The MVP v0 is the foundational technical prototype for the "Evil Wolf" 2D grid-based stealth game, built using the Godot Engine. 

The core purpose of this version is to establish the basic gameplay loop and technical foundation. It features a playable wolf character that moves on a tile-based grid, collects sheep, and delivers them to a wolf den. It also includes a patrolling farmer enemy with basic pathfinding AI (AStar2D) that chases the wolf when detected and is blocked by fence obstacles. 

This version proves that the core mechanics (grid movement, collision, basic AI, and win/lose conditions) are functional.

## Public Video Demonstration
https://youtube.com/shorts/3Sfu9zg7hvk?feature=share

## Relationship to Prototype and MVP v1 Stories
This MVP v0 serves as the technical foundation for the proposed MVP v1. It directly implements the core mechanics required for the following user stories:
- US-01: As a Player, I want to move my wolf character one tile at a time on a 16x16 grid, so that I can tactically position myself and plan my routes.
- US-02: As a Player, I want to see the Farmer enemy moving in predictable patrol patterns with a visible vision cone, so that I can learn his route and avoid being caught.
- US-03: As a Player, I want to capture sheep by moving onto their tile, so that I can complete the level objective.

While the prototype focuses on the visual design and user experience of these flows, MVP v0 proves that the underlying logic and AI pathfinding work in the actual game engine.

## Current Limitations, Placeholders, and Mocks
As a foundational version, MVP v0 has several limitations:
- **User Interface (UI):** There is no in-game UI. The sheep counter and game over messages are currently printed only to the developer console.
- **AI Behavior:** The farmer's AI uses a simple "chase or patrol" logic. It does not yet have advanced behaviors like searching the last known location of the wolf.
- **Game Flow:** There is no main menu or pause screen. The game restarts automatically 2 seconds after a win or loss.
- **Bags** There are many bags to be fixed until now

## Local Setup Instructions
Follow this link, download and lauch the game for your system
https://github.com/Team-33-GameDev/mvp-build

## Repeatable Smoke-Check Scenario

### Access Instructions
1. Open a modern web browser (Chrome, Firefox, or Edge).
2. Navigate to the Deployment URL: [INSERT YOUR DEPLOYMENT URL HERE]
3. Wait for the game to load in the browser window.

### Steps
1. **Movement:** Press the arrow keys to move the wolf one tile at a time.
2. **Collecting:** Move the wolf onto a tile with a sheep. The sheep should disappear, and the wolf's sprite should change color to indicate it is carrying the sheep. Movement speed should decrease slightly.
3. **Delivering:** Move the wolf to the blue "Wolf Den" marker. The wolf should return to its normal color and speed.
4. **Obstacles:** Try to move through a fence. The wolf should be blocked and unable to pass.
5. **Enemy AI:** Move the wolf within 6 tiles of the farmer. The farmer should stop patrolling and start moving toward the wolf, navigating around fences.
6. **Lose Condition:** Let the farmer catch the wolf (move onto the same tile or an adjacent tile without a fence). The game should print a "Game Over" message in the console and restart.
7. **Win Condition:** Collect all sheep and deliver them to the den. The game should print a "Victory" message in the console and restart.

### Expected Results
- The wolf moves strictly on the grid.
- Collisions with fences work correctly.
- The farmer's AI successfully navigates around fences to chase the player.
- Music and sounds have been added.
- The win and lose conditions trigger correctly and restart the level.
