extends KinematicBody2D

var mob_name
var groups = ["mobs"]
var speed = 100
var damages
var repair_power = 5
var dir = 0
var vec_dir = Vector2(0, -1)
var attack_dir = Vector2(0, -1)
var act_range = 48
var velocity = Vector2()
var move_target_pos = Vector2()
var act_lock = false
var act_target = null
var build_lock = []
var effects = []
var clickable = false

var active_item = null

var keys_pressed = []
var keys_lock = {
	"ui_r": false,
	"ui_a": false,
	"ui_d": false,
	"ui_focus_next": false,
	"ui_space": false
}
var key_timers = {
	"ui_r": null,
	"ui_a": null,
	"ui_d": null,
	"ui_focus_next": null,
	"ui_space": null
}

var bm_pos = 0
var bm_active = false

var act_scene = preload("res://Scenes/ui/act_zone.tscn")
var player_act = null

var bm = null # build_menu
var ts = null # tile selected

func _ready():
	global.canvas = global.myCanvas.instance()
	add_child(global.canvas)
	get_node("Sprite").texture = load(global.character_colors[global.character_color])
	bm = global.canvas.get_node("BuildMenu")
	create_ts()
	global.set_weapon(self)
	damages = active_item.damages

func _physics_process(delta):
	changing_act_mode()
	scroll_build_menu()
	accept_recipe()
	if Input.is_action_pressed("ui_cancel"):
		if !get_tree().is_paused() && global.timer_lock:
			global.set_pause()
	if Input.is_action_pressed("left_click") && !act_lock:
		act_lock = true
		act()
	if Input.is_action_pressed("right_click"):
		move_target_pos = get_global_mouse_position()
		velocity = move_target_pos - position
	move(velocity)

func move(vec):
	if velocity.x >= 0:
		if position.x > move_target_pos.x:
			velocity = Vector2(0, 0)
			move_target_pos = Vector2(0, 0)
	else:
		if position.x < move_target_pos.x:
			velocity = Vector2(0, 0)
			move_target_pos = Vector2(0, 0)
	if is_on_wall():
		velocity = Vector2(0, 0)
	look_at(get_global_mouse_position())
	if velocity != Vector2(0, 0):
		define_dir(0)
	define_dir(1)
	bm_tile_selected_move()
	move_and_slide(vec.normalized()*speed)

func act():
	var a = act_scene.instance()
	a.init(global.act_mode)
	#print(position.angle_to_point(position + Vector2(32, 32)))
	#print(a.global_position.angle_to(get_global_mouse_position()))
	player_act = a
	if global.act_mode == 1:
		a.set_rotation_degrees(get_rotation_degrees() + 90)
		a.global_position = $Position2D.global_position
	else:
		a.global_position = get_global_mouse_position()
	a.get_node("animation").play(a.current_anim)
	a.connect("body_entered", self, "_on_act_zone_body_entered")
	global.current_scene.add_child(a)
	"""
	if act_target != null:
		if global.act_mode == 0:
			act_target.act(0)
		elif global.act_mode == 1:
			act_target.act(1)
		else:
			pass
	"""
	pass

func interact():
	pass

func _on_act_zone_body_entered(body):
	if act_target == null && self.global_position.distance_to(body.global_position) <= act_range && body.clickable:
		act_lock = true
		act_target = body
		player_act.connect("deleted", act_target, "end_act")
		body.act(global.act_mode)
	pass

func picking_up(obj):
	if obj.count != null:
		global.resoureces[obj._name] += obj.count
	obj.queue_free()
	global.update_resources()
	pass

func changing_act_mode():
	if Input.is_action_pressed("ui_focus_next") && !keys_lock.ui_focus_next:
		global.canvas.change_act_mode()
		add_key_timer("ui_focus_next")

func scroll_build_menu():
	if global.act_mode == 2 && Input.is_action_pressed("ui_r") && !keys_lock.ui_r:
		if !global.canvas.get_node("BuildMenu").visible:
			global.canvas.get_node("BuildMenu").visible = true
			bm_active = true
			bm_pos = 0
			ts.visible = true
			bm_change_pos(0)
			add_key_timer("ui_r")
		else:
			global.canvas.get_node("BuildMenu").visible = false
			bm_active = false
			ts.visible = false
			add_key_timer("ui_r")
	if bm_active && global.act_mode == 2 && Input.is_action_pressed("ui_d") && !keys_lock.ui_d:
		bm_change_pos(1)
		add_key_timer("ui_d")
	if bm_active && global.act_mode == 2 && Input.is_action_pressed("ui_a") && !keys_lock.ui_a:
		bm_change_pos(-1)
		add_key_timer("ui_a")
	pass

