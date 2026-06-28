
## Learning Points

- **Physical Interaction in Incremental Games:** Playing Berry Bury Berry revealed that physical movement and risk (e.g., carrying items to a pit) create significantly more engagement than passive clicking. This fundamentally changes our approach to the core mechanic.
- **Game Development Testing:** Learned that while traditional web testing doesn't directly apply to Godot, automated testing for code logic, security, and efficiency is still required and achievable (e.g., using GdUnit4).
- **Visual Differentiation:** Direct style imitation (like CloverPit's PS2 aesthetic) dilutes a project's identity. Unique visual accents and color palettes are more effective for standing out in the market.

## Validated Assumptions

- **Core Loop Technical Feasibility:** Validated. The full cycle (timer → quota → preparation → death → meta-progression) works seamlessly.
- **Original Audio:** The self-composed soundtrack was well-received, validating the decision to create original assets rather than using stock music.
- **Modifier System:** The technical implementation of click modifiers (+1, X2, autoclicker) functions correctly and integrates well with the GameManager.

## Friction and Gaps

- **Passive Core Mechanic:** The biggest design gap identified. The current clicking mechanic lacks physical challenge and risk, making the core loop feel like a standard casual clicker rather than a high-stakes survival test.
- **Visual Style Definition:** The team has not yet defined a unique visual identity, relying too heavily on the CloverPit reference.

## Planned Response

- **Mechanic Redesign (Sprint 3):** Prototype physical clicking mechanics (e.g., moving buttons, rhythm-based clicking) to increase cognitive load and risk.
- **Testing Research (Sprint 4):** Investigate GdUnit4 for Godot automated testing. Focus initial tests on critical code modules (GameManager, quota calculation) rather than gameplay mechanics.
- **Visual Exploration (Sprint 3):** Create mood boards and prototype unique color palettes to move away from the generic PS2 aesthetic.
