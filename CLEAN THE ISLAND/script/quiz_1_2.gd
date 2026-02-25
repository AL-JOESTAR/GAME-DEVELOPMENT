extends Control

class_name quiz1_2

signal quiz_completed(is_correct: bool)

@onready var button_a = $NinePatchRect/HBoxContainer/A
@onready var button_b = $NinePatchRect/HBoxContainer/B
@onready var result_label = $NinePatchRect/ResultLabel

var is_answered: bool = false
var correct_answer: String = "A" 
func _ready():
	hide()
	
	# Connect signals dengan pengecekan - PASTIKAN NAMA FUNGSI BENAR
	if button_a and not button_a.pressed.is_connected(_on_button_a_pressed):
		button_a.pressed.connect(_on_button_a_pressed)
	if button_b and not button_b.pressed.is_connected(_on_button_b_pressed):
		button_b.pressed.connect(_on_button_b_pressed)
	
	setup_ui()

func setup_ui():
	# Reset button states
	if button_a:
		button_a.disabled = false
		button_a.modulate = Color.WHITE
		button_a.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button_a.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	if button_b:
		button_b.disabled = false
		button_b.modulate = Color.WHITE
		button_b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button_b.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	# Hide result label
	if result_label:
		result_label.hide()

# Fungsi setup untuk quiz susah terurai
func setup_quiz(question: String, option_a: String, option_b: String, correct: String):
	is_answered = false
	correct_answer = correct  # "A" atau "B"
	
	# Set teks pilihan
	if button_a:
		button_a.text = option_a
	if button_b:
		button_b.text = option_b
	
	# Reset UI
	setup_ui()
	
	# Show popup
	show()
	
	# Fokus ke button A
	if button_a:
		button_a.grab_focus()

func _on_button_a_pressed():
	if is_answered:
		return
	check_answer("A")

func _on_button_b_pressed():
	if is_answered:
		return
	check_answer("B")

func check_answer(player_choice: String):
	is_answered = true
	
	# Nonaktifkan button
	if button_a and button_b:
		button_a.disabled = true
		button_b.disabled = true
	
	# Tentukan benar/salah
	var is_correct = (player_choice == correct_answer)
	
	# Highlight jawaban
	if is_correct:
		if player_choice == "A" and button_a:
			button_a.modulate = Color.GREEN
		elif player_choice == "B" and button_b:
			button_b.modulate = Color.GREEN
	else:
		# Tandai jawaban salah dengan merah
		if player_choice == "A" and button_a:
			button_a.modulate = Color.RED
		elif player_choice == "B" and button_b:
			button_b.modulate = Color.RED
		
		# Tunjukkan jawaban benar dengan hijau
		if correct_answer == "A" and button_a:
			button_a.modulate = Color.GREEN
		elif correct_answer == "B" and button_b:
			button_b.modulate = Color.GREEN
	
	# Tampilkan hasil
	show_result(is_correct)
	
	# Tunggu 2 detik, lalu kirim signal dan sembunyikan
	await get_tree().create_timer(2.0).timeout
	
	quiz_completed.emit(is_correct)
	hide()

func show_result(is_correct: bool):
	if not result_label:
		return
	
	if is_correct:
		result_label.text = "✅ BENAR!"
		result_label.add_theme_color_override("font_color", Color.GREEN)
	else:
		result_label.text = "❌ SALAH"
		result_label.add_theme_color_override("font_color", Color.RED)
	
	result_label.show()

# INPUT KEYBOARD
func _input(event):
	if not visible or is_answered:
		return
	
	if event.is_action_pressed("ui_left") or event.is_action_pressed("ui_accept"):
		check_answer("A")
	elif event.is_action_pressed("ui_right") or event.is_action_pressed("ui_cancel"):
		check_answer("B")
