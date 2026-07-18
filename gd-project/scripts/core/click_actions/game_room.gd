extends Node3D

@onready var mc_button = $MainRoom/Buttons/ClickButton
@onready var shop = $ShopSystem

var factory_scene = preload("res://scenes/props/factory.tscn")

signal click

var test_sound_player: AudioStreamPlayer3D

func _ready() -> void:
	var scene_name = get_tree().current_scene.name.to_lower()
	
	if scene_name == "mainmenu" or scene_name == "control":
		print("🎮 Game Room запущен как ФОН МЕНЮ. Отключаю только игровую логику.")
		
		# 1. Отключаем Игрока
		var player = get_node_or_null("Player")
		if player:
			player.process_mode = Node.PROCESS_MODE_DISABLED
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			var player_cam = player.get_node_or_null("Head/Camera3D")
			if player_cam:
				player_cam.current = false

		# 2. Отключаем магазин
		if shop:
			shop.process_mode = Node.PROCESS_MODE_DISABLED

		# 3. УБРАЛ СТРОКУ mc_button.disabled = true
		# Просто отключаем обработку, этого достаточно
		if mc_button:
			mc_button.process_mode = Node.PROCESS_MODE_DISABLED

		return

	# === ИГРА ===
	print(" Game Room запущен как ИГРА. Загрузка логики...")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _on_click_button_button_clicked() -> void:
	print("🔴 [GameRoom] Кнопка нажата!")
	if process_mode == Node.PROCESS_MODE_DISABLED:
		print("❌ [GameRoom] Отменено, так как process_mode = DISABLED (мы в меню?)")
		return
		
	if shop:
		print("🔴 [GameRoom] Вызываем shop.click.emit()")
		shop.click.emit()
	else:
		print("❌ [GameRoom] Нода 'shop' не найдена!")

# Остальные функции с проверками (они безопасны)
func _on_click_button_2_button_clicked() -> void:
	if process_mode == Node.PROCESS_MODE_DISABLED: return
	if shop and shop.has_method("buy_factory"): shop.buy_factory(0)

func _on_click_button_3_button_clicked() -> void:
	if process_mode == Node.PROCESS_MODE_DISABLED: return
	if shop and shop.has_method("buy_factory"): shop.buy_factory(1)

func _on_click_button_4_button_clicked() -> void:
	if process_mode == Node.PROCESS_MODE_DISABLED: return
	if shop and shop.has_method("upgrade_factory_click"): shop.upgrade_factory_click(0)

func _on_click_button_5_button_clicked() -> void:
	if process_mode == Node.PROCESS_MODE_DISABLED: return
	if shop and shop.has_method("upgrade_click_add"): shop.upgrade_click_add()

func _on_click_button_6_button_clicked() -> void:
	if process_mode == Node.PROCESS_MODE_DISABLED: return
	if shop and shop.has_method("upgrade_click_mult"): shop.upgrade_click_mult()

func _on_click_button_7_button_clicked() -> void:
	if process_mode == Node.PROCESS_MODE_DISABLED: return
	if shop and shop.has_method("upgrade_factory_click"): shop.upgrade_factory_click(1)
