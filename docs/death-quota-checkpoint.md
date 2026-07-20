# Death quota checkpoint

Failing a quota no longer resets the campaign to quota one. The failed quota
index is retained while its score, timer and temporary target state are
cleared. The death room therefore returns the player to the last unfinished
quota when they press the restart key.

The retry checkpoint is saved before entering the death room. Purchased
upgrades and earned tickets remain available, while the failed attempt starts
again with zero score and the quota's full configured time and target.
