extends CharacterBody2D

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

enum { IDLE, NEW_DIR, MOVE }

func _ready():
	randomize()
	start_pos = position
	$Timer.start()
	
	# Koneksi signal agar Samsul bisa jalan lagi kalau dialog selesai
	if dialog_node:
		if dialog_node.dialoge_finish.is_connected(_on_dialoge_selesai):
			dialog_node.dialoge_finish.disconnect(_on_dialoge_selesai)
		dialog_node.dialoge_finish.connect(_on_dialoge_selesai)

func _process(delta):
	if current_state == IDLE or is_chatting:
		$AnimatedSprite2D.play("idle")
	elif current_state == MOVE and !is_chatting:
		_play_anim()

	if is_roaming and !is_chatting:
		_roaming_logic(delta)
				
	# TOMBOL INTERAKSI
	if Input.is_action_just_pressed("chat") and player_in_chat_zone and not is_chatting:
		start_samsul_chat()

func start_samsul_chat():
	if dialog_node:
		# 1. KIRIM FILE JSON
		dialog_node.d_file = "res://dialogue/maimunah.json"
		
		# 2. MULAI DIALOG
		print("Chatting with maimunah...")
		dialog_node.start()
		
		# 3. SET STATUS
		is_chatting = true
		is_roaming = false
		velocity = Vector2.ZERO

func _on_dialoge_selesai():
	is_chatting = false
	is_roaming = true
	print("maimunah: Dialog Selesai.")

# --- LOGIKA TAMBAHAN ---

func _roaming_logic(delta):
	match current_state:
		NEW_DIR:
			dir = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN].pick_random()
			current_state = MOVE
		MOVE:
			velocity = dir * speed
			move_and_slide()
			if get_slide_collision_count() > 0: current_state = IDLE

func _play_anim():
	if dir.x == -1: $AnimatedSprite2D.play("walk_w")
	elif dir.x == 1: $AnimatedSprite2D.play("walk_e")
	elif dir.y == -1: $AnimatedSprite2D.play("walk_n")
	elif dir.y == 1: $AnimatedSprite2D.play("walk_s")

func _on_chat_detection_area_body_entered(body):
	if body.name == "player":
		player_in_chat_zone = true
		if ui: ui.show_dialog_text()

func _on_chat_detection_area_body_exited(body):
	if body.name == "player":
		player_in_chat_zone = false
		if ui: ui.hide_dialog_text()

func _on_timer_timeout():
	if !is_chatting:
		current_state = [IDLE, NEW_DIR, MOVE].pick_random()
		$Timer.wait_time = randf_range(0.5, 1.5)
