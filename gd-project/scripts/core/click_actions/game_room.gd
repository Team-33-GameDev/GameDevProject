extends Node3D

@onready var mc_button = $Buttons/ClickButton
@onready var shop = $Shop
var factory_scene = preload("res://scenes/props/factory.tscn")
signal click

var test_sound_player: AudioStreamPlayer3D

func _ready():
	 #Твой существующий код
	GameManager.click(100000000)
	
	## Тестовый 3D звук клика в центре комнаты
	#test_sound_player = AudioManager.play_sfx_3d_loop(
		#"button_click", 
		#Vector3(0.832, 0, 0),  # Позиция: центр комнаты
		#self
	#)
	## Делаем его зацикленным
	#if test_sound_player:
		#test_sound_player.finished.connect(func(): 
			#if test_sound_player:
				#test_sound_player.play()
		#)
	#
	#print("🔊 Тестовый 3D звук запущен!")

func _on_click_button_button_clicked() -> void:
	shop.click.emit()

func _on_click_button_2_button_clicked() -> void:
	shop.buy_factory(0)

func _on_click_button_3_button_clicked() -> void:
	shop.buy_factory(1)

func _on_click_button_4_button_clicked() -> void:
	shop.upgrade_factory_click(0)

func _on_click_button_5_button_clicked() -> void:
	shop.upgrade_click_add()

func _on_click_button_6_button_clicked() -> void:
	shop.upgrade_click_mult()

func _on_click_button_7_button_clicked() -> void:
	shop.upgrade_factory_click(1)

#func _exit_tree():
	## Очищаем при выходе из комнаты
	#if test_sound_player:
		#AudioManager.stop_sfx_3d(test_sound_player)
