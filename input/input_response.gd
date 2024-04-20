extends MarginContainer

@onready var input_history = $Rows/InputHistory
@onready var response_label = $Rows/Response
@onready var zebra = $Zebra


func set_text(response:String, input:String = ""):
	if input == "":
		input_history.queue_free()
	else:
		input_history.text = " > " + input
	response_label.text = response
