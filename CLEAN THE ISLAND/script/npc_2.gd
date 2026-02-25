extends CharacterBody2D
@onready var ui = get_tree().root.get_node("trashhunt/UI")

const speed = 30
var current_state = IDLE
var dir = Vector2.RIGHT
var start_pos

var is_roaming = true
var is_chatting = false

var player
var player_in_chat_zone = false

enum {
	IDLE,
	NEW_DIR,
	MOVE,
}

func _ready():
	randomize()
	start_pos = position
	$Timer.start()  # Mulai timer

func _process(delta):
	# Update animasi berdasarkan state dan arah
	if current_state == IDLE or current_state == NEW_DIR:
		$AnimatedSprite2D.play("idle")
	elif current_state == MOVE and !is_chatting:
		if dir.x == -1:
			$AnimatedSprite2D.play("walk_w")
		elif dir.x == 1:
			$AnimatedSprite2D.play("walk_e")
		elif dir.y == -1:
			$AnimatedSprite2D.play("walk_n")
		elif dir.y == 1:
			$AnimatedSprite2D.play("walk_s")
	
	# Roaming logic
	if is_roaming and !is_chatting:
		match current_state:
			IDLE:
				pass
			NEW_DIR:
				dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
				current_state = MOVE  # Setelah memilih arah, langsung bergerak
			MOVE:
				move(delta)
	if Input.is_action_just_pressed("chat") and player_in_chat_zone:
		print("chat with npc")
		$dialoges.start()
		is_roaming = false
		is_chatting = true
		$AnimatedSprite2D.play("idle")

func choose(array):
	array.shuffle()
	return array.front()

func move(delta):
	if !is_chatting:
		# Set velocity dan gunakan move_and_slide()
		velocity = dir * speed
		move_and_slide()
		
		# Optional: Reset ke IDLE setelah beberapa saat bergerak
		# atau ketika menabrak sesuatu
		if get_slide_collision_count() > 0:
			current_state = IDLE

func _on_chat_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "player":  # Asumsi: player punya fungsi bernama "player"
		player = body
		player_in_chat_zone = true
		is_chatting = true  # Stop roaming saat chatting
		current_state = IDLE
		ui.show_dialog_text()

func _on_chat_detection_area_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player_in_chat_zone = false
		player = null
		is_chatting = false  # Lanjut roaming setelah selesai chatting
		ui.hide_dialog_text()

func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([0.5, 1.0, 1.5])
	
	# Hanya ubah state jika tidak sedang chatting
	if !is_chatting:
		current_state = choose([IDLE, NEW_DIR, MOVE])


func _on_dialoges_dialoge_finish() -> void:
	is_chatting = false
	is_roaming = true
