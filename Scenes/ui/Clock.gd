extends Control

onready var arrow = get_node("Arrow")
onready var timer = get_node("Timer")
onready var sun = get_parent().get_node("Sun")

var start_degrees = -90

var time = 0
var dt = 0
var nt = 0

func _ready():
	timer.set_wait_time(global.day_time)
	arrow.set_rotation_degrees(start_degrees)
	timer.start()
	global.day_count = 1
	day_alert()
	pass

func _physics_process(delta):
	if global.time_of_day == "day":
		dt = timer.get_wait_time() - timer.get_time_left()
	if global.time_of_day == "night":
		nt = timer.get_wait_time() - timer.get_time_left()
	time = dt+nt
	arrow.rotation = time/57.3 + start_degrees/57.3
	pass

func set_time_of_day():
	if global.time_of_day == "day":
		global.time_of_day = "night"
		timer.set_wait_time(global.night_time)
		sun.energy = 1
		sun.set_mode(2)
	else:
		global.time_of_day = "day"
		timer.set_wait_time(global.day_time)
		sun.energy = 0.1
		sun.set_mode(0)
		reset_time()
		global.day_count += 1
		day_alert()

func reset_time():
	time = 0
	dt = 0
	nt = 0
	arrow.set_rotation_degrees(start_degrees)

func day_alert():
	get_parent().get_node("Alert").set_text("Day" + str(global.day_count))
	get_parent().get_node("Alert/animation").play("change_day")
	pass

func _on_Timer_timeout():
	set_time_of_day()
	timer.start()
