extends Control

func _on_lanjut_pressed() -> void:
	get_tree().change_scene_to_file("res://level/level2/Level2.tscn")


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/main_menu.tscn")
