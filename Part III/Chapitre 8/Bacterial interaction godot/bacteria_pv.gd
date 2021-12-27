extends RigidBody2D

var Veroni = load("res://bacteria_pv.tscn")

var e = 0
export var thres = 2

var radius
var width
var height

func _ready():
	radius = $CollisionShape2D.shape.radius
	width = radius * 2
	height = $CollisionShape2D.shape.height + width


func eat():
	e = e+1
	if e >= thres:
		var v = Veroni.instance()
		var angle = (randf() - 0.5) * 0.2 * PI
		var hypp = radius/sin(angle)
		var pos = Vector2(0,hypp + height/2).rotated(angle)
		v.rotation = rotation + angle
		v.position = to_global(pos)
		#rotation = rotation + 0.2 * (randf() - 0.5) * 2 * PI
		#v.position = to_global(Vector2(0, -height/2.2))
		get_parent().add_child(v)
		e = 0
