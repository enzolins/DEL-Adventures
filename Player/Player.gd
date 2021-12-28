extends KinematicBody2D

#CONSTANTS
export var MAX_SPEED = 140
export var ACCELERATION = 650
export var FRICTION = 8000

#GRAVITY - JUMP
export var jump_height : float
export var jump_time_to_peak : float
export var jump_time_to_descent : float

onready var jump_velocity : float = (2.0 * jump_height / jump_time_to_peak) * -1
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1
onready var fall_gravity :float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1

#MECHANIC VARIABLES
var velocity = Vector2.ZERO
var direction
var is_jumping = false

#NODE VARIABLES
onready var animatedSprite = $AnimatedSprite
onready var collisionShape = $CollisionShape2D

#STATE MACHINE
enum{
	MOVE,
	JUMP
	ATTACK
}
var state = MOVE

#ON INITIALIZATION
func _ready():
	randomize()
	animatedSprite.play("Idle")
	

#PHYSICS PROCESS
func _physics_process(delta):
	velocity.y += get_gravity() * delta
	
	match state:
		MOVE:
			move_state(delta)
		JUMP:
			jump_state(delta)
		ATTACK:
			attack_state(delta)


#MOVING THE CHARACTER - STATE
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector = input_vector.normalized()
	
	#PLAYER CANNOT JUMP WHEN HIS HEAD TOUCHES THE GROUND
	if is_on_ceiling():
		is_jumping = false
	
	if input_vector != Vector2.ZERO:
		direction = input_vector
		#CHECK IF IT NEEDS FLIPPING
		if direction.x > 0:
			animatedSprite.flip_h = false
		if direction.x < 0:
			animatedSprite.flip_h = true
		if is_jumping == false:
			animatedSprite.play("Run")
		
		velocity.x = input_vector.x * MAX_SPEED
	else:
		if is_jumping == false:
			animatedSprite.play("Idle")
			velocity = velocity.move_toward(Vector2(0,velocity.y), FRICTION * delta)
		else:
			velocity = velocity.move_toward(Vector2(0,velocity.y), FRICTION * delta)
		
	move()
	
	#CHECKING IF PLAYER IS JUMPING
	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		state = JUMP
		velocity.y = jump_velocity
	
	#CHECKING IF PLAYER IS ATTACKING
	if Input.is_action_just_pressed("ui_mouseL") and is_on_floor():
		state = ATTACK
	
	#DISABLING THE COLLISION SHAPE WHEN "S" IS PRESSED - TESTING FOR NOW - NOT WORKING 
	#if Input.is_action_pressed("ui_down"):
		#collisionShape.disabled = true

#JUMPING - STATE
func jump_state(delta):
	animatedSprite.play("Jump")
	is_jumping = true
	velocity.y = jump_velocity
	state = MOVE
	
#ATTACKING - STATE
func attack_state(delta):
	animatedSprite.play("Attack")


func get_gravity():
	return jump_gravity if velocity.y < 0.0 else fall_gravity

#MOVING THE CHARACTER - FUNCTION
func move():
	velocity = move_and_slide(velocity,Vector2.UP)


func _on_AnimatedSprite_animation_finished():
	is_jumping = false
	state = MOVE
	
