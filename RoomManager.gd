extends Node

@onready var house_room:Room = $HouseRoom
@onready var outside_room:Room = $OutsideRoom
@onready var shed_room:Room = $ShedRoom
@onready var gate:Room = $Gate
@onready var field:Room = $Field


func _ready() -> void:
	var innkeeper = load_npc("Innkeeper")
	house_room.add_npc(innkeeper)
	house_room.connect_exit_unlocked("east", outside_room)
	
	outside_room.connect_exit_unlocked("north", gate)
	
	var exit = outside_room.connect_exit_locked("east", shed_room)
	var key = load_item("InnKitchenKey")
	outside_room.add_item(key)
	key.use_value = exit

	var sword = load_item("GuardSword")
	shed_room.add_item(sword)
	
	exit = gate.connect_exit_locked("forest", field, "gate")
	var guard = load_npc("Guard")
	gate.add_npc(guard)
	guard.quest_reward = exit
	

func load_item(item_name:String):
	return load("res://items/%s.tres" % item_name)

func load_npc(npc_name:String):
	return load("res://npcs/%s.tres" % npc_name)
