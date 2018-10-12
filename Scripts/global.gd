extends Node

var timer

var current_scene = null

var main_menu = preload("res://scenes/StartMenu.tscn")
var world = preload("res://scenes/world.tscn")
var pause_menu = preload("res://Scenes/ui/pause_menu.tscn")
var myCanvas = preload("res://Scenes/ui/myCanvas.tscn")

var mutex = Mutex.new()
var mutex_selection = Mutex.new()
var locked = false

var timer_lock = true
var timer_node
var timer_func

var canvas

var act_mode = 1
var act_mods_images = ["res://Imgs/mode_0.png", "res://Imgs/mode_1.png", "res://Imgs/mode_2.png"]

var enemyes = []
var structures = []
var turfs = []
var items = []

var character_types = ["Woodcutter", "Mason", "Warrior"]
var character_type = 0
var character_colors_name = ["Blue", "Pink"]
var character_colors = ["res://Imgs/player.png", "res://Imgs/playerPink.png"]
var character_color = 0

var time_of_day = "day"
var day_time = 180
var night_time = 120
var day_count = 0

var resoureces = { wood = 40, stone = 20, soul = 0}

var player_types = {
	"woodcutter": {
		"start_weapon": "axe",
		"effects": ["big_tree_damage", "not_stone_damage"]
	},
	"mason": {
		"start_weapon": "pickaxe",
		"effects": ["big_stone_damage", "weak_tree_damage"]
	},
	"warrior": {
		"start_weapon": "sword",
		"effects": ["weak_tree_damage", "not_stone_damage"]
	}
}

func _ready():
	randomize()
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func get_damage(target, dmg):
	target.hit_points -= dmg
	if target.hit_points < 0:
		target.hit_points = 0
	elif target.hit_points > target.max_hit_points:
		target.hit_points = target.max_hit_points
	if target.get_node("hp") != null:
		target.get_node("hp").value = target.hit_points
	pass

func damage_type_definition(target, dmgs):
	if current_scene.get_node("Player").active_item.damage_groups.has(objs.material_types[target.material_type]):
		return current_scene.get_node("Player").damages[target.material_type]
	else:
		return 0
	pass

func update_resources():
	canvas.get_node("Resources/wood/Label").set_text(str(global.resoureces.wood))
	canvas.get_node("Resources/stone/Label").set_text(str(global.resoureces.stone))
	canvas.get_node("Resources/soul/Label").set_text(str(global.resoureces.soul))
	pass

func goto_scene(scene):
	call_deferred("_deferred_goto_scene", scene)

func _deferred_goto_scene(scene):
	# Immediately free the current scene,
	# there is no risk here.
	current_scene.free()
	# Load new scene
	#var scene = ResourceLoader.load(path)
	# Instance the new scene
	current_scene = scene.instance()
	# Add it to the active scene, as child of root
	get_tree().get_root().add_child(current_scene)
	# optional, to make it compatible with the SceneTree.change_scene() API
	get_tree().set_current_scene(current_scene)

func set_pause():
	canvas.get_node("Pause").selected = false
	canvas.get_node("Pause").visible = false
	var menu = global.pause_menu.instance()
	canvas.add_child(menu)
	get_tree().set_pause(true)

signal unselect_all()

func lock():
	mutex.lock()
	if locked:
		mutex.unlock()
		return false
	else:
		locked = true
		mutex.unlock()
		return true

func unlock():
	mutex.lock()
	locked = false
	mutex.unlock()

func add_timer(node, time, f = null):
	timer = Timer.new()
	timer.set_wait_time(time)
	timer.set_one_shot(true)
	timer.connect("timeout", self, "on_timeout_complete")
	node.add_child(timer)
	#timer_node = node
	#timer_func = f
	timer.start()

func on_timeout_complete():
	if timer_func == null:
		if timer_lock:
			timer_lock = false
			timer.queue_free()
			add_timer(current_scene, 0.2)
		elif !timer_lock:
			timer_lock = true
	#else:
		#timer_node.call(timer_func, 0)
		#pass
	#timer_node = null
	#timer_func = null

func set_weapon(player):
	if character_type == 0:
		player.active_item = objs.Items["axe"]
	elif character_type == 1:
		player.active_item = objs.Items["pickaxe"]
	else:
		player.active_item = objs.Items["sword"]
	canvas.get_node("Active_item/Item").texture = load(player.active_item.image)
	pass
