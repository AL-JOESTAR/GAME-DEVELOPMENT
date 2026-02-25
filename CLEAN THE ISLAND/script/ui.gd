extends CanvasLayer

func show_pickup_text():
	$PickupLabel.text = "Tekan [E] untuk interact"
	$PickupLabel.visible = true

func hide_pickup_text():
	$PickupLabel.text = ""
	$PickupLabel.visible = false

func show_dialog_text():
	$DialogLabel.text = "Tekan [C] untuk interact npc"
	$DialogLabel.visible = true

func hide_dialog_text():
	$DialogLabel.text = ""
	$DialogLabel.visible = false
