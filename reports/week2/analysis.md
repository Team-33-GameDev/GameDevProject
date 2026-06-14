# Analysis

## Learning points
- **Writing user stories & prioritization**: We learned the importance of strict scoping. Initially including a Custom Level Editor (US-12) was recognized as technically unfeasible and a distraction from the core loop, leading to its removal. Prioritizing "Must Have" stories (US-01 to US-04) allowed us to focus MVP v0 on proving the core stealth mechanics without overextending the team.
- **Prototyping & interface design**: The Figma prototype and MVP v0 deployment highlighted that relying on developer console outputs for game state (sheep counter, game over) creates a broken experience for players. A proper in-game UI is critical for usability, and visual feedback (like the farmer's vision cone) must be clearly distinguishable to ensure the game is playable by non-developers.
- **MVP v0 deployment**: Building and deploying the MVP v0 to the web made it clear that our current scope is only viable as a web game. Attempting to target Steam, Web, and Mobile simultaneously was identified as overambitious and unfeasible given our resources and the game's current depth.
- **Customer validation**: The customer review was a major learning moment regarding market viability. We learned that we skipped crucial market validation and jumped straight into implementation, resulting in a product that feels like a "game jam project" rather than a market-ready game. We also learned that our proposed target audience (7-16 and 50+) was fundamentally mismatched with the stealth genre's actual player base.

## Validated assumptions
- **Assumption**: Targeting Steam, Web, and Mobile simultaneously was a viable platform strategy. 
  - **Rejected** during the customer review. Mobile is oversaturated, and Steam requires 2+ hours of gameplay with clear analogues. Web is the only viable platform for our current scope.
- **Assumption**: The target audience of 7-16 and 50+ would engage with this stealth game. 
  - **Rejected** during the customer review. The 50+ demographic does not typically play this genre, and the younger demographic expects different core loops.
- **Assumption**: Godot Engine's `AStar2D` would successfully support the farmer's pathfinding around fence obstacles. 
  - **Confirmed** during MVP v0 technical work. The AI successfully navigates around fences to chase the player, validating our technical choice for enemy behavior.
- **Assumption**: A custom level editor (US-12) was necessary for long-term player retention. 
  - **Rejected** during prioritization. It was technically unfeasible within the course timeframe and detracted from polishing the core gameplay loop.
- **Assumption**: Console output is sufficient for game state feedback in MVP v0. 
  - **Rejected** during MVP v0 testing. The lack of an in-game UI makes the game unplayable for non-developers, confirming that UI must be a core part of the build.

## Needs clarification
- **New Concept Direction**: Since the customer approved a complete pivot for Assignment 2, we need to clarify the new game concept, target audience, and specific 2026 game reference.
- **MVP v1 Scope for Pivot**: The current User Stories (US-01 to US-11) will be completely rewritten. We need to define the new "Must Have" features for the pivoted concept.
- **Technical Risks with New Concept**: Depending on the new pitch (e.g., "Horror chess" or "Co-op snipers roguelike"), there are unknown technical risks regarding multiplayer implementation or complex AI in Godot that need to be assessed.
- **Bug Fixes in MVP v0**: The MVP v0 report mentions "many bags [bugs] to be fixed". We need to clarify the severity of these bugs and determine if they need to be addressed before the pivot or if they can be abandoned with the current codebase.
- **UI/UX Requirements**: We need to clarify the exact UI elements and feedback mechanisms required for the new pivoted game to avoid the usability issues faced in MVP v0.

## Planned response
- **Complete Project Pivot**: As agreed with the customer, the team will completely pivot and rethink the project based on market requirements for Assignment 2. The current MVP scope and User Stories ([user-stories.md](./user-stories.md)) will be completely rewritten.
- **Select a Clear Reference & Pitch**: The team will select ONE clear, actual 2026 game reference and brainstorm a new concept tailored to a specific audience, summarized in a single pitch (e.g., "Horror chess" or "Co-op snipers roguelike").
- **Market Validation First**: The team will conduct proper market validation before jumping into implementation to ensure the new concept is a market-ready product rather than a game jam project.
- **Prioritize In-Game UI**: For MVP v1 and future builds, in-game UI (health, objectives, game over screens) will be prioritized as a "Must Have" user story instead of relying on console output, addressing the usability issues found in the MVP v0 deployment ([mvp-v0-report.md](./mvp-v0-report.md)).
- **Reference Artifacts**:
  - User Stories: [user-stories.md](./user-stories.md)
  - MVP v0 Report: [mvp-v0-report.md](./mvp-v0-report.md)
  - Customer Meeting Notes: [customer-meeting-notes.md](./customer-meeting-notes.md)
  - Figma Prototype: [Figma Link](https://www.figma.com/proto/phoGzKzT58rOPqz3X3LCXc/f6eeddfe-a8ed-47e2-aa29-4cd67778ef74_image?node-id=1-17&p=f&t=cyJag4YOih6WFJXN-0&scaling=min-zoom&content-scaling=fixed&page-id=0%3A1&starting-point-node-id=1%3A17)
