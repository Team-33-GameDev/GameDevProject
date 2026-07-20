#!/usr/bin/env python3
"""Deterministic economy check for the 15-minute campaign.

The model is intentionally conservative: factories are fully repaired during
preparation, then receive no repairs during a run.  It also ignores travel time
and any optional upgrades not listed in the milestone route.
"""

from dataclasses import dataclass
from pathlib import Path
import re


ROOT = Path(__file__).resolve().parents[1]


RUNS = (
    (30, 65),
    (40, 210),
    (50, 480),
    (60, 1_200),
    (70, 1_700),
    (80, 4_500),
    (90, 6_000),
    (90, 13_000),
    (95, 20_000),
    (95, 38_000),
    (100, 70_000),
    (100, 190_000),
)


@dataclass(frozen=True)
class Factory:
    price: int
    cps: int
    lifetime: float
    cps_upgrade_bonus: int
    cps_upgrade_price: int


FACTORIES = {
    "wood": Factory(0, 5, 45.0, 5, 100),
    "stone": Factory(225, 15, 60.0, 5, 150),
    "copper": Factory(900, 50, 75.2, 15, 500),
    "iron": Factory(3_000, 150, 90.0, 50, 1_500),
    "gold": Factory(11_000, 450, 105.0, 150, 5_500),
    "diamond": Factory(55_000, 1_350, 120.0, 450, 30_000),
}

# Purchases happen after the numbered run.  This is one viable route, not a
# forced build: surplus and optional durability upgrades support alternatives.
MILESTONES = {
    1: (("crowbar", 25, "item"), ("wood", 0, "factory")),
    2: (("add 1", 120, "add"),),
    3: (("stone", 225, "factory"),),
    4: (("add 2", 240, "add"), ("wood CPS", 100, "wood_cps")),
    5: (("copper", 900, "factory"),),
    6: (("mult 1", 1_500, "mult"), ("stone CPS", 150, "stone_cps")),
    7: (("iron", 3_000, "factory"),),
    8: (
        ("add 3", 480, "add"),
        ("iron CPS", 1_500, "iron_cps"),
        ("copper CPS", 500, "copper_cps"),
    ),
    9: (("gold", 11_000, "factory"),),
    10: (
        ("mult 2", 4_500, "mult"),
        ("gold CPS", 5_500, "gold_cps"),
        ("add 4", 960, "add"),
    ),
    11: (("diamond", 55_000, "factory"),),
}

FACTORY_CPS_UPGRADES = {
    "wood_cps": ("wood", 5),
    "stone_cps": ("stone", 5),
    "copper_cps": ("copper", 15),
    "iron_cps": ("iron", 50),
    "gold_cps": ("gold", 150),
}

FACTORY_RESOURCES = {
    "wood": "wooden",
    "stone": "stone",
    "copper": "copper",
    "iron": "iron",
    "gold": "golden",
    "diamond": "diamond",
}


def _resource_properties(path: Path) -> dict[str, float]:
    properties: dict[str, float] = {}
    for key, value in re.findall(
        r"^([a-z_]+)\s*=\s*(-?[0-9]+(?:\.[0-9]+)?)$",
        path.read_text(encoding="utf-8"),
        flags=re.MULTILINE,
    ):
        properties[key] = float(value)
    return properties


