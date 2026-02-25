extends Control

signal dialoge_finish

@export_file("*.json") var d_file: String
@export_file("*.tscn") var next_scene_path: String

var dialoge = []
var current_dialoge_id = 0
var d_active = false

func _ready():
	start()

func start():
	if d_active: return
	dialoge = load_dialoge()
	
	if dialoge.size() > 0:
		d_active = true
		$NinePatchRect.visible = true
		current_dialoge_id = -1
		next_script()

func load_dialoge():
	if d_file == "" or not FileAccess.file_exists(d_file):
		return []
	var file = FileAccess.open(d_file, FileAccess.READ)
	return JSON.parse_string(file.get_as_text())

func _input(event):
	# Jika d_active false, semua klik layar/keyboard diabaikan
	if not d_active:
		return
	
	var is_keyboard_confirm = event.is_action_pressed("ui_accept")
	var is_mouse_confirm = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	
	if is_keyboard_confirm or is_mouse_confirm:
		# Jika sedang klik tombol Back, jangan jalankan script dialog
		if _is_mouse_over_button():
			return
			
		get_viewport().set_input_as_handled()
		next_script()

func _is_mouse_over_button() -> bool:
	if has_node("Button"): 
		return get_node("Button").get_global_rect().has_point(get_global_mouse_position())
	return false

func next_script():
	current_dialoge_id += 1
	
	# --- BAGIAN PENTING ---
	# Cek apakah ini adalah baris dialog TERAKHIR
	if current_dialoge_id >= dialoge.size():
		# Matikan d_active agar klik di layar tidak berfungsi lagi
		d_active = false 
		print("Dialog habis. Input layar dimatikan. Silakan tekan tombol Back.")
		# Kita tidak memanggil finish_prolog() otomatis agar tidak pindah scene sendiri
		return
	
	# Update Teks
	$NinePatchRect/Name.text = dialoge[current_dialoge_id].get("name", "Unknown")
	$NinePatchRect/Text.text = dialoge[current_dialoge_id].get("text", "...")
	
	# Animasi Teks
	$NinePatchRect/Text.visible_ratio = 0.0
	var duration = $NinePatchRect/Text.text.length() * 0.03
	var tween = create_tween()
	tween.tween_property($NinePatchRect/Text, "visible_ratio", 1.0, duration)

# Fungsi ini sekarang hanya dipanggil oleh tombol atau event khusus
func finish_prolog():
	$NinePatchRect.visible = false
	emit_signal("dialoge_finish")
	if next_scene_path != null and next_scene_path != "":
		get_tree().change_scene_to_file(next_scene_path)

# TOMBOL BACK (Satu-satunya jalan keluar)
func _on_button_pressed() -> void:
	print("Menutup scene melalui tombol Back...")
	get_tree().change_scene_to_file("res://scene/main_menu.tscn")
