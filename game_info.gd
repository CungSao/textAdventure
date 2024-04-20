extends PanelContainer

const INPUT_RESPONSE = preload("res://input/input_response.tscn")

@export var max_lines_remembered = 30
var should_zebra = false

@export var path_history: NodePath
@export var path_scroll: NodePath

@onready var scroll: ScrollContainer = get_node(path_scroll)
@onready var scrollbar: VScrollBar = scroll.get_v_scroll_bar()
@onready var history: VBoxContainer = get_node(path_history)

func _ready():
	scrollbar.changed.connect(_handle_scrollbar_changed)


### PUBLIC ###
func create_response(response_text:String):
	var response = INPUT_RESPONSE.instantiate()
	_add_respone_to_game(response)
	response.set_text(response_text)
	#response.text = "You find youself in a house, with no memory of how you go there. You need to find your way out. You can type 'help' to see your available commands."


func create_response_with_input(response_text:String, input_text:String):
	var input_response = INPUT_RESPONSE.instantiate()
	_add_respone_to_game(input_response)
	input_response.set_text(response_text, input_text)
	

### PRIVATE ###
func _handle_scrollbar_changed():
	scroll.scroll_vertical = int(scrollbar.max_value)


func _add_respone_to_game(response:Control):
	history.add_child(response)
	if !should_zebra:
		response.zebra.hide()
	should_zebra = !should_zebra
	_delete_history_beyond_limit()


func _delete_history_beyond_limit():
	if history.get_child_count() > max_lines_remembered:
		var rows_to_forget = history.get_child_count() - max_lines_remembered
		for i in range(rows_to_forget):
			history.get_child(i).queue_free()
