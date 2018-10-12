extends Node2D

func _ready():
	my_init()
	pass

func my_init():
	start_mobs_create()
	gen.gen_floors()
	global.timer_lock = true
	global.update_resources()
	objs.fill_recipes()
	pass

func start_mobs_create():
	var mob = objs.Player.instance()
	mob.position = Vector2(256, 256)
	global.current_scene.add_child(mob)
	
	objs.add_mob("mob1", Vector2(128, 128))
	
	pass