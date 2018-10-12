extends Control

func _ready():
	$Sprite.texture = load(global.act_mods_images[global.act_mode])
	pass

signal pressed()

func _on_Act_mode_gui_input(ev):
	if Input.is_action_pressed("left_click"):
		emit_signal("pressed")
