extends KinematicBody2D

const PlayerHurtSound = preload("res://Effects/SFx/PlayerHurtSound.tscn")

#CONSTANTS
export var MAX_SPEED = 140
export var ACCELERATION = 650
export var FRICTION = 8000

#GRAVITY - JUMP
export var jump_height : float
export var jump_time_to_peak : float
export var jump_time_to_descent : float

onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1
onready var fall_gravity :float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1

#MECHANIC VARIABLES
var velocity = Vector2.ZERO
var direction
var is_jumping = false
var stats = PlayerStats

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
func jump_state(delta):
	animatedSprite.play("Jump")
	is_jumping = true
	velocity.y = jump_velocity
	state = MOVE
	
#ATTACKING - STATE
func attack_state(delta):
	velocity = Vector2.ZERO
	animatedSprite.play("Attack")


func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

#MOVING THE CHARACTER - FUNCTION
func move():
	velocity = move_and_slide(velocity,Vector2.UP)
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
