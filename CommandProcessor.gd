extends Node

signal response_generated(response_text)

var current_room = null


func initialize(starting_room):
	change_room(starting_room)
	
	
func process_command(input:String) -> String:
	#first_word:String, second_word:String
	var words = input.split(" ", false)
	if words.size() == 0:
		return "Error: no words were parsed."
	
	var first_word = words[0].to_lower()
	var second_word = ""
	if words.size() > 1:
		second_word = words[1].to_lower()
		
	match first_word:
		"go":
			return go(second_word)
		"help":
			return help()

	return "Unrecognized command - please try again."


func go(second_word:String) -> String:
	if second_word == "":
		return "Go where?"
	
	if current_room.exits.keys().has(second_word):
		change_room(current_room.exits[second_word])
		return "You go " + second_word
	else:
		return "This room has no exit in that direction!"

func help() -> String:
	return "You can use these commands: go [location], help"


func change_room(new_room:Room):
	current_room = new_room
	var exit_string = PackedStringArray(new_room.exits.keys())
	var strings = PackedStringArray([
		"\nYou are now in: %s. It is %s
		Exits: %s " % [
				new_room.room_name,
				new_room.room_description,
				"".join(exit_string)
			]
	])
	emit_signal("response_generated", "".join(strings))
