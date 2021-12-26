extends RigidBody2D

var Putida = load("res://bacteria.tscn")
var n = 0
var e = 0
export var thres = 1

var height

func _ready():
	height = $CollisionShape2D.shape.radius * 2

func eat():
	e = e+1
	if e >= thres:
		var v = Putida.instance()
		rotation = randf() * 2 * PI
		v.position = to_global(Vector2(0, height/1.2))
		#position = to_global(Vector2(0, -height/2))
		get_parent().add_child(v)
		e = 0
		n = n+1
