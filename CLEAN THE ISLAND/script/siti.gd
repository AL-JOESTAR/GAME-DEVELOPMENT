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
				
	# TOMBOL INTERAKSI
	if Input.is_action_just_pressed("chat") and player_in_chat_zone and not is_chatting:
		start_samsul_chat()

func start_samsul_chat():
	if dialog_node:
		# 1. KIRIM FILE JSON
		dialog_node.d_file = "res://dialogue/samsul.json"
		
		# 2. MULAI DIALOG
		print("Chatting with Samsul...")
		dialog_node.start()
		
		# 3. SET STATUS
		is_chatting = true
		is_roaming = false
		velocity = Vector2.ZERO

func _on_dialoge_selesai():
	is_chatting = false
	is_roaming = true
	print("Samsul: Dialog Selesai.")


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
