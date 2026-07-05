

## Context

GameManager, QuotaManager and other systems need to communicate while staying independent. If components call each other's methods directly, we get tight coupling: ClickButton needs to know about QuotaManager, QuotaManager about TVDisplay, and any change breaks half the code.

## Decision

We use Godot Autoload singletons combined with signals:

- `GameManager` stores state (score, tickets, click power) and emits `score_changed`
- `QuotaManager` listens to `score_changed`, manages timer and phases, emits `run_started`, `run_ended`, `timer_updated`
- `Events` handles game reset and tickets

Components don't call each other's methods directly. ClickButton emits a signal, GameManager catches it and emits its own, QuotaManager reacts. Each layer only knows about the layer below.

## Consequences

Pros: components are easy to test in isolation, new features can be added without modifying old files, replacing one component doesn't break others.

Cons: signal flow is harder to trace in the debugger, Autoload is accessible from everywhere and easy to misuse, signals are slightly slower than direct calls (not critical for our game).

## Related

- Quality requirements: QR-01 (Performance Efficiency), QR-02 (Reliability), QR-03 (Usability)
- Views: [Static View](../static-view/component-diagram.puml), [Dynamic View](../dynamic-view/core-gameplay-sequence.puml)
