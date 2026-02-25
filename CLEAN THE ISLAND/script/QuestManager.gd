extends Node

var current_quest := 1# quest 1
var organic_trash_count := 0 # quest 1\
#==============================================
var inorganic_trash_count := 0 # quest 3
const INORGANIC_TARGET := 5 # quest 3
#==============================================
var anorganic_collected := 0 # quest 4
var total_target := 5 # quest 4
var time_left = 100.0
var timer_active = false
var quest_4_started = false
#================================================
var game_finished := false

var quests = [
	{ "name": "Sampah Organik", "desc": "Ambil sampah organik" },
	{ "name": "Membuat pupuk", "desc": "Olah sampah jadi pupuk" },
	{ "name": "Sampah Anorganik", "desc": "Bersihkan laut dengan perahu" },
	{ "name": "TPS Ilegal", "desc": "Bersihkan TPS sebelum waktu habis" },
	{ "name": "Restorasi", "desc": "Pulihkan pulau dengan pupuk" }
]
#===============================================================================
# Quest 4
#===============================================================================
func _process(delta):
	if timer_active:
		time_left -= delta
		if time_left <= 0:
			quest_failed()

func start_quest_4_timer():
	time_left = 15.0
	timer_active = true
	quest_4_started = true # <--- Tandai bahwa quest sudah dimulai
	anorganic_collected = 0
	print("Waktu dimulai! 15 detik lagi!")

func add_anorganic_to_bin():
	#if not timer_active: return # Jangan hitung kalau waktu belum mulai/sudah habis
	
	anorganic_collected += 1
	print("LOG DEBUG: Sampah masuk! Total: ", anorganic_collected) # Cek Output
	if anorganic_collected >= total_target:
		timer_active = false
		complete_quest()
		print("MENANG! Quest 4 Selesai tepat waktu!")

func quest_failed():
	timer_active = false
	quest_4_started = false # Sembunyikan UI
	print("WAKTU HABIS! Mengembalikan sampah...")
	
	# 1. Reset angka hitungan
	anorganic_collected = 0
	
	# 2. Panggil semua sampah yang tadi disembunyikan
	var semua_sampah = get_tree().get_nodes_in_group("sampah_tps")
	for sampah in semua_sampah:
		if sampah.has_method("respawn_item"):
			sampah.respawn_item()
			
	# 3. Kosongkan inventory player dari sampah anorganik (biar adil)
	var inv = get_tree().root.get_node("Level5/InventoryManager5")
	if inv:
		# Hapus semua sampah plastik di tas supaya mulai dari nol lagi
		while inv.has_item_by_type("inorganic"):
			inv.remove_one_item_by_type("inorganic")
#============================================================================================

func complete_quest():
	if current_quest < quests.size():
		current_quest += 1
		print("Quest lanjut ke:", quests[current_quest - 1]["name"])

func has_enough_organic_trash() -> bool:
	return organic_trash_count >= 5

func add_inorganic_trash():
	inorganic_trash_count += 1
	print("Progress anorganik:", inorganic_trash_count, "/", INORGANIC_TARGET)

func has_enough_inorganic_trash() -> bool:
	return inorganic_trash_count >= INORGANIC_TARGET

func has_enough_pupuk(amount := 2) -> bool:
	var inventory = get_tree().root.get_node("Level5/InventoryManager5")
	var count := 0

	for item in inventory.items:
		if item["name"] == "pupuk":
			count += 1
	
	return count >= amount

func consume_pupuk(amount := 2):
	var inventory = get_tree().root.get_node("Level5/InventoryManager5")
	var removed := 0

	for item in inventory.items.duplicate():
		if item["name"] == "pupuk" and removed < amount:
			inventory.remove_item(item)
			removed += 1

#=====================================================================
# Quest 5
#=====================================================================
func check_trash_left():
	await get_tree().process_frame
	var trash_left = get_tree().get_nodes_in_group("trash").size()
	print("Sisa sampah:", trash_left)

	if trash_left <= 0:
		finish_game()

func finish_game():
	if game_finished:
		return
	game_finished = true
	print("🎉 GAME SELESAI!")
	get_tree().change_scene_to_file("res://scene/epilog.tscn")
