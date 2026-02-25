# LevelPortalSimple.gd
extends Area2D

@export var next_scene: String = "res://scene/levelcomplete.tscn"
@export var required_trash: int = 5

var player_in_range = false

func _ready():
	# Tambahkan ke group "level_portals"
	add_to_group("level_portals")
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Cek kondisi awal
	check_trash_condition()

func _on_body_entered(body):
	if body.name == "player":
		player_in_range = true
		show_hint()

func _on_body_exited(body):
	if body.name == "player":
		player_in_range = false
		hide_hint()

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		if is_condition_met():
			print("Portal aktif! Pindah ke:", next_scene)
			
			# Efek sebelum pindah (optional)
			play_portal_effect()
			
			# Tunggu sebentar untuk efek
			await get_tree().create_timer(0.5).timeout
			
			# Pindah scene
			get_tree().change_scene_to_file(next_scene)
		else:
			var current_trash = get_total_trash_collected()
			var needed = required_trash - current_trash
			print("Portal terkunci! Butuh {needed} sampah lagi.")
			
			# Tampilkan feedback
			show_message("Butuh {needed} sampah lagi!")

func check_trash_condition():
	var current_trash = get_total_trash_collected()
	var is_unlocked = current_trash >= required_trash
	
	# Update visual berdasarkan kondisi
	update_visual(is_unlocked)
	
	return is_unlocked

func is_condition_met() -> bool:
	return get_total_trash_collected() >= required_trash

func get_total_trash_collected() -> int:
	var total = 0
	
	# Cari semua trash bin di scene
	var trash_bins = get_tree().get_nodes_in_group("trash_bins")
	for trash_bin in trash_bins:
		if trash_bin.has_method("get_trash_collected"):
			total += trash_bin.get_trash_collected()
	
	return total

func update_visual(is_unlocked: bool):
	if is_unlocked:
		# Portal terbuka
		if has_node("Sprite2D"):
			$Sprite2D.modulate = Color.GREEN
		if has_node("LockSprite"):
			$LockSprite.hide()
		if has_node("Particles2D"):
			$Particles2D.emitting = true
	else:
		# Portal terkunci
		if has_node("Sprite2D"):
			$Sprite2D.modulate = Color.RED
		if has_node("LockSprite"):
			$LockSprite.show()
		if has_node("Particles2D"):
			$Particles2D.emitting = false

func show_hint():
	if has_node("HintLabel"):
		$HintLabel.visible = true
		$HintLabel.text = "Tekan E"

func hide_hint():
	if has_node("HintLabel"):
		$HintLabel.visible = false

func play_portal_effect():
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("portal_open")
	if has_node("AudioStreamPlayer2D"):
		$AudioStreamPlayer2D.play()

func show_message(text: String):
	# Tampilkan pesan sementara
	var msg = Label.new()
	msg.text = text
	msg.position = Vector2(-50, -30)
	msg.add_theme_font_size_override("font_size", 16)
	msg.add_theme_color_override("font_color", Color.YELLOW)
	add_child(msg)
	
	await get_tree().create_timer(2.0).timeout
	msg.queue_free()
