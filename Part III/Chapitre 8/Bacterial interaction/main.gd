extends Node2D

const N = 500
var k = 0
var counter = 0

onready var Particle = preload("res://particle.tscn")
onready var Veroni = preload("res://bacteria_pv.tscn")
onready var Putida = preload("res://bacteria_pp.tscn")
onready var poprectangle = $popzone/poprectangle.shape

var pop_width
var pop_height

func _ready():
	var ext = poprectangle.extents
	pop_width = ext.x
	pop_height = ext.y


func _process(delta):
	counter = counter + 1
	if counter == 3:
		counter = 0
		k = k + 1
		$Label.text = "n: %d" % k
		
		if k < N:
			var part = Particle.instance()
			part.position = $popzone.position + 2*Vector2((randf() - 0.5)*pop_width, (randf() - 0.5)*pop_height)
			add_child(part)
	
	
