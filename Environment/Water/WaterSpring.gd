extends Node2D

var velocity = 0
var force = 0
var height = 0
var target_Height = 0
var index = 0
export var motion_factor = 0.02
var collided_width = null

signal splash

onready var collision = $Area2D/CollisionShape2D

func water_Update(spring_Constant, dampening): #HOOK'S LAW
	height = position.y
	
	var x = height - target_Height
	var loss = -dampening * velocity
	
	force = -spring_Constant * x + loss
	velocity += force
	position.y += velocity
	pass

func initialize(x_position, id):
	height = position.y
	target_Height = position.y
	velocity = 0
	position.x = x_position
	index = id

func set_collision_width(value):
	var extents = collision.shape.get_extents()
	var new_extents = Vector2(value/2, extents.y)
	collision.shape.set_extents(new_extents)
	pass


func _on_Area2D_body_entered(body):
	if body == collided_width:
		return
	else:
		collided_width = body
	var speed = body.velocity.y * motion_factor
	emit_signal("splash", index, speed)
	collided_width = null
