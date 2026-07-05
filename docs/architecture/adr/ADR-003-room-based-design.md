# ADR-003: Room-based SceneTree architecture

**Status:** Accepted  
**Date:** 2026-07-05

## Context

The game has distinct phases with different mechanics, UI, and rules:
- Preparation phase (shop, upgrade selection)
- Clicking phase (high-pressure button clicking under time limit)
- Death phase (failure state, restart option)
- Main menu and pause menu

Without clear separation, all phase logic would be in one scene with complex conditional branching.

## Decision

Each game phase is a separate Godot scene (room). SceneTree manages transitions between rooms.

Rooms:
- `MainMenu` — game entry point
- `GameRoom` — clicking phase with 3D environment
- `ShopRoom` — preparation phase with upgrade purchasing
- `DeathRoom` — failure state with restart option
- `PauseMenu` — game pause functionality

Shared state (score, tickets, click power) is managed by Autoload singletons accessible from any room.

## Consequences

Pros: High cohesion within each room. Can iterate on ShopRoom without affecting GameRoom. Easy to add new phases as new scenes. Clear separation of concerns.

Cons: Scene transitions have overhead. Shared state between rooms requires Autoload singletons. Room-to-room communication needs signals or global state.

## Related

- Quality requirements: QR-01 (Performance Efficiency), QR-02 (Reliability)
- Views: [Static View](../static-view/component-diagram.puml), [Deployment View](../deployment-view/deployment-diagram.puml)
