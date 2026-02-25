extends Control
signal dialoge_finish

@export_file("*.json") var d_file

var dialoge = []
var current_dialoge_id = 0
var d_active = false

func _ready():
	$NinePatchRect.visible = false

func start():
	if d_active:
		return
	d_active = true
	$NinePatchRect.visible = true
	dialoge = load_dialoge()
	current_dialoge_id = -1
	next_script()

func load_dialoge():
	var file = FileAccess.open("res://dialogue/samsul.json", FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content
	
func _input(event):
	if !d_active:
		return
	if event.is_action_pressed("ui_accept"):
		next_script()
	
func next_script():
	current_dialoge_id += 1
	if current_dialoge_id >= len(dialoge):
		d_active = false
		$NinePatchRect.visible = false
		emit_signal("dialoge_finish")
		return
	
	$NinePatchRect/Name.text = dialoge[current_dialoge_id]["name"]
	$NinePatchRect/Text.text = dialoge[current_dialoge_id]["text"]
	
