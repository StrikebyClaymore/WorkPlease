extends StaticBody2D

var _name
export var type = "null" setget set_type
var image = null setget set_image
var anim_image
var groups = []
var dir = 0
var act_anim = null
var content = null
var max_hit_points
var hit_points
var can_repair = false
var material_type
var destructible
var clickable
var open

var velocity = Vector2()

func set_type(value):
	type = value

func set_image(img):
	image = img
	if(image != null):
		$Sprite.texture = load(image)

func _ready():
	if type != "null":
		init(type)
		global.structures.append(type)
	pass

func init(e):
	e = objs.Structures[e]
	self._name = e.name
	self.image = e.image
	self.get_node("CollisionShape2D").get_shape().set_extents(self.get_node("Sprite").texture.get_size()/2)
	self.act_anim = e.act_anim
	if e.content != null:
		self.content = e.content
	self.max_hit_points = e.max_hit_points
	self.hit_points = e.max_hit_points
	$hp.max_value = self.max_hit_points
	$hp.value = self.hit_points
	self.can_repair = e.can_repair
	self.groups = e.groups
	self.destructible = e.destructible
	self.material_type = e.material_type
	self.clickable = e.clickable
	if e.groups.has("animate"):
		self.anim_image = e.anim_image
	if e.groups.has("door"):
		self.open = e.open
	pass

func act(act_type):
	if act_type == 0:
		if groups.has("door"):
			if !open:
				open = true
				$Sprite.texture = load(anim_image)
				$animation.play(self.act_anim[0])
				add_collision_exception_with(global.current_scene.get_node("Player"))
			else:
				open = false
				$animation.play_backwards(self.act_anim[0])
				remove_collision_exception_with(global.current_scene.get_node("Player"))
		pass
	elif act_type == 1:
		var damage = global.damage_type_definition(self, global.current_scene.get_node("Player").damages)
		if damage <= 0:
			return
		more.my_set_color($Label, 255, 0, 0, 255)
		$Label.set_text("-" + str(damage))
		global.get_damage(self, damage)
		get_node("animation").play(self.act_anim[act_type])
	else:
		if  self.can_repair && objs.check_cost(objs.Recipes[self._name], 1, self) && hit_points != max_hit_points:
			objs.deal_repair(self)

func end_act():
	if hit_points <= 0:
		destruction(0)

func destruction(type):
	if type == 0: # 0 is chopping
		drop_content()
		queue_free()
	pass

func drop_content():
	if content != null:
		var c = objs.Item.instance()
		c.init(content)
		c.position = global_position
		global.current_scene.add_child(c)