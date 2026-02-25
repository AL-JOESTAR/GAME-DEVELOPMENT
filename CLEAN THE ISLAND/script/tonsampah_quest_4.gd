extends Area2D

@onready var inventory = get_tree().root.get_node("Level5/InventoryManager5")
@onready var ui = get_tree().root.get_node("Level5/UI5")

var player_in_range = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	# Pastikan nama "Boat" sesuai dengan nama node kapalmu di Scene Tree (Huruf Besar/Kecil pengaruh!)
	if body.name == "player" or body.name == "Boat" or body.name == "boat":
		player_in_range = true
		if ui: ui.show_pickup_text() # Atau show_message("Tekan E")

func _on_body_exited(body):
	if body.name == "player" or body.name == "Boat" or body.name == "boat":
		player_in_range = false
		if ui: ui.hide_pickup_text()

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		deposit_anorganic()

func deposit_anorganic():
	# Cek item dengan tipe "inorganic" (sesuai script item sampahmu)
	if inventory.has_item_by_type("inorganic"): 
		var success = inventory.remove_one_item_by_type("inorganic")
		if success:
			# PENTING: Panggil fungsi add_anorganic (bukan organic)
			QuestManager.add_anorganic_to_bin()
			print("Berhasil buang sampah anorganik!")
		else:
			print("Gagal hapus item.")
	else:
		print("Tidak ada item tipe inorganic di tas!")
