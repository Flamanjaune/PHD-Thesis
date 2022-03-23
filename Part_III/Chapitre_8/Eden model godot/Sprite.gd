extends Sprite

const SPEED = 500

var movedir = Vector2(0,0)
var spritedir = "down"

func _physics_process(delta):
	var motion = dir.rand().normalized() * SPEED * delta
	position = position + motion
