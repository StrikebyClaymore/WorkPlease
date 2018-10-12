extends Node

var basic_tile_size = 32

var width = 960/basic_tile_size
var height = 640/basic_tile_size

var offset = 16

# # # none - 0, earth - 1, grass - 2 # # #
var map = []
var zones = []

func _ready():
	randomize(true)

func fill_arrays():
	for y in height:
		for x in width:
			map.append(0)
	pass

func gen_floors():
	fill_arrays()
	for z in more.int_rand(1, 3):
		var zone = {size = {}, pos = {}}
		var size = { x = more.int_rand(5, 10), y = more.int_rand(5, 10) }
		var this = { x = more.int_rand(0, width-size.x)*32, y = more.int_rand(0, height-size.y)*32, start_pos = { x = 0, y = 0 } }
		var vec = objs.set_map_pos(Vector2(this.x, this.y))
		this.start_pos.x = this.x 
		this.start_pos.y = this.y
		zone.size = size
		zone.pos = this
		for a in size.y:
			for b in size.x:
				if more.int_rand(1, 10) > 2 && map[(this.y/32)*width + this.x/32] == 0:
					objs.add_floor("earth_floor", Vector2(this.x+16, this.y+16))
					if more.int_rand(1, 10) > 2 && Vector2(this.x+16, this.y+16).distance_to(global.current_scene.get_node("Player").position) > 64:
						objs.add_struct("rock",  Vector2(this.x+16, this.y+16))
					map.remove((this.y/32)*width + this.x/32)
					map.insert((this.y/32)*width + this.x/32, 1)
				elif map[(this.y/32)*width + this.x/32] == 0:
					objs.add_floor("grass_floor", Vector2(this.x+16, this.y+16))
					map.remove((this.y/32)*width + this.x/32)
					map.insert((this.y/32)*width + this.x/32, 2)
				this.x += 32
			this.y += 32
			this.x = this.start_pos.x
		zones.append(zone)
	gen_trees()
	pass

func gen_trees():
	var this = { x = 0, y = 0}
	for y in height:
		for x in width:
			if map[(this.y/32)*width + this.x/32] == 0:
				objs.add_floor("grass_floor", objs.set_map_pos(Vector2(this.x+offset, this.y+offset)))
				map.remove((this.y/32)*width + this.x/32)
				map.insert((this.y/32)*width + this.x/32, 2)
			if map[(this.y/32)*width + this.x/32] == 2 && more.int_rand(1, 10) > 7 && Vector2(this.x+offset, this.y+offset).distance_to(global.current_scene.get_node("Player").position) > 64:
				objs.add_struct("oak", objs.set_map_pos(Vector2(this.x+offset, this.y+offset)))
			this.x += 32
		this.y += 32
		this.x = 0
	pass