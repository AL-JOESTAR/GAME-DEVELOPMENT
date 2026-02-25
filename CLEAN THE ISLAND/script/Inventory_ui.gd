# InventoryUI.gd (Diperbarui)
extends CanvasLayer

@onready var panel = $Panel
@onready var list_container = $Panel/VBoxContainer
@onready var grid_container = $Panel/GridContainer  # Ganti dengan GridContainer untuk gambar

func _ready():
	# Pastikan GridContainer ada
	if not grid_container:
		# Buat GridContainer jika belum ada
		var new_grid = GridContainer.new()
		new_grid.name = "GridContainer"
		new_grid.columns = 4  # 4 item per baris
		new_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		new_grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
		$Panel.add_child(new_grid)
		grid_container = new_grid
	
	# Sembunyikan awalnya
	visible = false

func show_inventory(items):
	visible = true
	
	# Bersihkan isi GridContainer
	for child in grid_container.get_children():
		child.queue_free()
	
	# Jika tidak ada item, tampilkan pesan
	if items.size() == 0:
		var label = Label.new()
		label.text = "Inventory kosong"
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		grid_container.add_child(label)
		return
	
	# Isi ulang UI dengan gambar
	for item in items:
		var item_container = create_item_display(item)
		grid_container.add_child(item_container)

func create_item_display(item_data: Dictionary) -> VBoxContainer:
	# Buat container untuk setiap item
	var container = VBoxContainer.new()
	container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	container.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	container.alignment = BoxContainer.ALIGNMENT_CENTER
	
	# Buat TextureRect untuk gambar
	var texture_rect = TextureRect.new()
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture_rect.custom_minimum_size = Vector2(64, 64)  # Ukuran gambar
	
	# Load texture
	if ResourceLoader.exists(item_data["texture"]):
		var texture = load(item_data["texture"])
		texture_rect.texture = texture
	else:
		# Gunakan placeholder jika texture tidak ditemukan
		texture_rect.texture = preload("res://assests/collection/chatbox.png")
	
	# Buat label untuk nama item
	#var label = Label.new()
	#label.text = item_data["name"].capitalize()
	#label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	#label.add_theme_font_size_override("font_size", 12)
	#
	## Warna berdasarkan type
	#match item_data["type"]:
		#"organic":
			#label.add_theme_color_override("font_color", Color.GREEN)
		#"inorganic":
			#label.add_theme_color_override("font_color", Color.YELLOW)
	
	# Tambahkan ke container
	container.add_child(texture_rect)
	#container.add_child(label)
	
	# Optional: Tambahkan tooltip
	container.tooltip_text = item_data["name"] + " (" + item_data["type"] + ")"
	
	return container

func hide_inventory():
	visible = false

# Alternatif: Layout dengan HFlowContainer (lebih fleksibel)
func setup_hflow_layout():
	# Hapus grid container jika ada
	if grid_container:
		grid_container.queue_free()
	
	# Buat HFlowContainer
	var hflow = HFlowContainer.new()
	hflow.name = "HFlowContainer"
	hflow.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hflow.size_flags_vertical = Control.SIZE_EXPAND_FILL
	$Panel.add_child(hflow)
	
	return hflow
#extends CanvasLayer
#
#@onready var panel = $Panel
#@onready var list_container = $Panel/VBoxContainer
#
#func show_inventory(items):
	#visible = true
#
	## bersihkan isi UI
	#for child in list_container.get_children():
		#child.queue_free()
#
	## isi ulang UI berdasarkan inventory (hanya nama item)
	#for item in items:
		#var label = Label.new()
		#label.text = item["name"]  # ambil hanya nama item
		#list_container.add_child(label)
#
#func hide_inventory():
	#visible = false
