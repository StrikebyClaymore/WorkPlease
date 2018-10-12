extends Node

var Mob = preload("res://Scenes/objs/mobs/Mob.tscn")
var Struct = preload("res://Scenes/objs/structures/Structure.tscn")
var Turf = preload("res://Scenes/objs/turfs/Turf.tscn")
var Item = preload("res://Scenes/objs/items/Item.tscn")

var Player = preload("res://Scenes/objs/mobs/Player.tscn")

var material_types = ["wood", "stone", "flesh"]

var Mobs = {
	"mob1": {
		"name": "mob1",
		"image": "res://Imgs/mob1.png",
		"speed": 60,
		"groups": ["mobs"],
		"material_type": 2,
		"clickable": true
	}
}

var Structures = {
	"oak": {
		"name": "oak",
		"image": "res://Imgs/oak.png",
		"act_anim": ["act_tree", "act_tree", "act_tree"],
		"content": "wood",
		"max_hit_points": 30,
		"can_repair": false,
		"groups": ["structs"],
		"destructible": true,
		"material_type": 0,
		"clickable" : true
	},
	"rock" : {
		"name": "rock",
		"image": "res://Imgs/rock.png",
		"act_anim": ["act_tree", "act_tree", "act_tree"],
		"content": "stone",
		"max_hit_points": 80,
		"can_repair": false,
		"groups": ["structs"],
		"destructible": true,
		"material_type": 1,
		"clickable" : true
	},
	"wooden_wall": {
		"name": "wooden_wall",
		"image": "res://Imgs/wooden_wall.png",
		"act_anim": ["act_tree", "act_tree", "act_tree"],
		"content": null,
		"max_hit_points": 40,
		"craft_cost": [20, 0, 0],
		"can_repair": true,
		"groups": ["structs", "repair"],
		"destructible": true,
		"material_type": 0,
		"clickable" : true
	},
	"stone_wall": {
		"name": "stone_wall",
		"image": "res://Imgs/stone_wall.png",
		"act_anim": ["act_tree", "act_tree", "act_tree"],
		"content": null,
		"max_hit_points": 80,
		"craft_cost": [0, 20, 0],
		"can_repair": true,
		"groups": ["structs", "repair"],
		"destructible": true,
		"material_type": 1,
		"clickable" : true
	},
	"wooden_door": {
		"name": "wooden_door",
		"image": "res://Imgs/wooden_door.png",
		"anim_image": "res://Imgs/wooden_door_open.png",
		"act_anim": ["open_door", "act_tree", "act_tree"],
		"content": null,
		"max_hit_points": 40,
		"craft_cost": [20, 0, 0],
		"can_repair": true,
		"groups": ["structs", "repair", "animate", "door"],
		"destructible": true,
		"material_type": 0,
		"clickable" : true,
		"open": false
	},
	"stone_door": {
		"name": "stone_door",
		"image": "res://Imgs/stone_door.png",
		"anim_image": "res://Imgs/stone_door_open.png",
		"act_anim": ["open_door", "act_tree", "act_tree"],
		"content": null,
		"max_hit_points": 80,
		"craft_cost": [0, 20, 0],
		"can_repair": true,
		"groups": ["structs", "repair", "animate", "door"],
		"destructible": true,
		"material_type": 1,
		"clickable" : true,
		"open": false
	}
}

var Turfs = {
	"earth_floor": {
		"name": "earth",
		"image": "res://Imgs/earth_floor.png",
	},
	"grass_floor": {
		"name": "grass",
		"image": "res://Imgs/grass_floor.png",
	},
}

var Items = {
	"wood" : {
		"name": "wood",
		"image": "res://Imgs/wood.png",
		"groups" : ["items", "resources"],
		"pick_up": true,
		"count": 10,
		"clickable" : false
	},
	"stone" : {
		"name": "stone",
		"image": "res://Imgs/stone.png",
		"groups" : ["items", "resources"],
		"pick_up": true,
		"count": 20,
		"clickable" : false
	},
	"axe": {
		"name": "axe",
		"image": "res://Imgs/axe.png",
		"groups" : ["items", "weapons"],
		"pick_up": true,
		"count": 1,
		"damage_groups": ["wood", "stone", "flesh"],
		"damages": [10, 1, 5],
		"clickable" : false
	},
	"pickaxe": {
		"name": "pickaxe",
		"image": "res://Imgs/pickaxe.png",
		"groups" : ["items", "weapons"],
		"pick_up": true,
		"count": 1,
		"damage_groups": ["wood", "stone", "flesh"],
		"damages": [1, 15, 5],
		"clickable" : false
	},
	"sword": {
		"name": "sword",
		"image": "res://Imgs/sword.png",
		"groups" : ["items", "weapons"],
		"pick_up": true,
		"count": 1,
		"damage_groups": ["wood", "flesh"],
		"damages": [5, 0, 15],
		"clickable" : false
	}
}

