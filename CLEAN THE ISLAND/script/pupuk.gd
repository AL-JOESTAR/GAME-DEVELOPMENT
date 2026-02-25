extends Area2D

func _on_body_entered(body):
	if body.name == "player":
		print("Pupuk diambil")
		QuestManager.complete_quest()
		queue_free()
