# Final release repair

This patch removes every tree change introduced by PR #226 and then reconnects
the existing sledgehammer to the shop without replacing its gameplay script.

The hammer keeps its original rigid-body, pickup, throw, and brick-breaking
behaviour. While locked it remains physically simulated so it can settle on the
floor; the shop only hides it and removes the `pickable` group. Buying it for
the price stored in `sledgehammer.tres` reveals the same scene instance.

The contextual UI now explains how to pick up and throw the hammer. Failed
quotas restore click and factory upgrades captured at quota start, while tool
purchases and opened barriers remain persistent.
