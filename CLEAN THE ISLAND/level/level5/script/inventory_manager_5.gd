# InventoryManager.gd (Diperbarui)
extends Node

@onready var ui_inventory = get_tree().root.get_node("Level5/InventoryUI5")

var inventory_open = false

# --------------------------
# Inventory pakai dictionary dengan texture
# --------------------------
var items: Array = []   
# Format item baru:
# {
#   "name": "botol", 
#   "type": "inorganic", 
#   "texture": "res://assets/items/botol.png"
# }

# Fungsi untuk menambah item dengan texture
func add_item(item_name: String, item_type: String, item_texture: String = ""):
	# Jika texture tidak diberikan, gunakan default berdasarkan nama
	var texture_path = item_texture
	if texture_path == "":
		texture_path = get_default_texture_path(item_name)
	
	var new_item = {
		"name": item_name,
		"type": item_type,
		"texture": texture_path
	}
	items.append(new_item)

	print("Inventory:", items)

	# Update UI kalau sedang dibuka
	if inventory_open:
		ui_inventory.show_inventory(items)

# Fungsi helper untuk mendapatkan texture default
func get_default_texture_path(item_name: String) -> String:
	match item_name:
		"apel":
			return "res://assests/collection/apple1.png"
		"pisang":
			return "res://assests/collection/pisang.png"
		"ranting":
			return "res://assests/collection/ranting1.png"
		"ranting2":
			return "res://assests/collection/ranting22.png"
		"pupuk":
			return "res://assests/collection/pupuk.png"
		"plastik":
			return "res://assests/collection/plastik.png"
		"pelastik":
			return "res://assests/collection/plastik.png"
		"botol":
			return "res://assests/collection/botollaca.png"
		"kaleng":
			return "res://assests/collection/kaleng.png"
		_:
			return "res://assets/items/default.png"

# Hapus 1 item berdasarkan dictionary
func remove_item(item) -> bool:
	if item in items:
		items.erase(item)
		print("Item dihapus:", item)

		if inventory_open:
			ui_inventory.show_inventory(items)

		return true
	return false

# Tambah item dari sampah langsung dengan texture dari Sprite2D
func add_item_from_node2d(item_node: Node2D, item_name: String, item_type: String):
	# Coba ambil texture dari Sprite2D
	var texture_path = ""
	var sprite = item_node.get_node_or_null("Sprite2D")
	
	if sprite and sprite.texture:
		# Simpan resource path jika ada
		texture_path = sprite.texture.resource_path
	else:
		# Gunakan default
		texture_path = get_default_texture_path(item_name)
	
	# Tambah ke inventory
	add_item(item_name, item_type, texture_path)

# Toggle Inventory
func _process(delta):
	if Input.is_action_just_pressed("inventory"):
		inventory_open = !inventory_open

		if inventory_open:
			ui_inventory.show_inventory(items)
		else:
			ui_inventory.hide_inventory()

# Fungsi untuk mendapatkan jumlah item tertentu
func get_item_count(item_name: String) -> int:
	var count = 0
	for item in items:
		if item["name"] == item_name:
			count += 1
	return count

# Fungsi untuk mendapatkan semua item berdasarkan type
func get_items_by_type(item_type: String) -> Array:
	var filtered_items = []
	for item in items:
		if item["type"] == item_type:
			filtered_items.append(item)
	return filtered_items
	
func has_item(item_name: String) -> bool:
	for item in items:
		if item["name"] == item_name:
			return true
	return false

func remove_item_by_name(item_name: String) -> bool:
	for i in range(items.size()):
		if items[i]["name"] == item_name:
			items.remove_at(i) # Hapus dari array
			print("Item ", item_name, " berhasil dibuang dari tas.")
			
			# Update UI jika sedang terbuka
			if inventory_open:
				ui_inventory.show_inventory(items)
			return true
	return false
	
func remove_one_item_by_type(target_type: String) -> bool:
	for i in range(items.size()):
		if items[i]["type"] == target_type:
			var item_name = items[i]["name"]
			items.remove_at(i)
			print("Item tipe ", target_type, " (", item_name, ") berhasil dibuang.")
			if inventory_open: ui_inventory.show_inventory(items)
			return true
	return false
	
# Tambahkan ini di InventoryManager.gd

func has_item_by_type(target_type: String) -> bool:
	for item in items:
		if item["type"] == target_type:
			return true
	return false
#extends Node
#
#@onready var ui_inventory = get_tree().root.get_node("trashhunt/InventoryUI")
#
#var inventory_open = false
#
## --------------------------
## Inventory pakai dictionary
## --------------------------
#var items: Array = []   
## Contoh data item:
## { "name": "buah", "type": "organic" }
#
## Tambah item ke inventory
#func add_item(item_name: String, item_type: String):
	#var new_item = {
		#"name": item_name,
		#"type": item_type
	#}
	#items.append(new_item)
#
	#print("Inventory:", items)
#
	## Update UI kalau sedang dibuka
	#if inventory_open:
		#ui_inventory.show_inventory(items)
#
## Hapus 1 item berdasarkan dictionary
#func remove_item(item) -> bool:
	#if item in items:
		#items.erase(item)
		#print("Item dihapus:", item)
#
		#if inventory_open:
			#ui_inventory.show_inventory(items)
#
		#return true
	#return false
#
#
## Toggle Inventory
#func _process(delta):
	#if Input.is_action_just_pressed("inventory"):
		#inventory_open = !inventory_open
#
		#if inventory_open:
			#ui_inventory.show_inventory(items)
		#else:
			#ui_inventory.hide_inventory()
