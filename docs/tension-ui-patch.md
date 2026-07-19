# Tension and responsive UI patch

This patch is a focused adjustment on top of the 15-minute campaign balance.

## Factory wear

Every factory wear event now removes twice the configured base damage. This
halves nominal uninterrupted lifetime without changing factory prices, CPS or
the relative durability curve. Repairs and durability upgrades therefore
matter more often during the campaign.

## Big Button

The previous Big Button tuning is restored:

- one activation after every three jumps;
- 5% reduction from the current quota per activation;
- a 30% maximum total reduction per quota phase.

The separate Big Button display remains passive and only reports the existing
button state.

## Responsive screens

The shop and factory manager use 1152x648 as their reference canvas. Their
interactive content scales uniformly by the smaller viewport ratio, preserving
the original 16:9 composition without stretching cards, buttons, borders or
text. The same scenes therefore remain proportional both on their 3D monitors
and in full-screen overlays.
