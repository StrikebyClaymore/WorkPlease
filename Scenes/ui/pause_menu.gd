extends Control

func _ready():
	#rect_position
	rect_position = OS.get_screen_size()/2 - get_node("ColorRect").get_size()/2 + Vector2(32, -32)
	global.add_timer(self, 0.2)
	pass

func _physics_process(delta):
	if Input.is_action_pressed("ui_cancel"):
		if get_tree().is_paused() && !global.timer_lock:
			get_tree().set_pause(false)
			global.canvas.get_node("Pause").visible = true
			#global.canvas.get_node("Pause").set_collision_size()
			queue_free()
	pass

func _on_Back_pressed():
	global.goto_scene(global.main_menu)
	get_tree().set_pause(false)
	

func _on_Return_pressed():
	get_tree().set_pause(false)
	global.canvas.get_node("Pause").visible = true
	#global.canvas.get_node("Pause").set_collision_size()
	queue_free()