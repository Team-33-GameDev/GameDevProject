extends Node


# При 10 CPS анимация проигрывается со скоростью 1.0.
#
# Примеры:
# 5 CPS  -> 0.5
# 10 CPS -> 1.0
# 25 CPS -> 2.5
# 75 CPS -> 7.5
@export_range(0.1, 1000.0, 0.1)
var cps_at_normal_animation_speed: float = 10.0

# Даже самые первые фабрики должны двигаться
# с хорошо заметной скоростью.
@export_range(0.01, 10.0, 0.01)
var min_factory_animation_speed: float = 0.5

# Защита от чрезмерно быстрой анимации
# на поздних улучшениях.
@export_range(0.1, 50.0, 0.1)
var max_factory_animation_speed: float = 12.0


@onready var factory_backend: FactoryManager = \
	get_node("../FactoryBackend")

# Порядок моделей соответствует порядку backend-фабрик.
@onready var factory_models: Array[Node] = [
	get_node("../Box/moneypulator_wood"),
	get_node("../Box/moneypulator_stone"),
	get_node("../Box/moneypulator_cuprum"),
	get_node("../Box/moneypulator_metal"),
	get_node("../Box/moneypulator_gold"),
	get_node("../Box/moneypulator_glass"),
]


# index фабрики -> AnimationPlayer.
var _animation_players: Dictionary = {}

# index фабрики -> имя рабочей анимации.
var _animation_names: Dictionary = {}


func _ready() -> void:
	# FactoryBackend должен сначала обнаружить фабрики
	# и назначить им индексы.
	call_deferred("_setup")


func _setup() -> void:
	if factory_backend == null:
		push_error(
			"FactoryAnimationController: "
			+ "FactoryBackend was not found."
		)
		return

	var factories: Array[Factory] = \
		factory_backend.get_all_factories()

	if factories.size() != factory_models.size():
		push_warning(
			(
				"FactoryAnimationController: "
				+ "factory count %d does not match "
				+ "model count %d."
			)
			% [
				factories.size(),
				factory_models.size(),
			]
		)

	var mapped_count: int = mini(
		factories.size(),
		factory_models.size()
	)

	for index in range(mapped_count):
		_setup_factory_animation(
			factory_models[index],
			index
		)

	if not QuotaManager.run_started.is_connected(
		_on_run_started
	):
		QuotaManager.run_started.connect(
			_on_run_started
		)

	if not QuotaManager.run_ended.is_connected(
		_on_run_ended
	):
		QuotaManager.run_ended.connect(
			_on_run_ended
		)

	if not factory_backend.factory_updated.is_connected(
		_on_factory_updated
	):
		factory_backend.factory_updated.connect(
			_on_factory_updated
		)

	if not factory_backend.cps_changed.is_connected(
		_on_cps_changed
	):
		factory_backend.cps_changed.connect(
			_on_cps_changed
		)

	_refresh_all_factory_animations()


func _setup_factory_animation(
	model_root: Node,
	index: int
) -> void:
	var binding: Dictionary = \
		_find_animation_binding(model_root)

	if binding.is_empty():
		push_warning(
			(
				"FactoryAnimationController: "
				+ "no work animation found for "
				+ "factory %d, model %s."
			)
			% [
				index,
				model_root.name,
			]
		)
		return

	var player := \
		binding.get("player") as AnimationPlayer

	var animation_name := StringName(
		binding.get("animation", &"")
	)

	if player == null or animation_name == &"":
		return

	_animation_players[index] = player
	_animation_names[index] = animation_name

	# Некоторые модели импортированы с незакольцованной
	# анимацией. Принудительно включаем обычный цикл.
	var animation: Animation = \
		player.get_animation(animation_name)

	if animation != null:
		animation.loop_mode = Animation.LOOP_LINEAR

	player.stop()

	print(
		(
			"FactoryAnimationController: "
				+ "factory %d -> %s / %s"
		)
		% [
			index,
			player.get_path(),
			animation_name,
		]
	)


