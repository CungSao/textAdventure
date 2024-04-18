@tool class_name Room extends PanelContainer

@export var room_name = "Room Name" : set = set_room_name
@export_multiline var room_description = "This is the description of the room." : set = set_room_description

var exits:Dictionary
var items:Array


func set_room_name(new_name:String):
	$MarginContainer/VBoxContainer/RoomName.text = new_name
	room_name = new_name


func set_room_description(new_description:String):
	$MarginContainer/VBoxContainer/RoomDescription.text = new_description
	room_description = new_description


func add_item(item:Item):
	items.append(item)


func remove_item(item:Item):
	items.erase(item)


func get_full_description() -> String:
	var full_description = "".join(PackedStringArray([
		"\n%s \n%s \n%s" % [
					get_room_description(),
					get_item_description(),
					get_exit_description(),
					]
	]))
	return full_description


func get_room_description() -> String:
	return "You are now in: %s. It is %s" % [room_name, room_description]
	

func get_item_description() -> String:
	if items.size() == 0:
		return "No items to pickup."
	
	var item_string = ""
	for item in items:
		item_string += item.item_name + " "
		
	return "Items: " + item_string
	

func get_exit_description() -> String:
	return "Exits: " + " ".join(exits.keys())


func connect_exit_unlocked(direction:String, room:Room, room_2_override_name = "null"):
	return _connect_exit(direction, room, false, room_2_override_name)
	

func connect_exit_locked(direction:String, room:Room, room_2_override_name = "null"):
	return _connect_exit(direction, room, true, room_2_override_name)


func _connect_exit(direction:String, room:Room, is_locked:bool, room_2_override_name = "null"):
	var exit = Exit.new()
	exit.room_1 = self
	exit.room_2 = room
	exit.is_locked = is_locked
	exits[direction] = exit

	if room_2_override_name != "null":
		room.exits[room_2_override_name] = exit
	else:
		match direction:
			'west':
				room.exits['east'] = exit
			"east":
				room.exits["west"] = exit
			"north":
				room.exits["south"] = exit
			"south":
				room.exits["north"] = exit
			"path":
				room.exits["path"] = exit
			"inside":
				room.exits["outside"] = exit
			"outside":
				room.exits["inside"] = exit
			_:
				printerr("Tried to connect invalid direction: ", direction)
	return exit
