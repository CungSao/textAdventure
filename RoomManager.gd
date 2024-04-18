extends Node

@onready var house_room:Room = $HouseRoom
@onready var outside_room:Room = $OutsideRoom
@onready var shed_room = $ShedRoom
@onready var gate = $Gate
@onready var field = $Field


func _ready() -> void:
	var key = Item.new("key", Types.ItemTypes.KEY)
	
	house_room.connect_exit_unlocked("east", outside_room)
	
	outside_room.connect_exit_unlocked("north", gate)
	
	outside_room.add_item(key)
	var exit = outside_room.connect_exit_locked("east", shed_room)
	key.use_value = exit

	gate.connect_exit_unlocked("forest", field, "gate")	