func _find_animation_binding(
	root: Node
) -> Dictionary:
	var players: Array[AnimationPlayer] = []

	_collect_animation_players(
		root,
		players
	)

	# Сначала ищем явно названный производственный цикл.
	# Это важно для медной модели, где клип называется
	# FactoryCycle.
	for player in players:
		for animation_name_value in \
			player.get_animation_list():

			var animation_name := StringName(
				animation_name_value
			)

			var normalized_name: String = \
				String(animation_name).to_lower()

			if normalized_name == "reset":
				continue

			if normalized_name.contains(
				"factorycycle"
			):
				return {
					"player": player,
					"animation": animation_name,
				}

	# Затем ищем любую анимацию со словом cycle.
	for player in players:
		for animation_name_value in \
			player.get_animation_list():

			var animation_name := StringName(
				animation_name_value
			)

			var normalized_name: String = \
				String(animation_name).to_lower()

			if normalized_name == "reset":
				continue

			if normalized_name.contains("cycle"):
				return {
					"player": player,
					"animation": animation_name,
				}

	# Последний вариант — первая анимация,
	# которая не является RESET.
	for player in players:
		for animation_name_value in \
			player.get_animation_list():

			var animation_name := StringName(
				animation_name_value
			)

			if (
				String(animation_name).to_lower()
				== "reset"
			):
				continue

			return {
				"player": player,
				"animation": animation_name,
			}

	return {}


func _collect_animation_players(
	root: Node,
	result: Array[AnimationPlayer]
) -> void:
	if root is AnimationPlayer:
		result.append(
			root as AnimationPlayer
		)

	for child in root.get_children():
		_collect_animation_players(
			child,
			result
		)


func _on_run_started() -> void:
	_refresh_all_factory_animations()


func _on_run_ended(
	_success: bool
) -> void:
	# Не вызываем stop(), потому что stop()
	# возвращает анимацию к начальному состоянию.
	#
	# pause() сохраняет текущий кадр до следующей фазы.
	_pause_all_factory_animations()


func _on_factory_updated(
	factory: Factory
) -> void:
	if factory == null:
		return

	_refresh_factory_animation(
		factory.index
	)


func _on_cps_changed(
	_new_cps: float
) -> void:
	# CPS меняется при покупке, улучшении,
	# уничтожении или восстановлении фабрики.
	_refresh_all_factory_animations()


func _refresh_all_factory_animations() -> void:
	for index_value in _animation_players.keys():
		_refresh_factory_animation(
			int(index_value)
		)


func _refresh_factory_animation(
	index: int
) -> void:
	var player := \
		_animation_players.get(index) as AnimationPlayer

	var animation_name := StringName(
		_animation_names.get(index, &"")
	)

	var factory: Factory = \
		factory_backend.get_factory(index)

	if (
		player == null
		or animation_name == &""
		or factory == null
		or factory.data == null
	):
		return

	var factory_can_work: bool = (
		factory.data.is_purchased
		and factory.data.is_alive()
		and not factory.data.is_factory_pause
	)

	# Неприобретённая, уничтоженная или вручную
	# остановленная фабрика возвращается в исходную позу.
	if not factory_can_work:
		player.stop()
		return

	player.speed_scale = \
		_calculate_animation_speed(factory)

	# Купленная фабрика во время подготовки сохраняет
	# текущий кадр и ждёт следующей клик-фазы.
	if (
		QuotaManager.current_state
		!= QuotaManager.GameState.RUNNING
	):
		player.pause()
		return

	# После pause() пустой play() продолжает текущий клип
	# с сохранённой позиции.
	if player.current_animation == animation_name:
		player.play()
	else:
		player.play(animation_name)


func _calculate_animation_speed(
	factory: Factory
) -> float:
	if (
		factory.data == null
		or factory_backend.tick_interval <= 0.0
		or cps_at_normal_animation_speed <= 0.0
	):
		return 1.0

	var safe_click_period: int = maxi(
		1,
		factory.data.click_ticks_period
	)

	var click_interval_seconds: float = (
		factory_backend.tick_interval
		* float(safe_click_period)
	)

	if click_interval_seconds <= 0.0:
		return 1.0

	var factory_cps: float = (
		float(factory.data.click_value)
		/ click_interval_seconds
	)

	var raw_speed: float = (
		factory_cps
		/ cps_at_normal_animation_speed
	)

	var safe_min_speed: float = minf(
		min_factory_animation_speed,
		max_factory_animation_speed
	)

	var safe_max_speed: float = maxf(
		min_factory_animation_speed,
		max_factory_animation_speed
	)

	return clampf(
		raw_speed,
		safe_min_speed,
		safe_max_speed
	)


func _pause_all_factory_animations() -> void:
	for player_value in _animation_players.values():
		var player := \
			player_value as AnimationPlayer

		if player != null:
			player.pause()
