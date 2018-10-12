extends Area2D

var _name
export var type = "null" setget set_type
var image = null setget set_image
var group = "turfs"
var dir = 0

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
		global.turfs.append(type)
	pass

func init(e):
	e = objs.Turfs[e]
	self._name = e.name
	self.image = e.image
	self.get_node("CollisionShape2D").get_shape().set_extents(self.get_node("Sprite").texture.get_size()/2)
	pass