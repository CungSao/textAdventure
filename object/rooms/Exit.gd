class_name Exit extends Resource

var room_1:Room = null
var room_2:Room = null
var is_locked = false

func get_other_room(current_room):
	if current_room == room_1:
		return room_2
	elif current_room == room_2:
		return room_1
	else:
		printerr("The room")
		return null
