extends Control

class_name ClassificationPopup

signal classification_completed(item_name: String, category: String, is_correct: bool)

#@onready var question_label = $NinePatchRect/QuestionLabel
@onready var organic_button = $NinePatchRect/HBoxContainer/OrganicButton
@onready var inorganic_button = $NinePatchRect/HBoxContainer/InorganicButton
@onready var result_label = $ResultLabel

var current_trash_name: String = ""
var correct_category: String = ""
var is_answered: bool = false

func _ready():
	hide()
	
	# Connect signals
	#if organic_button:
		#organic_button.pressed.connect(_on_organic_button_pressed)
	#if inorganic_button:
#s		inorganic_button.pressed.connect(_on_inorganic_button_pressed)
	
	setup_ui()

func setup_ui():
	# Setup button text
	if organic_button:
		#organic_button.text = "ORGANIK"
		organic_button.disabled = false
	if inorganic_button:
		#inorganic_button.text = "ANORGANIK"
		inorganic_button.disabled = false
	
	# Hide result label initially
	if result_label:
		result_label.hide()

func setup(trash_name: String, category: String):
	current_trash_name = trash_name
	correct_category = category
	is_answered = false
	
	# Update question
	#if question_label:
		#question_label.text = "TERMASUK APAKAH SAMPAH INI?"
	
	# Reset buttons
	if organic_button and inorganic_button:
		organic_button.disabled = false
		inorganic_button.disabled = false
		organic_button.modulate = Color.WHITE
		inorganic_button.modulate = Color.WHITE
	
	# Reset result
	if result_label:
		result_label.hide()
		result_label.text = ""
	
	# Show popup
	show()
	
	# Fokus ke organic button
	if organic_button:
		organic_button.grab_focus()

func _on_organic_button_pressed():
	if is_answered:
		return
	check_answer("organic")

func _on_inorganic_button_pressed():
	if is_answered:
		return
	check_answer("inorganic")

func check_answer(player_choice: String):
	is_answered = true
	
	# Nonaktifkan button
	if organic_button and inorganic_button:
		organic_button.disabled = true
		inorganic_button.disabled = true
	
	# Tentukan benar/salah
	var is_correct = (player_choice == correct_category)
	
	# Tampilkan hasil
	show_result(is_correct)
	
	# Tunggu 1.5 detik, lalu kirim signal dan sembunyikan popup
	await get_tree().create_timer(1.5).timeout
	
	classification_completed.emit(current_trash_name, correct_category, is_correct)
	hide()

func show_result(is_correct: bool):
	if not result_label:
		return
	
	if is_correct:
		result_label.text = "✅ PINTARR!"
		result_label.add_theme_color_override("font_color", Color.GREEN)
	else:
		result_label.text = "❌ IQ 70"
		result_label.add_theme_color_override("font_color", Color.RED)
	
	result_label.show()

# INPUT KEYBOARD ALTERNATIVE - PASTI BISA
func _input(event):
	if not visible or is_answered:
		return
	
	# Gunakan keyboard jika mouse tidak berfungsi
	if event.is_action_pressed("ui_left") or event.is_action_pressed("ui_accept"):
		# Tombol kiri atau Enter = pilih organik
		check_answer("organic")
	elif event.is_action_pressed("ui_right") or event.is_action_pressed("ui_cancel"):
		# Tombol kanan atau Escape = pilih anorganik
		check_answer("inorganic")
