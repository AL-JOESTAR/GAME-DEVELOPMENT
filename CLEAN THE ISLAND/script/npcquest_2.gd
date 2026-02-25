extends CharacterBody2D

# Referensi UI dan Dialog di CanvasLayer
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
	
	# Menghubungkan signal dari dialog_node pusat
	if dialog_node:
		if not dialog_node.dialoge_finish.is_connected(_on_dialog_quest_2_dialoge_finish):
			dialog_node.dialoge_finish.connect(_on_dialog_quest_2_dialoge_finish)

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

	# LOGIKA PENGECEKAN QUEST 2
	if QuestManager.current_quest == 2:
		# Cek apakah pemain sudah membawa 2 pupuk
		if QuestManager.has_enough_pupuk(2):
			dialog_node.d_file = "res://dialogue/pakbagas_done.json"
			is_done_dialog = true
			print("Status: Pupuk cukup (Quest 2)")
		else:
			dialog_node.d_file = "res://dialogue/pakbagas_not_done.json"
			is_done_dialog = false
			print("Status: Pupuk kurang (Quest 2)")
	else:
		# Dialog default jika bukan saatnya quest 2 atau sudah selesai
		dialog_node.d_file = "res://dialogue/pakbagas_default.json" 
		is_done_dialog = false

	# Memulai Dialog via CanvasLayer
	dialog_node.start()
	is_roaming = false
	is_chatting = true
	velocity = Vector2.ZERO # Berhenti bergerak
	$AnimatedSprite2D.play("idle")

# Fungsi ini dipanggil saat signal 'dialoge_finish' dikirim oleh dialog_node
func _on_dialog_quest_2_dialoge_finish() -> void:
	print("NPC Bagas: Dialog Selesai")
	is_chatting = false
	is_roaming = true
	
	# EKSEKUSI PENYELESAIAN QUEST 2
	if is_done_dialog and QuestManager.current_quest == 2:
		QuestManager.consume_pupuk(2) # Kurangi pupuk
		QuestManager.complete_quest() # Naikkan level quest
		print("Quest 2 Berhasil Diselesaikan!")
	
	# Reset status
	is_done_dialog = false

# --- AREA DETEKSI ---
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
