tool
extends Control

signal pressed()

export (Texture) var texture = null setget set_texture
export (Texture) var texture_selected = null setget set_texture_hover
var enabled = true

func set_texture(t):
	texture = t
	self.rect_size = texture.get_size()
	if has_node("Sprite"):
		$Sprite.texture = t

func set_texture_hover(t):
	texture_selected = t
	if has_node("Sprite_selected"):
		$Sprite_selected.texture = t

export var text = "" setget set_text
func set_text(value):
	text = value
	if has_node("Label"):
		$Label.text = value

var selected = false setget set_selected
func set_selected(value):
	if value:
		if has_node("Sprite"):
			$Sprite.visible = false
		if has_node("Sprite_selected"):
			$Sprite_selected.visible = true
		selected = true
	else:
		if has_node("Sprite"):
			$Sprite.visible = true
		if has_node("Sprite_selected"):
			$Sprite_selected.visible = false
		selected = false

func unselect():
	self.selected = false

func _ready():
	if texture != null:
		if has_node("Sprite"):
			$Sprite.texture = texture
		self.rect_size = texture.get_size()
		$Sprite.global_position = rect_global_position + texture.get_size()/2
	if texture_selected != null:
		if has_node("Sprite_selected"):
			$Sprite_selected.texture = texture_selected
			$Sprite_selected.global_position = rect_global_position + texture.get_size()/2
			#$Sprite_selected.position += texture_selected.get_size()/2
	pass

func _on_ControlButton_gui_input(event):
	if enabled and (event is InputEventMouseButton or event is InputEventScreenTouch) and event.is_pressed():
		self.selected = false
		emit_signal("pressed")

func _on_ControlButton_mouse_entered():
	self.selected = true

func _on_ControlButton_mouse_exited():
	self.selected = false
