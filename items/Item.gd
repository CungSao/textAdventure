class_name Item extends Resource

enum ItemTypes {
	KEY,
	QUEST_ITEM
}

@export var item_name = "Item Name"
@export var item_type:ItemTypes = ItemTypes.KEY

var use_value = null
