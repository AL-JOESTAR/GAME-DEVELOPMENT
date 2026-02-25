extends Control

# Signal untuk memberitahu sistem bahwa prolog sudah berakhir
signal dialoge_finish

# Export variabel agar bisa memilih file JSON langsung dari Inspector
@export_file("*.json") var d_file: String
# Path ke scene level pertama setelah prolog selesai
@export_file("*.tscn") var next_scene_path: String

var dialoge = []
var current_dialoge_id = 0
var d_active = false

func _ready():
	# Sembunyikan UI saat awal
	
	# Hubungkan signal diri sendiri ke fungsi perpindahan scene
	self.dialoge_finish.connect(_on_dialoge_finish)
	
	# Mulai prolog secara otomatis
	start()

func start():
	if d_active:
		return
	
	# Load data dari file JSON
	dialoge = load_dialoge()
	
	if dialoge.size() > 0:
		d_active = true
		$NinePatchRect.visible = true
		current_dialoge_id = -1
		next_script()
	else:
		print("Peringatan: Data dialog kosong atau file tidak ditemukan!")

func load_dialoge():
	# Pastikan file ada sebelum dibuka
	if d_file == "" or not FileAccess.file_exists(d_file):
		print("Error: Path file dialog kosong atau tidak valid!")
		return []
		
	var file = FileAccess.open(d_file, FileAccess.READ)
	var json_string = file.get_as_text()
	var data = JSON.parse_string(json_string)
	
	if data == null:
		print("Error: Gagal memproses JSON (Format salah)!")
		return []
		
	return data

func _input(event):
	if not d_active:
		return
		# Cara yang benar untuk mengecek input keyboard ATAU klik mouse
	var is_keyboard_confirm = event.is_action_pressed("ui_accept")
	var is_mouse_confirm = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	
	if is_keyboard_confirm or is_mouse_confirm:
		# Gunakan get_viewport().set_input_as_handled() agar input tidak tembus ke sistem lain
		get_viewport().set_input_as_handled()
		next_script()

func next_script():
	current_dialoge_id += 1
	
	# Jika id sudah melebihi jumlah dialog, maka selesai
	if current_dialoge_id >= dialoge.size():
		finish_prolog()
		return
	
	# Update teks Nama dan Isi Dialog
	# Pastikan key "name" dan "text" sesuai dengan isi file JSON Anda
	$NinePatchRect/Name.text = dialoge[current_dialoge_id].get("name", "Unknown")
	$NinePatchRect/Text.text = dialoge[current_dialoge_id].get("text", "...")
	
	$NinePatchRect/Text.visible_ratio = 0.0
	var duration = $NinePatchRect/Text.text.length() * 0.015
	var tween = create_tween()
	tween.tween_property($NinePatchRect/Text, "visible_ratio", 1.0, duration).set_trans(Tween.TRANS_LINEAR)
func finish_prolog():
	d_active = false
	$NinePatchRect.visible = false
	print("Prolog selesai, mengirim signal...")
	emit_signal("dialoge_finish")

func _on_dialoge_finish():
	# Berpindah ke level selanjutnya
	if next_scene_path != "":
		get_tree().change_scene_to_file(next_scene_path)
	else:
		print("Error: Next scene path belum diisi di Inspector!")
