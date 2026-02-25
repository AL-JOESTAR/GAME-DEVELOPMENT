extends CanvasLayer

@onready var label = $Label
var dialog = []
var index = 0

func show_dialog(new_dialog):
	dialog = new_dialog
	index = 0
	visible = true
	show_current_line()

func show_current_line():
	label.text = dialog[index]

func _process(delta):
	if visible and Input.is_action_just_pressed("interact"):
		index += 1
		if index >= dialog.size():
			visible = false
		else:
			show_current_line()
