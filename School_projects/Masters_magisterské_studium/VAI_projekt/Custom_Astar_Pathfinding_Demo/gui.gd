extends CanvasLayer

@onready var env = $".."



func _on_button_pressed():
	env.test_function()
