extends Node2D
@onready var ui = get_tree().root.get_node("Level5/UI5")
@onready var inventory = get_tree().root.get_node("Level5/InventoryManager5")

var player_in_range = false

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "player" or body.name == "boat":
		player_in_range = true
		ui.show_pickup_text()  # Muncul tulisan

func _on_body_exited(body):
	if body.name == "player" or body.name == "boat":
		player_in_range = false
		ui.hide_pickup_text()  # Hilang tulisan

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		if inventory and inventory.items.size() >= 5:
			print("Inventory penuh!")
			return
		inventory.add_item("kaleng", "inorganic")  # masukkan ke inventory
		print("item diambil")
		ui.hide_pickup_text()
		queue_free()

func collect():
	queue_free()

func _exit_tree():
	# Dipanggil saat sampah hilang dari scene
	if QuestManager.current_quest == 5:
		QuestManager.check_trash_left()
