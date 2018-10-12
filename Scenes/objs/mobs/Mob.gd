extends KinematicBody2D

var _name
var image = null setget set_image
var groups = ["mobs"]
var speed
var dir = 0
var material_type
var clickable

var velocity = Vector2()

func set_image(img):
	image = img
	if(image != null):
		$Sprite.texture = load(image)

func _ready():
	pass

func init(e):
	e = objs.Mobs[e]
	self._name = e.name
	self.image = e.image
	self.speed = e.speed
	self.material_type = e.material_type
	self.clickable = e.clickable
	self.get_node("CollisionShape2D").get_shape().set_radius(self.get_node("Sprite").texture.get_width()/2)
	pass

func act(mode):
	pass

func end_act():
	pass

func AI():
	pass

func find_target():
	pass

func move_to_target():
	pass

func attack():
	pass