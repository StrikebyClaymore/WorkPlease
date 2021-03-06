tool
extends Node2D

export var sprite = "" setget set_sprite
export var text = "" setget set_text
func set_sprite(value):
	sprite = value
	if has_node("button"):
		$button.set_texture(load("res://imgs/"+value+".png"))
		$button_selection.set_texture(load("res://imgs/"+value+"_frame.png"))

func set_text(value):
	text = value
	if has_node("button"):
		$Label.set_text(value)
	
signal pressed()

var selected = false setget set_selected
func set_selected(value):
	if value:
		$button_selection.visible = true
		selected = true
		z_index = 1
		#get_parent().move_child(self, get_parent().get_child_count() - 1)
	else:
		$button_selection.visible = false
		selected = false
		z_index = 0

func unselect():
	self.selected = false

func _ready():
	if(!Engine.editor_hint):
		get_node("/root/global").connect("unselect_all", self, "unselect")
	set_collision_size()

func set_collision_size():
	get_node("Area2D/CollisionShape2D").get_shape().set_extents(get_node("button").texture.get_size()/2)

func _on_Area2D_input_event(viewport, event, shape_idx):
	if get_node("/root/global").lock():
		if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.is_pressed():
			emit_signal("pressed")
		get_node("/root/global").unlock()

func _on_Area2D_mouse_entered():
	if !get_node("/root/global").locked:
		get_node("/root/global").emit_signal("unselect_all")
		self.selected = true

func _on_Area2D_mouse_exited():
	if !get_node("/root/global").locked:
		self.selected = false




