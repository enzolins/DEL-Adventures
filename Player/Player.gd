extends KinematicBody2D

const PlayerHurtSound = preload("res://Effects/SFx/PlayerHurtSound.tscn")

#CONSTANTS
export var MAX_SPEED = 140
export var ACCELERATION = 650
export var FRICTION = 8000

#GRAVITY - JUMP
export var jump_height : float = 70
export var jump_time_to_peak : float = 0.5
export var jump_time_to_descent : float = 0.4

#PUSHING
export var inertia: float = 100.0

onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1
onready var fall_gravity :float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1

#MECHANIC VARIABLES
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var is_jumping = false
var stats = PlayerStats
#IN WATER FACTORS
var x_factor = 1
var y_factor = 1
var is_in_water = false
#ATTACK ALTERNATION
var attack = 1

#NODE VARIABLES
onready var animatedSprite = $AnimatedSprite
onready var collisionShape = $CollisionShape2D
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
onready var swordCollision = $HitboxPivot/SwordHitbox/CollisionShape2D
onready var timer = $Timer
onready var swipeSword = $SwipeSword

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
	stats.connect("noHealth", self, "queue_free")
	swordHitbox.knockback_vector = Vector2.RIGHT
	swordCollision.disabled = true

#PHYSICS PROCESS
func _physics_process(delta):
	velocity.y += get_gravity() * delta
	disbleSwordCollision()
	
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
		Global.playerPos = input_vector
		direction = input_vector
		swordHitbox.knockback_vector = input_vector
		#CHECK IF IT NEEDS FLIPPING
		if direction.x > 0:
			animatedSprite.flip_h = false
			swordCollision.position.x = 14
		if direction.x < 0:
			animatedSprite.flip_h = true
			swordCollision.position.x = -14
		if is_jumping == false:
			animatedSprite.play("Run")
		
		velocity.x = input_vector.x * MAX_SPEED
	else:
		if is_jumping == false:
			animatedSprite.play("Idle")
			velocity = velocity.move_toward(Vector2(0,velocity.y), FRICTION * delta)
		else:
			velocity = velocity.move_toward(Vector2(0,velocity.y), FRICTION * delta)
	
	change_player_speed(x_factor,y_factor)
	move()
	
	#CHECKING IF PLAYER IS JUMPING
	if Input.is_action_just_pressed("ui_select") and is_on_floor(): #(is_on_floor() or is_on_wall()): WALL JUMP
		state = JUMP
		velocity.y = jump_velocity
	
	#CHECKING IF PLAYER IS ATTACKING
	if Input.is_action_just_pressed("ui_mouseL") and is_on_floor():
		swordCollision.disabled = false
		timer.start()
		swipeSword.play(0.0)
		state = ATTACK

#JUMPING - STATE
func jump_state(_delta):
	animatedSprite.play("Jump")
	is_jumping = true
	velocity.y = jump_velocity
	state = MOVE
	
#ATTACKING - STATE
func attack_state(_delta):
	velocity = Vector2.ZERO
	match attack:
		1:
			animatedSprite.play("Attack1")
			if animation_finished(animatedSprite, "Attack1"):
				attack = 2
				state = MOVE
		2: 
			animatedSprite.play("Attack2")
			if animation_finished(animatedSprite, "Attack2"):
				attack = 3
				state = MOVE
		3:
			animatedSprite.play("Attack3")
			if animation_finished(animatedSprite, "Attack3"):
				attack = 1
				state = MOVE


func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

#MOVING THE CHARACTER - FUNCTION
func move():
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI/4, false)
	check_box_collision()
	Global.walkDirection = direction

func _on_AnimatedSprite_animation_finished():
	is_jumping = false
	state = MOVE

func _on_Hurtbox_area_entered(area):
	if hurtbox.invencible == false:
		stats.health -= area.damage
		hurtbox.startInvencibility(0.5)
		hurtbox.createHitEffect()
		var playerHurtSound = PlayerHurtSound.instance()
		get_tree().current_scene.add_child(playerHurtSound)
		
func disbleSwordCollision():
	if timer.time_left == 0:
		swordCollision.disabled = true
		
func flipPlayer():
	animatedSprite.flip_h = true
	swordCollision.position.x = -14
	
func change_player_speed(xfactor,yfactor):
	velocity.x = velocity.x * xfactor
	velocity.y = velocity.y * yfactor
	if is_on_floor():
		y_factor = 1


func _on_WaterDetector_area_entered(_area):
	x_factor = 0.5
	y_factor = 0.5
	animatedSprite.speed_scale = 0.6


func _on_WaterDetector_area_exited(_area):
	x_factor = 1
	y_factor = 1
	animatedSprite.speed_scale = 1
	
func animation_finished(animation: AnimatedSprite, animation_name: String) -> bool: 
	var finished
	if animation.animation == animation_name and animation.frame == animation.frames.get_frame_count(animation_name) - 1:
		finished = true
	else:
		finished = false
	return finished

func _on_BoxDetector_area_entered(_area):
	x_factor = 0.5
	animatedSprite.speed_scale = 0.6


func _on_BoxDetector_area_exited(_area):
	x_factor = 1
	animatedSprite.speed_scale = 1
	
func check_box_collision():
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("Boxes"):
			collision.collider.apply_central_impulse(-collision.normal * inertia)
