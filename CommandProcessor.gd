extends Node

var current_room = null


func initialize(starting_room):
	current_room = starting_room
	
	
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
		
	return "You go " + second_word


func help() -> String:
	return "You can use these commands: go [location], help"
