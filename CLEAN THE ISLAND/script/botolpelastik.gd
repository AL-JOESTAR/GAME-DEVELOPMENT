extends Node2D
@onready var ui = get_tree().root.get_node("Level2/UI2")
@onready var inventory = get_tree().root.get_node("Level2/InventoryManager2")

var player_in_range = false

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "player2":
		player_in_range = true
		ui.show_pickup_text()  # Muncul tulisan

func _on_body_exited(body):
	if body.name == "player2":
		player_in_range = false
		ui.hide_pickup_text()
		ui.hide_full_text()  # Hilang tulisan

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		# CEK APAKAH INVENTORY PENUH SEBELUM MENAMBAH
		if inventory and inventory.items.size() >= 5:
			print("Inventory penuh! Maksimal 5 item.")
			ui.show_full_text()
			# Tampilkan pesan ke player (opsional)
			# ui.show_message("Inventory Penuh!")
			return  # Jangan ambil item
		
		# Tambah item ke inventory
		inventory.add_item("botol", "inorganic")
		print("item diambil")
		print("Total inventory: ", inventory.items.size(), "/5")
		
		ui.hide_pickup_text()
		queue_free()
#extends Node2D
#@onready var ui = get_tree().root.get_node("Level2/UI2")
#@onready var inventory = get_tree().root.get_node("Level2/InventoryManager2")
#
#var player_in_range = false
#
#func _ready():
	#$Area2D.body_entered.connect(_on_body_entered)
	#$Area2D.body_exited.connect(_on_body_exited)
#
#func _on_body_entered(body):
	#if body.name == "player2":
		#player_in_range = true
		#ui.show_pickup_text()  # Muncul tulisan
#
#func _on_body_exited(body):
	#if body.name == "player2":
		#player_in_range = false
		#ui.hide_pickup_text()  # Hilang tulisan
#
#func _process(_delta):
	#if player_in_range and Input.is_action_just_pressed("interact"):
		#inventory.add_item("plastik", "inorganic")  # masukkan ke inventory
		#print("item diambil")
		#ui.hide_pickup_text()
		#queue_free()
