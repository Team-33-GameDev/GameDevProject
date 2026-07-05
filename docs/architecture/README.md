

## Table of Contents

- [Static View — Component Diagram](#static-view--component-diagram)
- [Dynamic View — Core Gameplay Sequence](#dynamic-view--core-gameplay-sequence)
- [Deployment View](#deployment-view)
- [Architecture Decision Records](#architecture-decision-records)

---

## Static View — Component Diagram

**Source:** [`static-view/component-diagram.puml`](./static-view/component-diagram.puml)  
**Rendered:** [`static-view/component-diagram.svg`](./static-view/component-diagram.svg)

### What the diagram shows

The component diagram shows the main structural elements of MVP v2:

**Autoload Singletons** (global state management):
- `GameManager` — score, tickets, click power (base, additive bonuses, multiplicative bonuses)
- `QuotaManager` — state machine (IDLE/RUNNING/GAME_OVER), timer, quota evaluation
- `Events` — game reset and global events

**Scenes (Room-based architecture)**:
- `MainMenu` — game entry point
- `GameRoom` — clicking phase with 3D environment
- `ShopRoom` — preparation phase with upgrade purchasing
- `DeathRoom` — failure state with restart option
- `PauseMenu` — game pause functionality

**Player Interaction**:
- `Player` (CharacterBody3D) — FPS controller with WASD + mouse look, RayCast3D
- `ClickButton` (Node3D) — clickable object with AnimationPlayer

**Shop System**:
- `ShopSystem` — manages shop UI and available upgrades
- `ShopSlot` — individual upgrade slots
- `ClickFactory` — creates click action decorators

**Click Actions**:
- `IClickAction` interface
- `ClickBase`, `ClickDecorator`
- `AddClickBonus` (+N), `MultiplyClickBonus` (xN)

**UI Components**:
- `TVDisplay` (Main Display) — shows score, timer, quota
- Autoclicker system components

### Coupling and cohesion

The architecture uses a **room-based design** where each game phase is encapsulated in its own scene. This provides:

- **High cohesion** — each room contains its own mechanics, UI, and visuals
- **Low coupling** — rooms communicate through Autoload singletons and signals
- **Independent iteration** — ShopRoom can be modified without affecting GameRoom

**Related ADRs:**
- [ADR-001: Signal-based decoupling](./adr/ADR-001-signal-decoupling.md)
- [ADR-002: UI-Game state separation](./adr/ADR-002-ui-gamestate-decoupling.md)

---

## Dynamic View — Core Gameplay Sequence

**Source:** [`dynamic-view/core-gameplay-sequence.puml`](./dynamic-view/core-gameplay-sequence.puml)  
**Rendered:** [`dynamic-view/core-gameplay-sequence.svg`](./dynamic-view/core-gameplay-sequence.svg)

### What the diagram shows

The sequence diagram captures the core gameplay loop implemented in MVP v2:

1. **Initial State (IDLE)** — QuotaManager waits for first click
2. **Player Clicks** — RayCast3D detects ClickButton, GameManager adds score
3. **QuotaManager Starts Run** — transitions to RUNNING, loads quota [30s, 300], starts timer
4. **Clicking Phase** — timer counts down, player clicks to reach quota
5. **Evaluation** — when timer expires:
   - **Success** → preparation phase, access to ShopRoom
   - **Failure** → DeathRoom, 0.5s delay, press R to restart

The diagram shows the tension-release cycle that forms the core of the game experience.

**Related ADRs:**
- [ADR-001: Signal-based decoupling](./adr/ADR-001-signal-decoupling.md)
- [ADR-003: Room-based architecture](./adr/ADR-003-room-based-design.md)

---

## Deployment View

**Source:** [`deployment-view/deployment-diagram.puml`](./deployment-view/deployment-diagram.puml)  
**Rendered:** [`deployment-view/deployment-diagram.svg`](./deployment-view/deployment-diagram.svg)

### What the diagram shows

The deployment view shows the development and distribution pipeline:

**Development:**
- Godot Editor 4.6+ (Forward Plus renderer)
- GDScript source code
- Blender assets for 3D models
- Git version control

**CI/CD:**
- GitHub Actions pipeline
- Headless Godot export for automated builds
- GdUnit4 automated tests (45% coverage for critical modules)
- GDScript linting
- Build time threshold: 3 minutes

**Player Environment (Windows):**
- Click to Live executable (D3D12 rendering driver)
- Godot runtime (embedded)
- Jolt Physics engine
- Local save data in `user://`

**Related ADRs:**
- [ADR-004: Local-only deployment](./adr/ADR-004-local-deployment.md)

---

## Architecture Decision Records

Architecture decisions are recorded in the [`adr/`](./adr/) directory.

**Current ADRs:**

| ID | Title | Related Quality Requirements |
|---|---|---|
| [ADR-001](./adr/ADR-001-signal-decoupling.md) | Signal-based decoupling via Autoload singletons | QR-01, QR-02, QR-03 |
| [ADR-002](./adr/ADR-002-ui-gamestate-decoupling.md) | UI-Game state separation | QR-03, Maintainability |
| [ADR-003](./adr/ADR-003-room-based-design.md) | Room-based SceneTree architecture | QR-01, QR-02 |
| [ADR-004](./adr/ADR-004-local-deployment.md) | Local-only deployment model | QR-01, QR-02 |

Each ADR references the quality requirements it addresses (see [docs/quality-requirements.md](../quality-requirements.md)).

---

## Links

- [Quality Requirements](../quality-requirements.md)
- [Testing Strategy](../testing.md)
- [Definition of Done](../definition-of-done.md)
- [Roadmap](../roadmap.md)
- [Development Process](../development-process.md)
