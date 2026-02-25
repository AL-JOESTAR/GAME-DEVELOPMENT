extends CharacterBody2D

# Cari UI secara dinamis
@onready var ui = get_tree().root.find_child("UI5", true, false)
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
var is_start_quest_4 := false

enum { IDLE, NEW_DIR, MOVE }

func _ready():
	randomize()
	start_pos = position
	$Timer2.start()
	
	# Hubungkan signal dari dialog_node yang ada di CanvasLayer
	if dialog_node:
		# Pastikan nama signal di script dialog adalah 'dialoge_finish'
		if not dialog_node.dialoge_finish.is_connected(_on_dialoge_3_dialoge_finish):
			dialog_node.dialoge_finish.connect(_on_dialoge_3_dialoge_finish)

func _process(_delta):
	# Mulai dialog jika tombol ditekan
	if player_in_chat_zone and Input.is_action_just_pressed("chat") and not is_chatting:
		start_npc_dialog()

func start_npc_dialog():
	if not dialog_node:
		print("Error: dialoge3 tidak ditemukan di CanvasLayer!")
		return

	# LOGIKA PEMILIHAN FILE DIALOG (QUEST 4)
	if QuestManager.current_quest == 4:
		if QuestManager.timer_active:
			# Jika sedang dalam proses mengumpulkan (timer sudah jalan)
			dialog_node.d_file = "res://dialogue/pakrt_remind.json"
			is_start_quest_4 = false
		else:
			# Jika baru pertama kali bicara untuk mulai quest
			dialog_node.d_file = "res://dialogue/pakrt_start_quest.json"
			is_start_quest_4 = true
	
	elif QuestManager.current_quest > 4:
		# Jika quest sudah selesai
		dialog_node.d_file = "res://dialogue/pakrt_done.json"
		is_start_quest_4 = false
	
	else:
		# Jika quest belum sampai level 4
		dialog_node.d_file = "res://dialogue/pakrt_default.json"
		is_start_quest_4 = false
	
	# MEMULAI DIALOG
	print("NPC: Memulai dialog Quest 4")
	dialog_node.start()
	
	# Mengunci NPC
	is_roaming = false
	is_chatting = true
	velocity = Vector2.ZERO
	$AnimatedSprite2D.play("idle")

# Fungsi ini terpanggil saat signal 'dialoge_finish' diterima dari CanvasLayer
func _on_dialoge_3_dialoge_finish() -> void:
	print("NPC: Dialog selesai")
	is_chatting = false
	is_roaming = true
	
	# JIKA DIALOG MULAI QUEST SELESAI, TIMER DIMULAI!
	if is_start_quest_4:
		QuestManager.start_quest_4_timer()
		is_start_quest_4 = false # Reset agar tidak terpancing dua kali

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