func accept_recipe():
	if build_lock.empty() && bm_active && global.act_mode == 2 && Input.is_action_pressed("ui_space") && !keys_lock.ui_space:
		for c in  global.canvas.get_node("BuildMenu/ScrollContainer/HBoxContainer").get_children():
			if c.rect_position == bm.get_node("Selected").rect_position && objs.check_cost(more.clear_node_name(c.name), 0):
				objs.call(objs.Recipes[more.clear_node_name(c.name)].add_func, more.clear_node_name(c.name), ts.global_position)
				global.resoureces.wood -= objs.Recipes[more.clear_node_name(c.name)].src.craft_cost[0]
				global.resoureces.stone -= objs.Recipes[more.clear_node_name(c.name)].src.craft_cost[1]
				global.update_resources()
				bm.get_node("Recipe_name").set_text(more.clear_node_name(c.name))
		add_key_timer("ui_space")
		pass
	pass

func bm_change_pos(i):
	if (bm_pos == -2 && i == -1) or (bm_pos == objs.craft_recipes.size()-3 && i == 1):
		return
	#var select = bm.get_node("Selected")
	bm_pos += i
	objs.move_recipes(-i)
	bm_set_recipe_name()
	pass

func bm_set_recipe_name():
	for c in  global.canvas.get_node("BuildMenu/ScrollContainer/HBoxContainer").get_children():
		if c.rect_position == bm.get_node("Selected").rect_position:
			bm.get_node("Recipe_name").set_text(more.clear_node_name(c.name))

func bm_tile_selected_move():
	if bm_active:
		#get_node("Tile_selected").rect_global_position = objs.set_map_pos(position) - Vector2(16, 16) + vec_dir*32
		ts.global_position = objs.set_map_pos(position) + attack_dir*32
	pass
		# ^^^
func create_ts():
	ts = preload("res://Scenes/ui/Tile_selected.tscn").instance()
	ts.position = position
	ts.visible = false
	global.current_scene.add_child(ts)
	ts.connect("body_entered", self, "_on_Tile_selected_body_entered")
	ts.connect("body_exited", self, "_on_Tile_selected_body_exited")
	pass

func ts_process():
	if ts.is_colliding():
		pass
	pass

func _on_Tile_selected_body_entered(body):
	if body.groups.has("structs"):
		build_lock.append(body)
	pass

func _on_Tile_selected_body_exited(body):
	if body.groups.has("structs"):
		build_lock.remove(build_lock.find(body))
	pass


func add_key_timer(key):
	keys_lock[key] = true
	var t = Timer.new()
	t.set_wait_time(0.2)
	t.set_one_shot(true)
	t.connect("timeout", self, "keys_timer_out")
	add_child(t)
	key_timers[key] = t
	keys_pressed.append(key)
	t.start()

func keys_timer_out():
	keys_lock[keys_pressed[0]] = false
	key_timers[keys_pressed[0]].queue_free()
	keys_pressed.pop_front()
	pass

func define_dir(type):
	if type == 0:
		if velocity.y < 0:
			if velocity.x >= 0:
				if abs(velocity.x) > abs(velocity.y):
					dir = 1
					vec_dir = Vector2(1, 0)
				else:
					dir = 0
					vec_dir = Vector2(0, -1)
			if velocity.x < 0:
				if abs(velocity.x) > abs(velocity.y):
					dir = 3
					vec_dir = Vector2(-1, 0)
				else:
					dir = 0
					vec_dir = Vector2(0, -1)
		else:
			if velocity.x >= 0:
				if abs(velocity.x) > abs(velocity.y):
					dir = 1
					vec_dir = Vector2(1, 0)
				else:
					dir = 2
					vec_dir = Vector2(0, 1)
			if velocity.x < 0:
				if abs(velocity.x) > abs(velocity.y):
					dir = 3
					vec_dir = Vector2(-1, 0)
				else:
					dir = 2
					vec_dir = Vector2(0, 1)
	else:
		var ang = get_rotation_degrees()
		if ang >= -135 && ang <= -45:
			attack_dir = Vector2(0, -1)
		elif  ang > -45 && ang < 45:
			attack_dir = Vector2(1, 0)
		elif  ang >= 45 && ang <= 135:
			attack_dir = Vector2(0, 1)
		else:
			attack_dir = Vector2(-1, 0)

