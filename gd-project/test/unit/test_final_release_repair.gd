extends GutTest


const SLEDGEHAMMER_SCENE := preload(
	"res://scenes/props/sledgehammer.tscn"
)


var _previous_score: int
var _previous_quota_state: int


func before_each() -> void:
	_previous_score = GameManager.score
	_previous_quota_state = QuotaManager.current_state


func after_each() -> void:
	GameManager.score = _previous_score
	QuotaManager.current_state = _previous_quota_state


func test_shop_unlock_does_not_change_sledgehammer_physics() -> void:
	var hammer := SLEDGEHAMMER_SCENE.instantiate() as RigidBody3D
	var shop := Shop.new()
	add_child_autofree(hammer)
	add_child_autofree(shop)
	await get_tree().process_frame
	await get_tree().process_frame

	var original_layer := hammer.collision_layer
	var original_mask := hammer.collision_mask

	assert_false(hammer.visible)
	assert_false(hammer.is_in_group(&"pickable"))
	assert_false(hammer.freeze)
	assert_gt(original_layer, 0)
	assert_gt(original_mask, 0)

	QuotaManager.current_state = QuotaManager.GameState.RUNNING
	GameManager.score = shop.get_sledgehammer_price()

	assert_true(shop.buy_sledgehammer())
	assert_true(hammer.visible)
	assert_true(hammer.is_in_group(&"pickable"))
	assert_false(hammer.freeze)
	assert_eq(hammer.collision_layer, original_layer)
	assert_eq(hammer.collision_mask, original_mask)


func test_failed_quota_restores_starting_click_upgrades() -> void:
	var manager := ProgressionAccessibilityManager.new()
	var shop := Shop.new()
	var click_data := ClickUpgradeData.new()
	shop.click_upgrade_data = click_data
	manager._shop_backend = shop

	click_data.add_level = 2
	manager._capture_checkpoint()
	click_data.add_level = 7

	manager._on_quota_ended(false)

	assert_eq(click_data.add_level, 2)
	manager.free()
	shop.free()
