extends Area2D

var _name
export var type = "null" setget set_type
var image = null setget set_image
var groups = []
var dir = 0
#var act_anim = null
var content = null
var max_hit_points
var hit_points
var pick_up
var count
var craft_cost = [0, 0]
var damages = []
var damage_groups = []
var clickable

var velocity = Vector2()

var play_anim = false
var target = null

func set_type(value):
	type = value

func set_image(img):
	image = img
	if(image != null):
		$Sprite.texture = load(image)

func _ready():
	if type != "null":
		init(type)
		global.items.append(type)
	pass

func _physics_process(delta):
	if play_anim:
		if !$animation.is_playing():
			play_anim = false
			target.picking_up(self)
			target = null
	pass

func init(e):
	e = objs.Items[e]
	self._name = e.name
	self.image = e.image
	self.groups = e.groups
	self.pick_up = e.pick_up
	self.count = e.count
	self.get_node("CollisionShape2D").get_shape().set_extents(self.get_node("Sprite").texture.get_size()/2)
	if e.groups.has("weapons"):
		self.damage_groups = e.damage_groups
		self.damages = e.damages
		pass
	self.clickable = e.clickable
	#self.act_anim = e.act_anim
	#self.max_hit_points = e.max_hit_points
	#self.hit_points = e.max_hit_points
	pass

func _on_Item_body_entered(body):
	if body.is_in_group("player") && pick_up:
		target = body
		if count != null:
			$Label.set_text("+" + str(count))
		$Sprite.visible = false
		$animation.play("pick_up")
		play_anim = true

