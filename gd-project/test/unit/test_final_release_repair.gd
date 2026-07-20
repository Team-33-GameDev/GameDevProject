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


func test_failed_quota_rebuilds_factories_from_starting_checkpoint() -> void:
	var manager := ProgressionAccessibilityManager.new()
	var factory_manager := FactoryManager.new()
	var wooden := Factory.new()
	var stone := Factory.new()

	wooden.data = AutoClickerData.new()
	stone.data = AutoClickerData.new()
	wooden.data.is_purchased = true
	wooden.data.upg_lvl_click = 2
	wooden.data.click_value = 9
	stone.data.is_purchased = false

	factory_manager.all_factories = [wooden, stone]
	factory_manager.active_factories = [wooden]
	manager._factory_manager = factory_manager
	manager._capture_checkpoint()

	wooden.data.upg_lvl_click = 5
	wooden.data.click_value = 30
	stone.data.is_purchased = true
	factory_manager.active_factories.append(stone)

	manager._on_quota_ended(false)

	assert_true(wooden.data.is_purchased)
	assert_eq(wooden.data.upg_lvl_click, 2)
	assert_eq(wooden.data.click_value, 9)
	assert_false(stone.data.is_purchased)
	assert_eq(factory_manager.active_factories, [wooden])

	manager.free()
	factory_manager.free()
	wooden.free()
	stone.free()
