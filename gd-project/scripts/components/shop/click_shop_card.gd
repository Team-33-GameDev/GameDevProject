extends Control
class_name ClickShopCard


signal pressed


@onready var buy_button: Button = $BuyButton
@onready var title_label: Label = $Title
@onready var details_label: Label = $Details
@onready var caption_label: Label = $Caption
@onready var value_label: Label = $Value


func _ready() -> void:
	if not buy_button.pressed.is_connected(
		_on_buy_button_pressed
	):
		buy_button.pressed.connect(
			_on_buy_button_pressed
		)


func set_content(
	title_text: String,
	details_text: String,
	caption_text: String,
	value_text: String,
	is_affordable: bool = true,
	is_enabled: bool = true
) -> void:
	title_label.text = title_text
	details_label.text = details_text
	caption_label.text = caption_text
	value_label.text = value_text

	buy_button.disabled = not is_enabled

	if is_enabled:
		modulate = Color.WHITE
	else:
		modulate = Color(1.0, 1.0, 1.0, 0.45)

	if is_affordable:
		value_label.modulate = Color.WHITE
	else:
		value_label.modulate = Color(
			1.0,
			1.0,
			1.0,
			0.45
		)


func _on_buy_button_pressed() -> void:
	pressed.emit()
