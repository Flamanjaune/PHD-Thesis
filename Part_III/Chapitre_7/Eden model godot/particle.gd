extends Area2D

const SPEED = 500

var movedir = Vector2(0,0)
var spritedir = "down"

func _process(delta):
	var motion = dir.rand().normalized() * SPEED * delta
	position = position + motion
	

func _on_bacteria_entered(bacteria):
	var random_float = randf()
	if random_float < 1:
		bacteria.eat()  # Tell the bacteria it found food
		queue_free()  # Self destruct
