extends LineEdit

var a = 0


func _ready() -> void:
	grab_focus()


func _input(_event):
	if Input.is_action_just_pressed("ui_up"):
		print('len')
	elif Input.is_action_just_pressed("ui_down"):
		print('xuong')


func _on_text_submitted(_new_text: String) -> void:
	clear()
