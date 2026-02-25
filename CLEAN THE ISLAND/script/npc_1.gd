extends CharacterBody2D

# Referensi UI dan Dialog pusat di CanvasLayer
@onready var ui = get_tree().root.get_node("Level5/UI5")
@onready var dialog_node = get_tree().root.get_node("Level5/UI_Canvas/dialoge3")

const speed = 30
var current_state = IDLE
var dir = Vector2.RIGHT
var start_pos

var is_roaming = true
var is_chatting = false

var player
var player_in_chat_zone = false
var is_done_dialog := false

enum {
	IDLE,
	NEW_DIR,
	MOVE,
}

func _ready():
	randomize()
	start_pos = position
	$Timer.start()
	
	# Menghubungkan signal dari dialog_node di CanvasLayer
	if dialog_node:
		# Pastikan nama signal di script dialog adalah 'dialoge_finish'
		if not dialog_node.dialoge_finish.is_connected(_on_dialoges_1_dialoge_finish):
			dialog_node.dialoge_finish.connect(_on_dialoges_1_dialoge_finish)

func _process(_delta):
	# Update animasi idle saat mengobrol atau diam
	if current_state == IDLE or is_chatting:
		$AnimatedSprite2D.play("idle")
	
	# Jalankan dialog jika tombol ditekan
	if player_in_chat_zone and Input.is_action_just_pressed("chat") and not is_chatting:
		start_npc_dialog()

func start_npc_dialog():
	if not dialog_node:
		print("Error: dialoge3 tidak ditemukan di CanvasLayer!")
		return

	# LOGIKA PENGECEKAN QUEST 3 (Sampah Anorganik)
	if QuestManager.current_quest == 3:
		# Cek apakah target sampah anorganik sudah tercapai
		if QuestManager.has_enough_inorganic_trash():
			dialog_node.d_file = "res://dialogue/pakagus_done.json"
			is_done_dialog = true
			print("Status: Sampah cukup (Quest 3)")
		else:
			dialog_node.d_file = "res://dialogue/pakagus_not_done.json"
			is_done_dialog = false
			print("Status: Sampah belum cukup (Quest 3)")
	else:
		# Dialog jika bukan saatnya quest 3 atau sudah lewat
		dialog_node.d_file = "res://dialogue/pakagus_default.json" 
		is_done_dialog = false

	# Memulai Dialog via CanvasLayer
	print("NPC Agus: Memulai chat")
	dialog_node.start()
	
	is_roaming = false
	is_chatting = true
	velocity = Vector2.ZERO # Menghentikan gerakan fisik NPC
	$AnimatedSprite2D.play("idle")

# Fungsi ini dipanggil saat signal 'dialoge_finish' diterima
func _on_dialoges_1_dialoge_finish() -> void:
	print("NPC Agus: Dialog Selesai")
	is_chatting = false
	is_roaming = true
	
	# EKSEKUSI PENYELESAIAN QUEST 3
	if is_done_dialog and QuestManager.current_quest == 3:
		QuestManager.complete_quest() # Naikkan level quest ke 4
		print("Quest 3 Selesai! Sekarang Quest:", QuestManager.current_quest)
	
	# Reset status
	is_done_dialog = false

# --- AREA DETEKSI (Mendukung Player & Perahu) ---
func _on_chat_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "player" or body.name == "Boat" or body.is_in_group("collector"):
		player = body
		player_in_chat_zone = true
		if ui: ui.show_dialog_text()

func _on_chat_detection_area_body_exited(body: Node2D) -> void:
	if body == player:
		player_in_chat_zone = false
		player = null
		if ui: ui.hide_dialog_text()
