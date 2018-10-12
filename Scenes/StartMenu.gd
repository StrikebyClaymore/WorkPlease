extends Node2D

var game_menu = preload("res://Scenes/ui/GameMenu.tscn")
var gm = null

func _ready():
	#OS.set_window_maximized(true)
	#OS.set_window_fullscreen(true)
	pass

func _on_Start_pressed():
	set_charecter()

func _on_Exit_pressed():
	get_tree().quit()

func set_charecter():
	get_node("Start").queue_free()
	get_node("Exit").queue_free()
	gm = game_menu.instance()
	add_child(gm)
	pass
