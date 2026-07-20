# Death quota checkpoint

Failing a quota no longer resets the campaign to quota one. The failed quota
index is retained while its score, timer and temporary target state are
cleared. The death room therefore returns the player to the last unfinished
quota when they press the restart key.

The retry checkpoint is captured at the exact start of every quota. On death,
factory purchases, factory upgrades and manual-click upgrades made during the
failed attempt are rolled back. Factories and upgrades owned before the quota
remain purchased, keep their checkpoint health and pause state, and are added
back to the active production list.

The boss onboarding monologue and eye screen are shown once per new game. A
death-room retry or Continue returns directly to the normal quota display.
The failed attempt starts again with zero score and the quota's full configured
time and target.
