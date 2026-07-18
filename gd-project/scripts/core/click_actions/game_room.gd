extends Node3D

@onready var mc_button = $MainRoom/Buttons/ClickButton
@onready var shop = $ShopSystem

var factory_scene = preload("res://scenes/props/factory.tscn")

signal click

var test_sound_player: AudioStreamPlayer3D

func _ready() -> void:
	# === НАДЕЖНАЯ ПРОВЕРКА: МЫ В МЕНЮ ИЛИ В ИГРЕ? ===
	# Если текущая активная сцена в дереве НЕ является этой сценой, 
	# значит, мы загружены как под-сцена (фон в меню).
	if get_tree().current_scene != self:
		print("🎮 Game Room запущен как ФОН МЕНЮ. Игровая логика отключена.")
		
		# Полностью отключаем обработку для этой ноды и всех её детей
		process_mode = Node.PROCESS_MODE_DISABLED
		
		# Если у тебя есть 3D звук для теста, можно его тут включить, а игровую логику пропустить
		# test_sound_player = AudioManager.play_sfx_3d_loop("button_click", Vector3(0, 2, 0), self)
		
		return # ВЫХОДИМ из функции, игровая логика ниже не выполнится!

	# === ЕСЛИ МЫ ЗДЕСЬ, ЗНАЧИТ ЭТО НАСТОЯЩАЯ ИГРА ===
	print("🎮 Game Room запущен как ИГРА. Загрузка логики...")
	
	# Тут твоя обычная игровая инициализация (если она есть)
	# Например:
	# GameManager.score_changed.connect(_on_score_changed)

func _on_click_button_button_clicked() -> void:
	# Эта функция не вызовется, если process_mode = DISABLED, 
	# но на всякий случай добавим проверку:
	if process_mode == Node.PROCESS_MODE_DISABLED:
		return
		
	if shop and shop.has_method("emit"): # Убедимся, что shop существует
		shop.click.emit()

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
