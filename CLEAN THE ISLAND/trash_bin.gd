extends Area2D

var player_in_range = false
var trash_collected = 0
var trash_target = 5

@onready var inventory = get_tree().root.get_node("Level5/InventoryManager5")

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "player":
		player_in_range = true

func _on_body_exited(body):
	if body.name == "player":
		player_in_range = false

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):

		if inventory.items.size() == 0:
			print("Inventory kosong")
			return

		var inorganic_item = null
		
		# Cari item anorganik
		for item in inventory.items:
			if item["type"] == "inorganic":
				inorganic_item = item
				break

		if inorganic_item == null:
			print("Tidak ada sampah ANORGANIK di inventory!")
			return

		inventory.remove_item(inorganic_item)

		trash_collected += 1
		QuestManager.add_inorganic_trash()
		print("Dibuang ANORGANIK:", inorganic_item["name"], "Total:", trash_collected)
