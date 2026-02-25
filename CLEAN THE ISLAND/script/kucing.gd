extends CharacterBody2D

@onready var ui = get_tree().root.get_node("Level5/UI5")
@onready var dialog_node = get_tree().root.get_node("Level5/UI_Canvas/dialoge3")

const speed = 25 
var current_state = IDLE
var dir = Vector2.RIGHT
var is_roaming = true
var is_chatting = false
var player_in_chat_zone = false

# Tambahkan SLEEP ke dalam daftar status (enum)
enum { IDLE, NEW_DIR, MOVE, SLEEP }

func _ready():
	randomize()
	$Timer.start()
	
	if dialog_node:
		if dialog_node.dialoge_finish.is_connected(_on_dialoge_selesai):
			dialog_node.dialoge_finish.disconnect(_on_dialoge_selesai)
		dialog_node.dialoge_finish.connect(_on_dialoge_selesai)

func _process(_delta):
	# LOGIKA ANIMASI
	if is_chatting:
		$AnimatedSprite2D.play("idle")
	elif current_state == SLEEP:
		$AnimatedSprite2D.play("sleep") # Pastikan ada animasi bernama "sleep"
	elif current_state == IDLE:
		$AnimatedSprite2D.play("idle")
	elif current_state == MOVE:
		_play_walk_anim()

	# Logika Jalan Otomatis
	if is_roaming and !is_chatting:
		_roaming_logic()
				
	if Input.is_action_just_pressed("chat") and player_in_chat_zone and not is_chatting:
		start_cat_chat()

func _roaming_logic():
	match current_state:
		NEW_DIR:
			dir = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN].pick_random()
			current_state = MOVE
		MOVE:
			velocity = dir * speed
			move_and_slide()
			if get_slide_collision_count() > 0: 
				current_state = IDLE
		SLEEP:
			velocity = Vector2.ZERO # Berhenti total saat tidur

func _play_walk_anim():
	$AnimatedSprite2D.play("walk")
	if dir.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif dir.x > 0:
		$AnimatedSprite2D.flip_h = false

func start_cat_chat():
	if dialog_node:
		# Jika kucing sedang tidur, mungkin beri dialog yang berbeda?
		if current_state == SLEEP:
			dialog_node.d_file = "res://dialogue/kucing_tidur.json"
		else:
			dialog_node.d_file = "res://dialogue/kucing.json"
			
		dialog_node.start()
		is_chatting = true
		is_roaming = false
		velocity = Vector2.ZERO

func _on_dialoge_selesai():
	is_chatting = false
	is_roaming = true

# --- TIMER UNTUK GANTI STATUS ---

func _on_timer_timeout():
	if !is_chatting:
		# Kucing punya peluang untuk Tidur, Diam, atau Jalan
		current_state = [IDLE, NEW_DIR, MOVE, SLEEP].pick_random()
		
		# Jika tidur, buat durasinya lebih lama (misal 3-5 detik)
		if current_state == SLEEP:
			$Timer.wait_time = randf_range(3.0, 5.0)
			print("Kucing sedang tidur...")
		else:
			$Timer.wait_time = randf_range(1.0, 2.5)

# --- DETEKSI AREA ---

func _on_chat_detection_area_body_entered(body):
	if body.name == "player":
		player_in_chat_zone = true
		if ui: ui.show_dialog_text()

func _on_chat_detection_area_body_exited(body):
	if body.name == "player":
		player_in_chat_zone = false
		if ui: ui.hide_dialog_text()
