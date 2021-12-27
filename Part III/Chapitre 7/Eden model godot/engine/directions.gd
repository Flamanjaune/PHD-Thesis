extends Node

const center = Vector2(0,0)
const left = Vector2(-1,0)
const right = Vector2(1,0)
const up = Vector2(0,-1)
const down = Vector2(0,1)

func rand():
	return Vector2(randf()-0.5,randf()-0.5)
