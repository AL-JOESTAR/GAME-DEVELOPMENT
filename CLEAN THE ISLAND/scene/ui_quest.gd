extends CanvasLayer

@onready var list = $Panel/VBoxContainer
var organic_trash_count := 0

func _ready():
	visible = false
	update_quest_list()

func update_quest_list():
	for i in range(list.get_child_count()):
		var label = list.get_child(i)
		var quest_id = i + 1
		
		if quest_id < QuestManager.current_quest:
			label.text = "✅ " + QuestManager.quests[i]["name"]
		elif quest_id == QuestManager.current_quest:
			label.text = "▶ " + QuestManager.quests[i]["name"]
		else:
			label.text = "🔒 " + QuestManager.quests[i]["name"]
