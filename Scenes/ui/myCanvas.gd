extends CanvasLayer

var bm = preload("res://Scenes/ui/BuildMenu.tscn").instance()

func _ready():
	pass

func _physics_process(delta):
	pass

func _on_ControlButton_pressed():
	global.set_pause()

func _on_Act_mode_pressed():
	change_act_mode()

func change_act_mode():
	global.act_mode += 1
	if global.act_mode >= global.act_mods_images.size():
		global.act_mode = 0
	$Act_mode.get_node("Sprite").texture = load(global.act_mods_images[global.act_mode])
	if global.act_mode != 2:
		close_act_content()

func close_act_content():
	global.canvas.get_node("BuildMenu").visible = false
	global.current_scene.get_node("Player").bm_active = false
	global.current_scene.get_node("Player").ts.visible = false
	pass

func build_mode():
	add_child(bm)
	var bc = bm.get_node("ScrollContainer/HBoxContainer")
	pass