var Recipes = {
	"wooden_wall":{
		"add_func": "add_struct",
		"src": Structures["wooden_wall"]
	},
	"stone_wall":{
		"add_func": "add_struct",
		"src": Structures["stone_wall"]
	},
	"wooden_door":{
		"add_func": "add_struct",
		"src": Structures["wooden_door"]
	},
	"stone_door":{
		"add_func": "add_struct",
		"src": Structures["stone_door"]
	}
}

var craft_recipes = [Recipes.wooden_wall, Recipes.wooden_door, Recipes.stone_wall, Recipes.stone_door]

func add_mob(type, pos):
	global.enemyes.append(type)
	var m = Mob.instance()
	m.position = pos
	m.init(type)
	global.current_scene.add_child(m)
	pass

func add_struct(type, pos):
	global.structures.append(type)
	var s = Struct.instance()
	s.position = set_map_pos(pos)
	s.init(type)
	global.current_scene.add_child(s)
	pass

func add_floor(type, pos):
	global.turfs.append(type)
	var t = Turf.instance()
	t.position = pos
	t.init(type)
	global.current_scene.add_child(t)
	pass

func add_item(type, pos, node = null):
	global.items.append(type)
	var i = Item.instance()
	i.init(type)
	i.position = set_map_pos(pos)
	if node != null:
		node.add_child(i)
		return
	global.current_scene.add_child(i)
	pass

func create_recipe(num, img, name):
	var c = Control.new()
	var s = Sprite.new()
	var l = Label.new()
	l.set_text(str(num))
	s.texture = load(img)
	s.position += s.texture.get_size()/2
	s.set_scale(Vector2(0.9, 0.9))
	#c.rect_size = s.texture.get_size()
	c.rect_position.x = num*32
	c.name = name
	c.add_child(s)
	c.add_child(l)
	global.canvas.get_node("BuildMenu/ScrollContainer/HBoxContainer").add_child(c)
	pass

func fill_recipes():
	for i in craft_recipes.size():
		create_recipe(i, craft_recipes[i].src.image, craft_recipes[i].src.name)
		#add_item(c.name, Vector2(0, 0), )
		pass
	var c = Control.new()
	global.canvas.get_node("BuildMenu/ScrollContainer/HBoxContainer").add_child(c)
	pass

func move_recipes(dir):
	for c in global.canvas.get_node("BuildMenu/ScrollContainer/HBoxContainer").get_children():
		c.rect_position.x += dir*32
	pass

func set_map_pos(pos):
	var stepX = pos.x# - 16
	var stepY = pos.y# - 16
	for i in (stepX/32):
		stepX -= 32
	for i in (stepY/32):
		stepY -= 32
	
	stepX = abs(stepX+32)
	stepY = abs(stepY+32)
	
	if stepX < 16 and stepY <= 16:
		return pos - Vector2(stepX, stepY) + Vector2(16, 16)
	elif stepX < 16 and stepY >= 16:
		return pos - Vector2(stepX, stepY) + Vector2(16, 16)
	elif stepX >= 16 and stepY >= 16:
		return pos - Vector2(stepX, stepY) + Vector2(16, 16)
	elif stepX >= 16 and stepY <= 16:
		return pos - Vector2(stepX, stepY) + Vector2(16, 16)

func check_cost(recipe, type, obj = null):
	if type == 0:
		if Recipes[recipe].src.craft_cost[0] <= global.resoureces.wood && Recipes[recipe].src.craft_cost[1] <= global.resoureces.stone:
			return true
		else: return false
	else:
		var power = global.current_scene.get_node("Player").repair_power
		if obj.hit_points + power > obj.max_hit_points:
			power = abs(obj.max_hit_points - (obj.hit_points))
		if global.resoureces[material_types[obj.material_type]] < power/2:
			return false
		return true
	pass

func deal_repair(obj):
	var power = global.current_scene.get_node("Player").repair_power
	if obj.hit_points + power > obj.max_hit_points:
		power = abs(obj.max_hit_points - (obj.hit_points))
	global.resoureces[material_types[obj.material_type]] -= power/2
	global.update_resources()
	obj.get_node("Label").set_text("+" + str(power))
	more.my_set_color(obj.get_node("Label"), 10, 100, 20, 255)
	global.get_damage(obj, -power)
	obj.get_node("animation").play(obj.act_anim[global.act_mode])


