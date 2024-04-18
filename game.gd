extends Control

@export var input_path:NodePath
@export var path_history: NodePath
@export var path_scroll: NodePath
@export var max_lines_remembered = 30

const INPUT_RESPONSE = preload("res://input/input_response.tscn")
const RESPONSE = preload("res://input/response.tscn")

@onready var command_processor: Node = $CommandProcessor
@onready var room_manager: Node = $RoomManager
@onready var __input_edit:LineEdit = get_node(input_path)
@onready var history: VBoxContainer = get_node(path_history)
@onready var scroll: ScrollContainer = get_node(path_scroll)
@onready var scrollbar: VScrollBar = scroll.get_v_scroll_bar()


func _on_text_changed(new_text):
	if Input.is_action_pressed("ui_text_backspace"): return
	match new_text:
		"inv":
			new_text = new_text.replace("inv", "inventory")
			__input_edit.text = new_text
			__input_edit.caret_column = new_text.length()


func _ready() -> void:
	__input_edit.connect("text_changed", _on_text_changed)
	scrollbar.changed.connect(handle_scrollbar_changed)
	
	create_response("Welcome to the retro text adventure! You can type 'help' to see your available commands.")
	
	var player = Player.new()
	var starting_room_response = command_processor.initialize(room_manager.get_child(0), player)
	create_response(starting_room_response)


func handle_scrollbar_changed():
	scroll.scroll_vertical = int(scrollbar.max_value)


func _on_input_text_submitted(new_text: String) -> void:
	if new_text.is_empty(): return
	
	var input_response = INPUT_RESPONSE.instantiate()
	var response = command_processor.process_command(new_text)
	#input_response.set_text(new_text, "This is where a respone would go.")
	input_response.set_text(new_text, response)
	add_respone_to_game(input_response)


func create_response(response_text):
	var response = RESPONSE.instantiate()
	response.text = response_text
	#response.text = "You find youself in a house, with no memory of how you go there. You need to find your way out. You can type 'help' to see your available commands."
	add_respone_to_game(response)

	
func add_respone_to_game(response:Control):
	history.add_child(response)
	delete_history_beyond_limit()
	

func delete_history_beyond_limit():
	if history.get_child_count() > max_lines_remembered:
		var rows_to_forget = history.get_child_count() - max_lines_remembered
		for i in range(rows_to_forget):
			history.get_child(i).queue_free()
