extends Node2D

@onready var ui = get_tree().root.get_node("Level5/UI5")
@onready var inventory = get_tree().root.get_node("Level5/InventoryManager5")

var player_in_range = false

func _ready():
	# Masukkan ke group supaya gampang dipanggil buat muncul lagi
	add_to_group("sampah_tps") 
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	# Tambahkan pengecekan: Hanya munculkan teks pick up jika sudah Quest 4
	if (body.name == "player" or body.name == "Boat") and QuestManager.current_quest == 4:
		player_in_range = true
		ui.show_pickup_text()

func _on_body_exited(body):
	if body.name == "player" or body.name == "Boat":
		player_in_range = false
		ui.hide_pickup_text()

func _process(_delta):
	# 1. CEK APAKAH PLAYER DALAM RANGE
	# 2. CEK APAKAH TOMBOL DITEKAN
	# 3. CEK APAKAH QUEST SUDAH LEVEL 4 (WAJIB)
	if player_in_range and Input.is_action_just_pressed("interact"):
		
		# Validasi Quest: Jika belum quest 4, abaikan input
		if QuestManager.current_quest != 4:
			print("Belum saatnya mengambil sampah ini!")
			return

		# Cek kapasitas inventory
		if inventory and inventory.items.size() >= 5:
			print("Inventory penuh!")
			return
		
		# Tambahkan item ke inventory
		inventory.add_item("plastik", "inorganic")
		print("Item TPS diambil")
		
		collect_item()

func collect_item():
	visible = false
	# Matikan deteksi area supaya tidak bisa diambil lagi
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	if ui: ui.hide_pickup_text()
	player_in_range = false

func respawn_item():
	visible = true
	$Area2D/CollisionShape2D.set_deferred("disabled", false)
#extends Node2D
#@onready var ui = get_tree().root.get_node("Level5/UI5")
#@onready var inventory = get_tree().root.get_node("Level5/InventoryManager5")
#
#var player_in_range = false
#
#func _ready():
	## Masukkan ke group supaya gampang dipanggil buat muncul lagi
	#add_to_group("sampah_tps") 
	#$Area2D.body_entered.connect(_on_body_entered)
	#$Area2D.body_exited.connect(_on_body_exited)
#
#func _on_body_entered(body):
	#if body.name == "player" or body.name == "Boat" or body.name == "boat":
		#player_in_range = true
		#ui.show_pickup_text()
#
#func _on_body_exited(body):
	#if body.name == "player" or body.name == "Boat" or body.name == "boat":
		#player_in_range = false
		#ui.hide_pickup_text()
#
#func _process(_delta):
	## Hanya bisa diambil kalau quest 4 jalan
	#if player_in_range and Input.is_action_just_pressed("interact"):
		#if inventory and inventory.items.size() >= 5:
			#print("Inventory penuh!")
			#return
		#
		#inventory.add_item("plastik", "inorganic")
		#print("item diambil")
		#
		## --- JANGAN PAKAI queue_free() ---
		#collect_item()
#
#func collect_item():
	#visible = false
	## Matikan deteksi area supaya tidak bisa diambil lagi pas tidak kelihatan
	#$Area2D/CollisionShape2D.set_deferred("disabled", true)
	#ui.hide_pickup_text()
	#player_in_range = false
#
## Fungsi ini yang akan dipanggil QuestManager kalau gagal
#func respawn_item():
	#visible = true
	#$Area2D/CollisionShape2D.set_deferred("disabled", false)
