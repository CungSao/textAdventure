extends Node

var inventory:Array


func take_item(item:Item):
	inventory.append(item)


func drop_item(item:Item):
	inventory.erase(item)
	

func get_inventory_list() -> String:
	if inventory.size() == 0:
		return "You don't currently have anything."
	
	var item_string = ""
	for i in inventory:
		item_string += i.item_name + " "
		
	return "Invetory: " + item_string
	
