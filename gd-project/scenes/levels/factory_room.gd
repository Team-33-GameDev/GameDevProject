extends Node3D

var factory_manager_entity: Node3D
var factory_manager_overlay: CanvasLayer

func _ready() -> void:
	# Ищем factory_manager_entity
	factory_manager_entity = get_node_or_null("factory_manager_entity")
	if not factory_manager_entity:
		# Пробуем найти по имени
		for child in get_children():
			if child.name.to_lower().contains("factory") and child.name.to_lower().contains("manager"):
				factory_manager_entity = child
				print("✅ Нашёл entity: ", child.name)
				break
	
	# Ищем CanvasLayer
	factory_manager_overlay = get_node_or_null("FactoryManagerOverlay")
	if not factory_manager_overlay:
		# Пробуем найти любой CanvasLayer
		for child in get_children():
			if child is CanvasLayer:
				factory_manager_overlay = child
				print("✅ Нашёл CanvasLayer: ", child.name)
				break
	
	# Подключаем сигнал
	if factory_manager_entity:
		if factory_manager_entity.has_signal("factory_manager_opened"):
			factory_manager_entity.factory_manager_opened.connect(_on_factory_manager_opened)
			print("✅ Сигнал подключён!")
		else:
			push_error(" У factory_manager_entity нет сигнала factory_manager_opened!")
	else:
		push_error(" factory_manager_entity не найден!")
	
	# Скрываем оверлей
	if factory_manager_overlay:
		factory_manager_overlay.visible = false
		print("✅ CanvasLayer готов, visible = false")
	else:
		push_error("❌ CanvasLayer не найден!")

func _on_factory_manager_opened() -> void:
	print("📺 Открываем меню!")
	if factory_manager_overlay:
		factory_manager_overlay.visible = true
		print("   Overlay visible = ", factory_manager_overlay.visible)
		get_tree().paused = true
	else:
		push_error("❌ factory_manager_overlay is null!")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		if factory_manager_overlay and factory_manager_overlay.visible:
			factory_manager_overlay.visible = false
			get_tree().paused = false
			print("❌ Закрыли меню")
