extends Node2D

var selected = false
var lock = false

onready var ChangeType = get_node("ChangeType")
onready var ChangeColor = get_node("ChangeColor")

func _ready():
	get_node("PlayerType").set_text(global.character_types[global.character_type])
	get_node("PlayerColor").set_text(global.character_colors_name[global.character_color])
	pass

func _on_Continue_pressed():
	global.goto_scene(global.world)

func _on_ChangeType_input_event(viewport, event, shape_idx):
	if !lock && Input.is_action_pressed("left_click"):
		lock = false
		$Timer.start()
		global.character_type += 1
		if global.character_type >= global.character_types.size():
			global.character_type = 0
		get_node("PlayerType").set_text(global.character_types[global.character_type])
func _on_ChangeType_mouse_entered():
	ChangeType.get_node("SpriteSelected").visible = true
	ChangeType.get_node("Sprite").visible = false
func _on_ChangeType_mouse_exited():
	ChangeType.get_node("Sprite").visible = true
	ChangeType.get_node("SpriteSelected").visible = false

func _on_ChangeColor_input_event(viewport, event, shape_idx):
	if !lock && Input.is_action_pressed("left_click"):
		lock = false
		$Timer.start()
		global.character_color += 1
		if global.character_color >= global.character_colors.size():
			global.character_color = 0
		get_node("PlayerColor").set_text(global.character_colors_name[global.character_color])
func _on_ChangeColor_mouse_entered():
	ChangeColor.get_node("SpriteSelected").visible = true
	ChangeColor.get_node("Sprite").visible = false
func _on_ChangeColor_mouse_exited():
	ChangeColor.get_node("Sprite").visible = true
	ChangeColor.get_node("SpriteSelected").visible = false

func _on_Timer_timeout():
	lock = false
