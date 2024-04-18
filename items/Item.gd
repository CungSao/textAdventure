class_name Item extends Resource

@export var item_name = "Item Name"
@export var item_type:Types.ItemTypes = Types.ItemTypes.KEY

func _init(_item_name:String, _item_type):
	item_name = _item_name
	item_type = _item_type
