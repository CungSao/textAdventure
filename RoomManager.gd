extends Node

@onready var house_room:Room = $HouseRoom
@onready var outside_room:Room = $OutsideRoom
@onready var shed_room = $ShedRoom


func _ready() -> void:
	var key = Item.new("key", Types.ItemTypes.KEY)
	key.use_value = shed_room
	
	house_room.connect_exit_unlocked("east", outside_room)
	
	outside_room.add_item(key)
	outside_room.connect_exit_locked("north", shed_room)
