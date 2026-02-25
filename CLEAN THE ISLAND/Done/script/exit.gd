extends CanvasLayer

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/main_menu.tscn")
