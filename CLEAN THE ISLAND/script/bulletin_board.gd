extends Area2D

@export var quest_ui: CanvasLayer
var player_in_range := false

func _on_body_entered(body):
	if body.name == "player":
		player_in_range = true

func _on_body_exited(body):
	if body.name == "player":
		player_in_range = false
		quest_ui.visible = false

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("open"):
		quest_ui.visible = !quest_ui.visible
	#if quest_ui.visible:
		#quest_ui.update_quest_list()

#extends Area2D
#
#@export var quest_ui: CanvasLayer
#var player_in_range = false
#
#func _on_body_entered(body):
	#if body.name == "player":
		#player_in_range = true
	##quest_ui.visible = true
#
#func _on_body_exited(body):
	#if body.name == "player":
		#player_in_range = false
		#quest_ui.visible = false
#
#func _process(delta):
	#if player_in_range == true:
		#if Input.is_action_just_pressed("open"):
			#quest_ui.visible = true
#
