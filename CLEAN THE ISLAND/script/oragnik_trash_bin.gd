extends Area2D

var player_in_range = false
var trash_collected = 0
var trash_target = 5
var is_composting = false

@onready var inventory = get_tree().root.get_node("Level5/InventoryManager5")
@onready var compost_timer = $CompostTimer

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	compost_timer.timeout.connect(_on_compost_finished)

func _on_body_entered(body):
	if body.name == "player":
		player_in_range = true

func _on_body_exited(body):
	if body.name == "player":
		player_in_range = false

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):

		if is_composting:
			print("⏳ Komposter sedang memproses...")
			return

		if inventory.items.size() == 0:
			print("Inventory kosong")
			return

		var organic_item = null

		# Cari item organik
		for item in inventory.items:
			if item["type"] == "organic":
				organic_item = item
				break

		if organic_item == null:
			print("Tidak ada sampah ORGANIK di inventory!")
			return

		# Buang item
		inventory.remove_item(organic_item)
		trash_collected += 1
		print("Dibuang ORGANIK:", organic_item["name"], "Total:", trash_collected)

		# Jika sudah 5 sampah → mulai kompos
		if trash_collected >= trash_target:
			start_composting()

func start_composting():
	is_composting = true
	trash_collected = 0
	print("♻️ Komposter aktif, sedang memproses...")
	compost_timer.start()

func _on_compost_finished():
	if not is_composting:
		return   # pengaman ekstra
	
	is_composting = false
	compost_timer.stop() 
	
	inventory.add_item("pupuk", "pupuk")
	print("🎉 Pupuk berhasil dibuat dan masuk inventory!")

#extends Area2D
#
#var player_in_range = false
#var trash_collected = 0
#var trash_target = 5
#
#@onready var inventory = get_tree().root.get_node("Level5/InventoryManager5")
#
#
#func _ready():
	#body_entered.connect(_on_body_entered)
	#body_exited.connect(_on_body_exited)
#
#func _on_body_entered(body):
	#if body.name == "player":
		#player_in_range = true
#
#func _on_body_exited(body):
	#if body.name == "player":
		#player_in_range = false
#
#func _process(delta):
	#if player_in_range and Input.is_action_just_pressed("interact"):
#
		#if inventory.items.size() == 0:
			#print("Inventory kosong")
			#return
#
		#var organic_item = null
#
		## Cari item organik
		#for item in inventory.items:
			#if item["type"] == "organic":
				#organic_item = item
				#break
#
		#if organic_item == null:
			#print("Tidak ada sampah ORGANIK di inventory!")
			#return
#
		## Buang item
		#inventory.remove_item(organic_item)
		#trash_collected += 1
		#print("Dibuang ORGANIK:", organic_item["name"], "Total:", trash_collected)
#
		## Cek tiap kelipatan 5
		#if trash_collected % trash_target == 0:
			#var reward_item = {
				#"name": "Komposter",
				#"type": "tool",
				#"description": "Alat baru untuk membuat pupuk"
			#}
			#inventory.add_item("pupuk", "organic") 
			#print("🎉 Kamu mendapatkan item baru:", reward_item["name"])
