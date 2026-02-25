extends Control





func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/prolog_1.tscn")


func _on_about_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/about.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()
