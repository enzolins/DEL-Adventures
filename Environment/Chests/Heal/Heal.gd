extends KinematicBody2D

const HealSFX = preload("res://Environment/Chests/Heal/HealSFX.tscn")

#GRAVITY - JUMP
export var jump_height : float
export var jump_time_to_peak : float
export var jump_time_to_descent : float
export var range_X: int
export var gravity: int

onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1
onready var playerDetectionZone = $PlayerDetectionZone
onready var animationPlayer = $AnimationPlayer

var velocity = Vector2.ZERO
var friction = 100

func _ready():
	#CHOSE RANDOM VELOCITY ON THE X AXIS
	velocity.y = jump_velocity
	#velocity.x = rand_range(-range_X,range_X)
	velocity.x = range_X

func _physics_process(delta):
	var player = playerDetectionZone.player
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity,Vector2.UP)
	stop(delta)
	
	if player != null: # DETECTS IF THE PLAYER IS NEARBY
		var healSFX = HealSFX.instance()
		PlayerStats.max_health += 1
		PlayerStats.health = PlayerStats.max_health
		get_tree().get_root().call_deferred("add_child", healSFX)
		queue_free()
	

func stop(delta): #MAKE THE COIN STOP WHEN IT TOUCHES THE GROUND
	if is_on_floor():
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		animationPlayer.play("Pulse")