def validate_project_values() -> None:
    """Fail if the Godot resources drift away from this model."""
    quota_source = (
        ROOT / "gd-project/scripts/globals/quota_manager.gd"
    ).read_text(encoding="utf-8")
    project_runs = tuple(
        (int(float(duration)), int(target))
        for duration, target in re.findall(
            r"^\s*\[([0-9]+(?:\.[0-9]+)?),\s*([0-9]+)\],?$",
            quota_source,
            flags=re.MULTILINE,
        )
    )
    assert project_runs == RUNS, "QuotaManager.quotas differs from RUNS"
    assert "MINIMUM_QUOTA_RATIO: float = 0.90" in quota_source

    click = _resource_properties(
        ROOT / "gd-project/resources/shop_items/basic_click.tres"
    )
    assert click["add_bonus_per_level"] == 2
    assert click["add_price_base"] == 120
    assert click["add_price_mult"] == 2.0
    assert click["mult_price_base"] == 1_500
    assert click["mult_price_mult"] == 3.0

    button = _resource_properties(
        ROOT
        / "gd-project/resources/shop_items/quota/quota_decrease.tres"
    )
    assert button["condition_click"] == 5
    assert button["q_decrease_percent"] == 0.02

    resource_root = (
        ROOT / "gd-project/resources/shop_items/autoclicker"
    )
    for name, expected in FACTORIES.items():
        resource_name = FACTORY_RESOURCES[name]
        data = _resource_properties(
            resource_root / f"{resource_name}_autoclick_data.tres"
        )
        tick_period = data.get("click_ticks_period", 20)
        cps = data["click_value"] / (0.01 * tick_period)
        damage_events = -(-int(data["max_hp"]) // int(data["dmg"]))
        lifetime = damage_events * 0.01 * data["dmg_tick_period"]
        cps_upgrade_bonus = data["bonus_click_value"] / (
            0.01 * tick_period
        )
        restore_presses = -(
            -int(data["max_hp"]) // int(data["rhpt"])
        )
        assert data["item_price"] == expected.price, (
            f"{name} purchase price drifted"
        )
        assert abs(cps - expected.cps) < 0.01, f"{name} CPS drifted"
        assert abs(lifetime - expected.lifetime) < 0.01, (
            f"{name} lifetime drifted"
        )
        assert abs(cps_upgrade_bonus - expected.cps_upgrade_bonus) < 0.01, (
            f"{name} CPS upgrade drifted"
        )
        assert data["ubp_click_value"] == expected.cps_upgrade_price, (
            f"{name} CPS upgrade price drifted"
        )
        assert restore_presses == 4, f"{name} should need four repairs"


def simulate(clicks_per_second: int, quota_reduction: float = 0.0) -> list[dict]:
    score = 0
    add_levels = 0
    mult_levels = 0
    owned: list[str] = []
    cps_bonus = {name: 0 for name in FACTORIES}
    rows: list[dict] = []

    for run_number, (duration, base_quota) in enumerate(RUNS, start=1):
        click_power = (1 + 2 * add_levels) * (2**mult_levels)
        manual = clicks_per_second * duration * click_power
        automated = round(
            sum(
                (factory.cps + cps_bonus[name])
                * min(duration, factory.lifetime)
                for name, factory in FACTORIES.items()
                if name in owned
            )
        )
        # The first run must stand on its own: the crowbar that opens the
        # auxiliary rooms is bought only after this quota.
        applied_reduction = 0.0 if run_number == 1 else quota_reduction
        quota = round(base_quota * (1.0 - applied_reduction))
        gross = score + manual + automated
        assert gross >= quota, (
            f"run {run_number} failed: {gross} earned, {quota} required"
        )
        score = gross - quota

        bought: list[str] = []
        for name, price, effect in MILESTONES.get(run_number, ()):
            assert score >= price, (
                f"run {run_number} cannot buy {name}: {score} available, "
                f"{price} required"
            )
            score -= price
            bought.append(name)

            if effect == "factory":
                owned.append(name)
            elif effect == "add":
                add_levels += 1
            elif effect == "mult":
                mult_levels += 1
            elif effect in FACTORY_CPS_UPGRADES:
                factory_name, bonus = FACTORY_CPS_UPGRADES[effect]
                cps_bonus[factory_name] += bonus

        rows.append(
            {
                "run": run_number,
                "seconds": duration,
                "quota": quota,
                "gross": gross,
                "surplus": score,
                "purchases": ", ".join(bought) or "save for finale",
            }
        )

    return rows


def main() -> None:
    validate_project_values()
    assert sum(duration for duration, _quota in RUNS) >= 15 * 60
    assert all(
        current[1] < following[1]
        for current, following in zip(RUNS, RUNS[1:])
    )

    scenarios = (
        ("accessibility", 3, 0.10),
        ("baseline", 4, 0.00),
        ("experienced", 5, 0.00),
    )
    results = []
    for name, click_rate, reduction in scenarios:
        rows = simulate(click_rate, reduction)
        results.append((name, rows[-1]["surplus"]))

    baseline = simulate(4)
    print("run sec quota gross surplus purchases")
    for row in baseline:
        print(
            f"{row['run']:>3} {row['seconds']:>3} {row['quota']:>6} "
            f"{row['gross']:>6} {row['surplus']:>7} {row['purchases']}"
        )
    print(f"active campaign time: {sum(duration for duration, _ in RUNS)}s")
    for name, surplus in results:
        print(f"{name}: PASS, final surplus {surplus}")


if __name__ == "__main__":
    main()
