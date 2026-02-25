extends Camera2D

# Variabel target inilah yang akan kita ganti-ganti lewat script Boat
var target: Node2D

func _ready():
	# Saat game mulai, cari Player secara otomatis
	# Pastikan nama node di Scene Tree adalah "Player" (sesuaikan huruf besar/kecilnya)
	var initial_target = get_parent().get_node("player")
	if initial_target:
		target = initial_target

func _process(_delta):
	if target:
		# Kamera mengikuti posisi global target setiap frame
		global_position = target.global_position
