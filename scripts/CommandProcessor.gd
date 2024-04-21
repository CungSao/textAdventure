extends Node

signal room_changed(new_room)
signal room_updated(current_room)

var current_room:Room = null
var player:Player = null


func initialize(starting_room, _player) -> String:
	player = _player
	return change_room(starting_room)
	

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
		"take", 'get':
			return take(second_word)
		'drop':
			return drop(second_word)
		"inventory":
			return inventory()
		"use":
			return use(second_word)
		"talk":
			return talk(second_word)
		"give":
			return give(second_word)
		"help":
			return help()

	return Colors.wrap_system_text("Unrecognized command - please try again.")


func go(second_word:String) -> String:
	if second_word == "":
		return Colors.wrap_system_text("Go where?")
	
	if current_room.exits.keys().has(second_word):
		var exit:Exit = current_room.exits[second_word]
		if exit.is_locked:
			return "The way " +  Colors.wrap_location_text(second_word) + " is currently " + Colors.wrap_system_text("locked!")

		var change_response = change_room(exit.get_other_room(current_room))
		return "\n".join(PackedStringArray(["You go "
		+ Colors.wrap_location_text(second_word)
		+ ".", change_response]))
	else:
		return "This room has no exit in that direction!"


func take(second_word:String) -> String:
	if second_word == "":
		return "Take what?"
	
	for item in current_room.items:
		if item.item_name.to_lower().similarity(second_word) > 0.4:
			current_room.remove_item(item)
			player.take_item(item)
			room_updated.emit(current_room)
			return "You take the " + Colors.wrap_item_text(item.item_name)
	
	return "There is no " + Colors.wrap_item_text(second_word) + " here."


func drop(second_word:String) -> String:
	if second_word == "":
		return "Drop what?"
		
	for item in player.inventory:
		if second_word.to_lower() == item.item_name.to_lower():
			current_room.add_item(item)
			player.drop_item(item)
			room_updated.emit(current_room)
			return "You drop the " + Colors.wrap_item_text(item.item_name)
	return "There don't have that item."


func inventory() -> String:
	return player.get_inventory_list()


func use(second_word:String) -> String:
	if second_word == "":
		return "Drop what?"
		
	for item in player.inventory:
		if second_word.to_lower() == item.item_name.to_lower():
			match item.item_type:
				Item.ItemTypes.KEY:
					for exit in current_room.exits.values():
						if exit == item.use_value:
							exit.is_locked = false
							player.drop_item(item)
							return "You use %s to unlock a door to %s." % [Colors.wrap_item_text(item.item_name), Colors.wrap_location_text(exit.get_other_room(current_room).room_name)]
					return "That item does not unlock any doors in this room."
				_:
					return "Error - tried to use an item with an invalid type."

	return "You don't have that item."


func talk(second_word:String) -> String:
	if second_word == "":
		return "Talk to who?"
		
	for npc in current_room.npcs:
		if npc.npc_name.to_lower().similarity(second_word) > 0.4:
			var dialog = npc.post_quest_dialog if npc.has_received_quest_item else npc.initial_dialog
			return '%s: %s' % [Colors.wrap_npc_text(npc.npc_name), Colors.wrap_speech_text('"%s"' % dialog)]
	
	return "That person does not exist in this room."


func give(second_word:String) -> String:
	if second_word == "":
		return "Give what?"
	
	var has_item = false
	for item in player.inventory:
		if item.item_name.to_lower().similarity(second_word) > 0.4:
			has_item = true
			
	if !has_item:
		return "You don't have that item."
	
	for npc in current_room.npcs:
		if npc.quest_item == null: continue
		if npc.quest_item.item_name.to_lower().similarity(second_word) > 0.4:
			npc.has_received_quest_item = true
			if npc.quest_reward != null:
				var reward = npc.quest_reward
				if "is_locked" in reward:
					reward.is_locked = false
				else:
					printerr("Warning - tried to have a quest reward type that is not implemented.")
					
			player.drop_item(npc.quest_item)
			return "You give the %s to the %s." % [second_word, npc.npc_name]

	return "No body here wants that item."


func help() -> String:
	return "\n".join( PackedStringArray([
		"You can use these commands: ",
		" go " + Colors.wrap_location_text("[location]"),
		" take/drop " + Colors.wrap_item_text("[item]"),
		" use " + Colors.wrap_item_text("[item]"),
		" talk " + Colors.wrap_npc_text("[npc]"),
		" give " + Colors.wrap_item_text("[item]"),
		" inventory",
		" help"
	]) )

###
func change_room(new_room:Room) -> String:
	current_room = new_room
	room_changed.emit(new_room)
	return new_room.get_full_description()
