extends PanelContainer

class_name Room

@export var room_name = "Room Name"
@export var room_description = "This is the description of the room."

var exits:Dictionary = {}

func connect_exit(direction:String, room):
	match direction:
		'west':
			room.exits['east'] = self
		"east":
			room.exits["west"] = self
		"north":
			room.exits["south"] = self
		"south":
			room.exits["north"] = self
		"path":
			room.exits["path"] = self
		"inside":
			room.exits["outside"] = self
		"outside":
			room.exits["inside"] = self
		_:
			printerr("Tried to connect invalid direction: ", direction)
	
	exits[direction] = room
