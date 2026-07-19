# Contextual Hint System

The tutorial is presented as short system directives on the existing CRT-style
main display. It avoids a separate modern HUD and keeps information inside the
game's dystopian visual language.

## Behavior

- Hints appear only when their mechanic first becomes relevant in the current
  application session.
- Each directive closes automatically after five seconds.
- Hints wait while a terminal overlay has paused the game, so purchase feedback
  is still readable after the player closes the terminal.
- Unknown hint identifiers are ignored safely.
- Normal directives are cold blue, maintenance notices are amber, and denied
  actions are red.

## Covered mechanics

| Trigger | Directive purpose |
| --- | --- |
| Boss introduction ends | Start the first quota with the main button |
| First quota begins | Reach the target before time expires; quota funds are reserved |
| First preparation phase | Surplus is spendable and terminals are available |
| Terminal used during a quota | Explain why access is denied |
| Crowbar purchased | Direct the player to wooden barricades |
| Factory purchased or upgraded | Explain HP loss and green repair buttons |
| Manual click upgraded | Confirm that click output changed |
| First Big Button jump | Explain the three-jump, five-percent, thirty-percent rule |

The physical shop, factory, and Big Button displays remain the detailed source
of prices and statistics. Contextual hints only explain the next useful action.
