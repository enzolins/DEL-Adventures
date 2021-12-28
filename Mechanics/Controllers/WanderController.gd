extends Node2D

export(int) var wanderRange = 32

onready var startPosition = global_position
onready var target_position = global_position
onready var timer = $Timer

func updateTargetPosition():
	var target_vector = Vector2(rand_range(-wanderRange,wanderRange),startPosition.y)
	target_position.x = startPosition.x + target_vector.x
	print(startPosition)
	print(target_position)

func getTimeLeft():
	return timer.time_left

func startWanderTimer(duration):
	timer.start(duration)

func _on_Timer_timeout():
	updateTargetPosition()

func _ready():
	updateTargetPosition()
