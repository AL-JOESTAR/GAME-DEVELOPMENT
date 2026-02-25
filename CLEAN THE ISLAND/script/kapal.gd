extends Area2D

var player_in_range = false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player_in_range = true
		print("Player entered house area")

func _on_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player_in_range = false
		print("Player exited house area")

func _process(delta):
	if player_in_range == true:
		if Input.is_action_just_pressed("open"):
			get_tree().change_scene_to_file("res://level/level5/level5.tscn")
