extends Node

var nums = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
#["!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "_", "+"]
var chars = ["@"]

func _ready():
	randomize(true)

func round_rand(a, b):
	return round(rand_range(a, b))

func int_rand(a, b):
	return int(round(rand_range(a, b)))

func bool_rand():
	var r = round(rand_range(0, 1))
	if r == 0:
		return false
	else:
		return true

func selective_rand(a, b):
	return a if bool_rand() else b

func excluding_rand(a, b, c):
	var mas = []
	for i in range(a, b+1):
		if typeof(c) == TYPE_ARRAY and c.has(i):
			continue	
		elif typeof(c) == TYPE_INT and c == i:
			continue
		else:
			mas.append(i)
	return mas[int_rand(0, mas.size()-1)]

func clear_node_name(_name):
	var name = ""
	for c in _name.length():
		if _name[c] == chars[0]:
			continue
		elif _name[c] != chars[0]:
			name += _name[c]
			continue
	var name2 = ""
	for c in name.length():
		var count = int(0)
		for n in nums:
			if name[c] != str(n):
				count += 1
		if count == nums.size():
			name2 += name[c]
	return name2
	pass

func set_angle(a, b):
	pass

func my_set_color(obj, r, g, b, a):
	obj.modulate.r8 = r
	obj.modulate.g8 = g
	obj.modulate.b8 = b
	obj.modulate.a8 = a
	pass