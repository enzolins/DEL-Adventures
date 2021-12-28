extends KinematicBody2D

export var FRICTION = 100
export var KNOCKBACK_SPEED = 100
export var ACCELERATION = 200
export var MAX_SPEED = 50

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = WANDER

onready var animatedSprite = $AnimatedSprite
onready var wanderController = $WanderController

enum{
	IDLE,
	WANDER
}

func _ready():
	state = pickRandomState([IDLE, WANDER])
	animatedSprite.play("Idle")
	
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, delta * FRICTION)
	knockback = move_and_slide(knockback)
	match state:
		IDLE:
			animatedSprite.play("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			if wanderController.getTimeLeft() == 0:
				checkNewState()
		WANDER:
			animatedSprite.play("Walk")
			if wanderController.getTimeLeft() == 0:
				checkNewState()
			var direction = global_position.direction_to(wanderController.target_position)
			velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			animatedSprite.flip_h = velocity.x > 0
			if global_position.distance_to(wanderController.target_position) <= MAX_SPEED * delta:
				checkNewState()
	velocity = move_and_slide(velocity)



func pickRandomState(stateList):
	stateList.shuffle()
	return stateList.pop_front()

func checkNewState():
	state = pickRandomState([IDLE, WANDER])
	wanderController.startWanderTimer(rand_range(1,3))
