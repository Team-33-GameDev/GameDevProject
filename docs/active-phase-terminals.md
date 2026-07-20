# Active-phase terminals and button cooldown

The shop and factory manager remain available while a quota is running.
Opening either terminal during an active quota does not pause the scene tree,
so production, factory wear and the quota timer continue normally. During the
preparation phase the same full-screen interfaces retain their existing pause
behaviour.

Only score above the reserved active quota is spendable. Purchases therefore
cannot consume the funds currently required to pass inspection.

After a successful quota, the production button is disabled for 1.25 seconds.
The button is dimmed during this cooldown and ignores both world interaction
and direct signal calls, preventing an accidental click from starting the next
quota immediately.
