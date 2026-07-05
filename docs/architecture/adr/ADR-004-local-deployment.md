# ADR-004: Local-only deployment model

**Status:** Accepted  
**Date:** 2026-07-05

## Context

The game is single-player with no multiplayer or social features. Saves are local (progress, upgrades, tickets). Platform is Windows with plans for Steam distribution.

We need a solution without server infrastructure, supporting offline play and simple deployment.

## Decision

Local deployment with Godot's built-in save system:

- Export to Windows executable (D3D12 renderer, Jolt Physics)
- Saves in `user://` (Godot resolves path for each OS automatically)
- No backends, cloud saves, or analytics

CI pipeline uses headless Godot export for automated builds with 3-minute threshold.

In the future, Steam Cloud can be added via Steamworks SDK — save format won't change, only storage location.

## Consequences

Pros: Zero infrastructure costs, works offline, single file for deployment, players don't lose data without internet.

Cons: No cloud saves (progress lost when switching machines), players can edit saves manually, no analytics for balancing.

## Related

- Quality requirements: QR-01 (Performance Efficiency), QR-02 (Reliability)
- Views: [Deployment View](../deployment-view/deployment-diagram.puml)
