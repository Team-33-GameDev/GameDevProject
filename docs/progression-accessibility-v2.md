# Conflict-resistant progression and accessibility integration

`ProgressionAccessibilityManager` is created once by `GameRoom` and attached
to the scene-tree root. It therefore survives transitions to the death room
and back without modifying the existing SaveManager, player, TV, shop,
factory or prop scripts.

The manager writes `user://progression_accessibility.json` whenever the base
SaveManager emits `game_saved`. The extended checkpoint contains factory
purchase and upgrade state, factory health, click-upgrade counters, Crowbar
ownership and destroyed wooden barriers. Quota index, tickets and permanent
click bonuses remain owned by the existing save file.

The same persistent node adds timed boss subtitles, faces the player toward
the main monitor when the office loads and displays contextual `E`/`LMB`
prompts for the collider under the reticle.
