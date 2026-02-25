extends CanvasLayer
@onready var label_quest = $LabelQuest # Pastikan path node Label benar
@onready var label_timer = $LabelTimer # Node label untuk waktu

func show_pickup_text():
	$PickupLabel.text = "Tekan [E] untuk interact"
	$PickupLabel.visible = true

func hide_pickup_text():
	$PickupLabel.text = ""
	$PickupLabel.visible = false

func show_dialog_text():
	$DialogLabel.text = "Tekan [E] untuk interact npc"
	$DialogLabel.visible = true

func hide_dialog_text():
	$DialogLabel.text = ""
	$DialogLabel.visible = false

func _process(_delta):
	# UI hanya muncul jika Quest = 4 DAN sudah bicara dengan Pak RT (quest_4_started)
	if QuestManager.current_quest == 4 and QuestManager.quest_4_started:
		label_quest.visible = true
		
		var teks_tugas = "Tugas: Bersihkan TPS"
		var teks_progress = "Sampah: " + str(QuestManager.anorganic_collected) + " / 10"
		var teks_waktu = "Sisa Waktu: " + str(int(QuestManager.time_left)) + "s"
		
		# Gabungkan dengan baris baru (\n)
		label_quest.text = teks_tugas + "\n" + teks_progress + "\n\n" + teks_waktu
		
		# Opsional: Jika waktu habis, ubah warna teks jadi merah
		if QuestManager.time_left <= 0:
			label_quest.modulate = Color.RED
		else:
			label_quest.modulate = Color.WHITE
	else:
		# Sembunyikan jika belum waktunya atau quest belum dimulai
		label_quest.visible = false
