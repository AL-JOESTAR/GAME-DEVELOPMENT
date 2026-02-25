extends CharacterBody2D

# Referensi ke UI dan Dialog
@onready var ui = get_tree().root.get_node("Level5/UI5")
# Ambil referensi dialog yang sudah dipindah ke CanvasLayer
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
	# Pastikan signal dari dialog_node terhubung ke fungsi di script ini
	if dialog_node:
		dialog_node.dialoge_finish.connect(_on_dialoge_3_dialoge_finish)
	
	$Timer.start()

func _process(_delta):
	# Update animasi
	if current_state == IDLE or current_state == NEW_DIR or is_chatting:
		$AnimatedSprite2D.play("idle")
	
	# Logika memulai Chat
	if Input.is_action_just_pressed("chat") and player_in_chat_zone:
		start_npc_chat()

func start_npc_chat():
	if not dialog_node:
		print("Error: Node dialog tidak ditemukan!")
		return
		
	# 1. Tentukan file JSON berdasarkan status quest
	if QuestManager.has_enough_organic_trash():
		dialog_node.d_file = "res://dialogue/pakbudi_done.json"
		is_done_dialog = true
	else:
		dialog_node.d_file = "res://dialogue/pakbudi_not_done.json"
		is_done_dialog = false
	
	# 2. Jalankan dialog
	print("NPC: Memulai chat melalui CanvasLayer")
	dialog_node.start()
	
	# 3. Kunci pergerakan NPC
	is_roaming = false
	is_chatting = true
	velocity = Vector2.ZERO # Berhenti total

func _on_chat_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player = body
		player_in_chat_zone = true
		ui.show_dialog_text()

func _on_chat_detection_area_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player_in_chat_zone = false
		player = null
		ui.hide_dialog_text()

# Fungsi ini terpanggil otomatis saat signal 'dialoge_finish' dikirim oleh Prolog1
func _on_dialoge_3_dialoge_finish() -> void:
	print("NPC: Chat selesai")
	is_chatting = false
	is_roaming = true
	
	# Logika Quest 1
	if is_done_dialog and QuestManager.current_quest == 1:
		QuestManager.complete_quest()
		is_done_dialog = false
		print("Quest Berhasil! Sekarang Quest:", QuestManager.current_quest)
