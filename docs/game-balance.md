# Game Balance

This document defines the economy for the 12-run campaign. The values are a
playtest baseline: they are backed by a deterministic model, but telemetry and
player observation must still decide the final tuning.

## Experience Target

- Active quota time is exactly 900 seconds (15 minutes).
- Preparation, shopping, repairs, and room traversal extend a normal session
  beyond 15 minutes without padding an individual timer.
- The baseline model uses four manual clicks per second.
- Three clicks per second remains viable when the player uses the full Big
  Button accessibility buffer.
- Every preparation phase offers a useful purchase, a saving decision, or a
  repair decision.
- Pressure rises in waves: expensive factory unlocks create tight beats and
  the following production spike creates a release beat.

The model is executable with:

```bash
python3 tools/balance_model.py
```

## Economy Rules

- Quota progress and purchases share one score pool. Buying during an active
  quota lowers current progress and creates a deliberate risk/reward choice.
- Completing a run deducts the current quota; surplus carries into preparation.
- Shop and factory upgrade terminals remain functional during active quotas;
  their overlays do not pause the timer or factory simulation. During
  preparation the same interfaces pause the scene tree for planning.
- The Big Button reduces 5% of the current target after every three registered
  jumps, up to 30% of the run's original target. It is a recovery tool rather
  than the dominant source of progress.
- Factories produce and take damage only while a quota is running. The balance
  model assumes they start repaired and receive no mid-run repairs, so attentive
  maintenance creates genuine upside.

## Campaign Curve

| Run | Time | Quota | Baseline milestone after success |
| ---: | ---: | ---: | --- |
| 1 | 30 s | 65 | Crowbar (25), Wooden Factory (free) |
| 2 | 40 s | 210 | Additive click level 1 (120) |
| 3 | 50 s | 480 | Stone Factory (225) |
| 4 | 60 s | 1,200 | Additive level 2 (240), Wooden CPS (100) |
| 5 | 70 s | 1,700 | Copper Factory (900) |
| 6 | 80 s | 4,500 | Multiplier level 1 (1,500), Stone CPS (150) |
| 7 | 90 s | 6,000 | Iron Factory (3,000) |
| 8 | 90 s | 13,000 | Additive level 3 (480), Iron CPS (1,500), Copper CPS (500) |
| 9 | 95 s | 20,000 | Golden Factory (11,000) |
| 10 | 95 s | 38,000 | Multiplier level 2 (4,500), Golden CPS (5,500), additive level 4 (960) |
| 11 | 100 s | 70,000 | Diamond Factory (55,000) |
| 12 | 100 s | 190,000 | Finale |

This route proves affordability; it is not enforced. The player can exchange
some CPS purchases for durability, faster restoration, or saved score. At four
clicks per second the conservative route finishes with about 48,000 surplus.
At three clicks per second and a full 30% quota reduction it still completes.

## Manual Click Curve

| Upgrade | Effect | Price curve |
| --- | ---: | ---: |
| Additive | +2 click power per level | 120 × 2^level |
| Multiplicative | ×2 after additive bonuses | 1,500 × 3^level |

The milestone route produces click powers `1 → 3 → 5 → 10 → 14 → 36`.
Multipliers are deliberately delayed: buying one feels transformative, but it
cannot erase the early factory and repair decisions.

## Factory Curve

Factory CPS is `click_value / (0.01 × 20)`. Base lifetime is calculated without
repairs or durability upgrades.

| Factory | Price | CPS | Nominal payback | Base lifetime | Repair per press |
| --- | ---: | ---: | ---: | ---: | ---: |
| Wooden | 0 | 5 | Immediate | 45.0 s | 25 |
| Stone | 225 | 15 | 15.0 s | 60.0 s | 40 |
| Copper | 900 | 50 | 18.0 s | 75.2 s | 60 |
| Iron | 3,000 | 150 | 20.0 s | 90.0 s | 100 |
| Golden | 11,000 | 450 | 24.4 s | 105.0 s | 190 |
| Diamond | 55,000 | 1,350 | 40.7 s | 120.0 s | 375 |

Production grows by roughly three times per tier while payback gradually
lengthens. Earlier factories therefore remain relevant instead of becoming
visual clutter. From zero health every base factory needs about four repair
presses, keeping maintenance readable and avoiding click spam.

CPS upgrade bonuses are 5, 5, 15, 50, 150, and 450 CPS from Wooden through
Diamond. Base CPS upgrade prices are 100, 150, 500, 1,500, 5,500, and 30,000.
All factory upgrade prices grow by 1.8 per level.

## Why This Shape

The balance book's resource-economy and progression chapters recommend choosing
an anchor, coordinating cost and power curves, and adding peaks and valleys
instead of one smooth escalation. Here the anchors are player time and score per
second. The 12 short-to-medium runs create repeated tension and preparation
beats, while milestone purchases deliberately alternate narrow and generous
surplus.

The external references support the same structure:

- [The Math of Idle Games, Part I](https://www.gamedeveloper.com/design/the-math-of-idle-games-part-i)
  treats generator output, cost growth, and spreadsheet simulation as one
  connected system.
- [Quest for Progress: The Math and Design of Idle Games](https://media.gdcvault.com/gdceurope2016/presentations/Pecorella_Anthony_Quest%20for%20Progress.pdf)
  emphasizes regular purchase choices and keeping earlier generators useful.
- [Playing to Wait: A Taxonomy of Idle Games](https://www.researchgate.net/publication/324658906_Playing_to_Wait_A_Taxonomy_of_Idle_Games)
  frames attention and time as resources and the shift from repeated action to
  planning as a core idle-game experience.
- [Simulating Mechanics to Study Emergence in Games](https://cdn.aaai.org/ojs/12477/12477-52-16005-1-2-20201228.pdf)
  provides the sources, drains, converters, and end-condition vocabulary used
  to audit this economy.

## Playtest Protocol

Run at least five fresh sessions per cohort and record:

- real completion time and completion/failure run;
- manual click rate per run;
- score before and after every preparation phase;
- purchase order and upgrades that are never selected;
- factory downtime, repair presses, and deaths;
- Big Button activations and achieved quota reduction;
- time spent travelling and choosing purchases.

Useful first targets are a 60–80% first-session completion rate, at least two
different successful purchase routes, and no preparation phase where every
player makes the same obvious purchase. Change only one family at a time:
quotas, click income, factory output, prices, or durability.
