extends Control

@export var input_path:NodePath

@onready var game_info = $Background/MarginContainer/BoxContainer/GameInfo
@onready var command_processor: Node = $CommandProcessor
@onready var room_manager: Node = $RoomManager
@onready var __input_edit:LineEdit = get_node(input_path)


func _on_text_changed(new_text):
	if Input.is_action_pressed("ui_text_backspace"): return
	match new_text:
		"inv":
			new_text = new_text.replace("inv", "inventory")
			__input_edit.text = new_text
			__input_edit.caret_column = new_text.length()


func _ready() -> void:
	__input_edit.connect("text_changed", _on_text_changed)
	
	game_info.create_response("Welcome to the retro text adventure! You can type 'help' to see your available commands.")
	
	var player = Player.new()
	player.take_item(room_manager.load_item("GuardSword"))
	var starting_room_response = command_processor.initialize(room_manager.get_child(0), player)
	game_info.create_response(starting_room_response)


func _on_input_text_submitted(new_text: String) -> void:
	if new_text.is_empty(): return
	
	var response = command_processor.process_command(new_text)
	game_info.create_response_with_input(response, new_text)
