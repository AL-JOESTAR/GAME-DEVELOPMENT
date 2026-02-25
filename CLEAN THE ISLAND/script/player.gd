extends CharacterBody2D

const SPEED = 100.0
@onready var player_ui: AnimatedSprite2D = $AnimatedSprite2D
var npc_target = null

@export var inv: Inv

# Tambah saja variabel ini
var last_direction = "down"

func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO

	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	velocity = input_vector * SPEED
	move_and_slide()

	# Update animasi
	if input_vector.length() > 0:
		# Sedang bergerak
		if abs(input_vector.x) > abs(input_vector.y):
			# Horizontal
			if input_vector.x > 0:
				player_ui.play("walk_e")
				last_direction = "right"
			else:
				player_ui.play("walk_w")  # atau run_left jika ada
				last_direction = "left"
		else:
			# Vertical
			if input_vector.y > 0:
				player_ui.play("walk_s")
				last_direction = "down"
			else:
				player_ui.play("walk_n")
				last_direction = "up"
	else:
		# Diam
		match last_direction:
			"right":
				player_ui.play("idle_right")
			"left":
				player_ui.play("idle_left")  # flip untuk kiri
			"up":
				player_ui.play("idle_up")
			"down":
				player_ui.play("idle_down")
			_:
				player_ui.play("idle")

# Fungsi untuk memberikan sampah ke komposter
func give_organic_to_composter():
	var trash_bin = get_tree().get_nodes_in_group("composter")
	if trash_bin.size() > 0:
		var bin = trash_bin[0]
		bin.start_compost()
#extends CharacterBody2D
#
#const SPEED = 200.0
#@onready var player_ui: AnimatedSprite2D = $AnimatedSprite2D
#@onready var dialog_ui = get_tree().root.get_node("trashhunt/DialogUI") # sesuaikan pathnya
#var npc_target = null
#
#@export var inv: Inv
#
#func _physics_process(delta: float) -> void:
	#var input_vector = Vector2.ZERO
#
	## Ambil input arah (atas, bawah, kiri, kanan)
	#input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	#input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
#
	## Normalisasi biar diagonal nggak lebih cepat
	#input_vector = input_vector.normalized()
#
	## Gerakkan player
	#velocity = input_vector * SPEED
	#move_and_slide()
#
	## Atur animasi sesuai arah
	#if input_vector == Vector2.ZERO:
		#player_ui.play("idle")
	#else:
		#player_ui.play("run")
#
	## Balik badan sesuai arah horizontal
		#if input_vector.x < 0:
			#player_ui.flip_h = true   # Menghadap kiri
		#elif input_vector.x > 0:
			#player_ui.flip_h = false  # Menghadap kanan
	#
#func _process(delta):
	#if Input.is_action_just_pressed("interact") and npc_target != null:
		#dialog_ui.show_dialog(npc_target.dialog)
		#
#func _on_body_entered(body):
	#if body.is_in_group("npc"):
		#npc_target = body
#
#func _on_body_exited(body):
	#if body.is_in_group("npc"):
		#npc_target = null
#
	#if Input.is_action_just_pressed("interact"):
		#if dialog_ui.is_visible_in_tree():
			#dialog_ui.next_line()
	#elif npc_target != null:
		#dialog_ui.show_dialog(npc_target.dialog)
		#
