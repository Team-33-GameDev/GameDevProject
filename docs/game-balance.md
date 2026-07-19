# Game Balance

This document records the baseline economy for the current four-run campaign.
It is intended as a reproducible starting point for playtests, not as a
substitute for telemetry and player observation.

## Assumptions

- Each run lasts 30 seconds.
- The baseline manual rate is 5 clicks per second.
- The active quota is reserved. Only `score - current_quota` is spendable.
- On success, the quota is deducted and surplus score carries into preparation.
- The Big Button can reduce the current target by at most 30% per run.

## Intended Early Progression

| Run | Quota | Expected purchase after success |
| --- | ---: | --- |
| 1 | 100 | Crowbar (25) |
| 2 | 200 | Additive click upgrade (75) |
| 3 | 800 | Stone Factory (250) |
| 4 | 1,500 | Complete the campaign using manual clicks and factories |

At the baseline input rate, this route leaves a small but useful surplus at
each preparation phase. The player may deviate by using the Big Button,
repairing factories, or saving for a different upgrade.

## Factory Curve

| Factory | Price | CPS | Approx. payback | Base lifetime |
| --- | ---: | ---: | ---: | ---: |
| Wooden | 0 | 5 | Immediate | 30 s |
| Stone | 250 | 25 | 10 s | 39.6 s |
| Copper | 900 | 75 | 12 s | 60.3 s |
| Iron | 3,500 | 250 | 14 s | 60 s |
| Golden | 14,000 | 1,250 | 11.2 s | 61.2 s |
| Diamond | 60,000 | 5,000 | 12 s | 60 s |

Factory lifetime is calculated without repairs or durability upgrades.
Payback is nominal production time and does not include room traversal or
maintenance.

## Playtest Signals

Record completion rate and surplus after every quota, purchase order, manual
click rate, factory downtime, and Big Button use. Adjust one variable family
at a time: quotas, income, prices, or durability. The target experience is a
10–15 minute session with a clear decision during every preparation phase.
