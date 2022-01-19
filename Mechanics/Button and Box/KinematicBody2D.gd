extends KinematicBody2D

onready var collision1 = $CollisionShape2D

func _physics_process(delta):
	position = collision1.position
