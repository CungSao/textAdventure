extends PanelContainer

@export var room_name_path:NodePath
@export var room_description_path:NodePath

@export var exit_path:NodePath
@export var npc_path:NodePath
@export var item_path:NodePath

@onready var room_name = get_node(room_name_path)
@onready var room_description = get_node(room_description_path)
@onready var exit_label = get_node(exit_path)
@onready var npc_label = get_node(npc_path)
@onready var item_label = get_node(item_path)


func handle_room_changed(new_room:Room):
	room_name.text = new_room.room_name
	room_description.text = new_room.room_description

	exit_label.text = new_room.get_exit_description()
	
	var npc_string = new_room.get_npc_description()
	if npc_string == "":
		npc_label.hide()
	else:
		npc_label.show()
		npc_label.text = npc_string
	
	var item_string = new_room.get_item_description()
	if item_string == "":
		item_label.hide()
	else:
		item_label.show()
		item_label.text = item_string


func handle_room_updated(current_room):
	handle_room_changed(current_room)
