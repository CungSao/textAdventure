extends VBoxContainer

func set_text(input:String, response:String):
	$InputHistory.text = "\n > " + input
	$Response.text = response
