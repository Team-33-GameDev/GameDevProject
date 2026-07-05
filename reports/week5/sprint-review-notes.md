# Sprint Review Notes

## Scope Reviewed

### 1. Multi-Room Game Concept
- Game structure based on separate rooms, each serving a specific gameplay function.
- Two primary rooms developed this sprint: **Factory Room** and **Big Button Room**.

### 2. Factory Room
- Features animated hands emerging from walls to press buttons.
- Each hand includes a display showing generation output and active/broken status.
- Hands can break and require player attention.
- Proposed distraction mechanic: neighboring hands occasionally play "rock-paper-scissors."
- Players must physically travel to this room to monitor and maintain hands (similar to idle/incremental game companions).

### 3. Big Button Room
- Separate room with a large central button.
- Players jump on the button to reduce their quota by a percentage.
- Designed as an alternative to clicking when players cannot meet quota through clicks alone.
- Future automation planned: a large hand descending from the ceiling.
- **Decision:** Quota reduction chosen over click generation as it provides more interesting gameplay.

### 4. Progression & Cycle System
- Discussion on implementing cycle-based progression rather than full resets.
- When a character dies, a new employee takes over, representing a new cycle.
- Roguelike elements to be added for meaningful changes between cycles.
- Narrative framing: the system constantly loses employees, and the player must keep operations running.

### 5. Death & AI Boss Mechanics
- AI boss with eyes on screen displays quota requirements and acts as a motivating force.
- Failure to meet quota results in death, transporting the player to a "creepy clinic."
- AI boss will periodically address the player with dialogue (inspired by warden mechanics in management games).
- **Death visualization options discussed:**
  - Smoke/gas appearing
  - Floor breaking and player falling
  - Screen flash with sound effect
  - Instant transition (similar to Minecraft respawn mods)
- **Decision:** Avoid copying existing games too closely; aim for a surprise/transition effect.

### 6. Room Unlocking Mechanic
- Doors to new rooms are initially blocked by boards.
- Players must complete quota/tasks, then purchase a crowbar to break the boards and access new areas.

### 7. Upgrade System (Factories)
- 5 types of upgrades implemented:
  - HP increase
  - Damage
  - Click power
  - HP recovery (repair broken factories)
  - Damage output
- Sequential purchasing enforced (must buy Factory 0 before Factory 1, etc.).
- Performance optimization: common timer system instead of local timers.

### 8. Visual Progression for Upgrades
- **Feedback:** Pure parameter changes are too boring for a clicker game.
- **Proposed solution:** Visual hand progression:
  - Wooden → Copper → Iron → Silver → Gold
  - Each tier visually distinct and taps faster.
- **Suggestion:** Implement a separate resource collection system (inspired by puzzle-collection games) to strengthen progression feel and avoid overlap with coin-based upgrades.

### 9. Audio System
- New audio system implemented, allowing easy addition of sounds and music.

### 10. Item Purchasing & Temporary Upgrades
- Two purchasing phases planned:
  1. Vending machine/shop in the main clicking room.
  2. Item shop in the death/black room phase.
- Temporary upgrades system designed (roguelike style):
  - Upgrades unlock gradually over multiple runs.
  - Purchased upgrades become available in future runs.
  - System implemented via decorators, compatible with clickers and regular clicks.

---

## Feedback & Questions

| Topic | Feedback/Question | Source |
|-------|-------------------|--------|
| Factory distraction mechanic | "You can add that as a flex feature later" | Game Designer |
| Cycle restart | "Don't you want to make a restart up to the last quota, not a full reset?" | Game Designer |
| Upgrade system | "The upgrade system is currently more functional... overly complex, overly boring for a clicker if left as-is" | Game Designer |
| Visual upgrades | "Take the meta element from [reference game] and make the player collect another resource to upgrade factories" | Game Designer |
| Death visualization | "I think it's cheaper if you just get shot, the screen flashes white" | Developer 2 |
| Screen progression | "How do you plan to do the screen progression? Where will new items/objects be?" | Game Designer |

---

## Decisions Made

1. **Quota reduction** chosen over click generation for the Big Button Room.
2. **Cycle-based progression** with new employees replacing dead ones, rather than full game resets.
3. **Visual hand progression** (wooden → gold) to accompany stat upgrades.
4. **Death effect** to be a surprise/transition effect, avoiding direct copying of existing games.
5. **Temporary upgrades** to unlock gradually across multiple runs (roguelike model).

---

## Approvals & Requested Changes

| Item | Status | Notes |
|------|--------|-------|
| Factory Room concept | Approved | Core mechanics solid; visual polish needed |
| Big Button Room concept | Approved | Quota reduction mechanic confirmed |
| Upgrade system (functional) | Approved | Needs visual integration |
| Audio system | Approved | Ready for content |
| Death visualization | Requested changes | Avoid direct copying; consider flash/transition effect |
| Item purchasing flow | Requested changes | Clarify where items appear in both life and death phases |

---

## Action Points

| # | Action | Owner | Priority |
|---|--------|-------|----------|
| 1 | Finish implementing and polish current mechanics for cohesive playability | Dev Team | High |
| 2 | Integrate upgrade system with shop system (synchronization pending) | Developer 1, Developer 3 | High |
| 3 | Implement visual progression for factory hands (wooden → gold) | Developer 1 | Medium |
| 4 | Design and implement death transition effect | Dev Team | Medium |
| 5 | Develop AI boss dialogue/event system | Developer 2 | Medium |
| 6 | Finalize item purchasing flow for both life and death phases | Developer 1, Developer 3 | Medium |
| 7 | **Decide on overall game art style** | Full Team | High |
| 8 | **Refine and balance core mechanics** | Game Designer, Dev Team | High |

---

## Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| Synchronization between upgrade and shop systems not yet complete | Delays in integrated testing | Prioritize integration in next sprint |
| Visual upgrades may require significant asset creation | Art pipeline bottleneck | Start with placeholder assets; iterate later |
| Roguelike cycle mechanics may be complex to balance | Player progression feels unrewarding | Playtest early; adjust quota scaling |
| Game style not yet defined | Inconsistent art direction across rooms | Schedule dedicated style discussion session |

---

## Backlog / Artifact Updates

### Added to Backlog
- [ ] Game art style definition and mood board creation
- [ ] Mechanic refinement and balancing pass
- [ ] AI boss dialogue system
- [ ] Death transition effect implementation
- [ ] Visual hand progression assets (5 tiers)
- [ ] Crowbar item and door-breaking mechanic
- [ ] Temporary upgrade shop in death room
- [ ] Separate resource collection system for factory upgrades

### Updated Artifacts
- **Game Design Document:** Updated with Factory Room, Big Button Room, and cycle progression mechanics.
- **Sprint Backlog:** Integration of shop and upgrade systems moved to current sprint.
- **Asset Pipeline:** Hand model variants (wooden, copper, iron, silver, gold) added to art queue.

---

## Client-Requested Additions

Per client feedback, the following have been added as high-priority items for the next sprint:

1. **Define the game's visual and narrative style** — team to align on art direction, tone, and thematic consistency.
2. **Refine core mechanics** — deeper pass on balancing quota systems, upgrade pacing, and room interactions to ensure engaging gameplay loops.

---

**Next Review:** Scheduled for end of next sprint. Focus on polished, playable build with integrated systems.
