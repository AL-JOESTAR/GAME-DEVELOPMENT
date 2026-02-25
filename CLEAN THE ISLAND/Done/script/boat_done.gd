extends CharacterBody2D

const SPEED = 250.0
@onready var player_ui: AnimatedSprite2D = $AnimatedSprite2D

@export var inv: Inv
@export var player: CharacterBody2D
var is_player_near = false
var is_driving = false
@onready var camera_node := get_tree().root.get_node("trashhunt/Camera2D")
var is_at_dock = false # Kapal lagi di dermaga gak?
var last_direction = "down"

# 1. TAMBAHKAN INI: Fungsi agar saat start, kapal tidak jalan
func _ready():
	#self.visible = false  # Kapal tidak kelihatan di awal sesuai request
	set_physics_process(false) # Mematikan fungsi _physics_process di awal
	is_driving = false
	player_ui.play("empty")

func _physics_process(delta: float) -> void:
	# Kode ini hanya akan jalan kalau set_physics_process(true) dipanggil
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	velocity = input_vector * SPEED
	move_and_slide()

	# --- Logic Animasi (Tetap sama seperti punyamu) ---
	update_animation(input_vector)

func _input(event):
	if Input.is_action_just_pressed("chat"): 
		if is_player_near and not is_driving:
			enter_boat()
		elif is_driving and is_at_dock: # <--- SYARAT HARUS DI DERMAGA
			exit_boat()
		elif is_driving and not is_at_dock:
			print("Cari dermaga dulu buat turun!")

func enter_boat():
	if player == null: return
	is_driving = true
	player.visible = false
	# Mematikan total proses pada player (input & physics)
	player.process_mode = Node.PROCESS_MODE_DISABLED 
	
	if camera_node:
		camera_node.target = self
	
	player.global_position = self.global_position
	#self.global_position = player.global_position 
	
	# 2. AKTIFKAN pergerakan kapal
	set_physics_process(true) 

func exit_boat():
	is_driving = false
	# 3. MATIKAN pergerakan kapal saat turun
	set_physics_process(false) 
	
	player.visible = true
	player.process_mode = Node.PROCESS_MODE_INHERIT 
	#player.global_position = self.global_position 
	player.global_position = self.global_position + Vector2(-40, 0)
	player_ui.play("empty")
	if camera_node:
		camera_node.target = player
	
	self.visible = true 

# Fungsi bantu agar kode lebih rapi
func update_animation(input_vector):
	if input_vector.length() > 0:
		if abs(input_vector.x) > abs(input_vector.y):
			if input_vector.x > 0:
				player_ui.play("walk_e")
				last_direction = "right"
			else:
				player_ui.play("walk_w")
				last_direction = "left"
		else:
			if input_vector.y > 0:
				player_ui.play("walk_s")
				last_direction = "down"
			else:
				player_ui.play("walk_n")
				last_direction = "up"
	else:
		match last_direction:
			"right": player_ui.play("idle_right")
			"left": player_ui.play("idle_left")
			"up": player_ui.play("idle_up")
			"down": player_ui.play("idle_down")

# Signal Area2D (Pastikan sudah di-connect di editor)
func _on_boatinteraction_body_entered(body: Node2D) -> void:
	print("Ada objek masuk area: ", body.name) # Ini akan muncul di panel Output
	if body.name == "player":
		is_player_near = true
		print("PLAYER TERDETEKSI! Siap interact.")
	else:
		print("Itu bukan player, itu adalah: ", body.name)

func _on_boatinteraction_body_exited(body: Node2D) -> void:
	if body == player:
		is_player_near = false


func _on_boatinteraction_area_entered(area: Area2D) -> void:
	if area.is_in_group("dock"):
		is_at_dock = true


func _on_boatinteraction_area_exited(area: Area2D) -> void:
	if area.is_in_group("dock"):
		is_at_dock = false
