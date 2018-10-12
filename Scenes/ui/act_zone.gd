extends Area2D

var mode_sprites = ["res://Imgs/mouse_act.png", "res://Imgs/p_attack.png"]
var current_anim = ""

func _ready():
	pass

signal deleted()

func _process(delta):
	if !get_node("animation").is_playing():
		global.current_scene.get_node("Player").act_lock = false
		global.current_scene.get_node("Player").act_target = null
		emit_signal("deleted")
		queue_free()
	pass

func init(mode):
	if mode == 1:
		current_anim = "attack"
		set_scale(Vector2(1, 1))
		$Sprite.texture = load(mode_sprites[1])
	else:
		current_anim = "roll"
		$Sprite.texture = load(mode_sprites[0])
	pass