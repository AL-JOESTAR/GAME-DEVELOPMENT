# plastic_trash.gd - SIMPLE VERSION
extends Node2D

@onready var ui = get_tree().root.get_node("Level2/UI2")
@onready var inventory = get_tree().root.get_node("Level2/InventoryManager2")
@onready var popup = $quiz2 # Popup di scene sampah

var player_in_range = false

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)
	
	# Connect signal dari popup
	if popup:
		popup.quiz_completed.connect(_on_quiz_completed)
		popup.hide()

func _on_body_entered(body):
	if body.name == "player2":
		player_in_range = true
		print("Player near trash")

func _on_body_exited(body):
	if body.name == "player2":
		player_in_range = false
		print("Player left trash")

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		print("Player interacting with trash")
		if inventory and inventory.items.size() >= 5:
			print("Inventory penuh! Maksimal 5 item.")
			ui.show_full_text()
			# Tampilkan pesan ke player (opsional)
			# ui.show_message("Inventory Penuh!")
			return  # Jangan ambil item
		# Tampilkan popup quiz
		if popup:
			popup.setup_quiz(
				"Kaleng bekas sebaiknya dikelola dengan cara ?",
				"Dibuang ke sungai",  # Option A
				"Daur Ulang",    # Option B
				"B"        
			)

func _on_quiz_completed(is_correct: bool):
	print("Quiz result: ", "Correct" if is_correct else "Wrong")
	print("Inventory manager: ", inventory)
	
	# DEBUG: Cek apakah inventory ada
	if inventory == null:
		print("ERROR: Inventory manager not found!")
		# Coba cari lagi
		inventory = get_tree().root.get_node("Level2/InventoryManager2")
		print("Retried inventory: ", inventory)
	
	# Tambah ke inventory jika inventory ditemukan
	if inventory:
		print("Adding item to inventory...")
		inventory.add_item("kaleng", "inorganic")
		print("Item should be added")
	else:
		print("ERROR: Cannot add item - inventory is null")
	
	# Hapus sampah dari scene
	queue_free()
