extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/VFx/EnemyDeathEffect.tscn")
const HitEffect = preload("res://Effects/VFx/HitEffect.tscn")

export var FRICTION = 100
export var KNOCKBACK_SPEED = 100
export var ACCELERATION = 200
export var MAX_SPEED = 50
export var GRAVITY = 1000

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = WANDER
var height = global_position.y

onready var animatedSprite = $AnimatedSprite
onready var wanderController = $WanderController
onready var stats = $Stats
onready var hurtbox = $Hurtbox
onready var playerDetectionZone = $PlayerDetectionZone
onready var goldGenerator = $GoldGenerator


#GRAVITY - JUMP
export var jump_height : float
export var jump_time_to_peak : float
export var jump_time_to_descent : float

onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1


#STATE MACHINE - STATES
enum{
	IDLE,
	WANDER,
	CHASE
}

func _ready():
	state = pickRandomState([IDLE, WANDER])
	animatedSprite.play("Idle")
	
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, delta * FRICTION)
	knockback = move_and_slide(knockback)
	velocity.y += GRAVITY * delta
	#ACTUAL STATE MACHINE
	match state:
		IDLE:
			animatedSprite.play("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seekPlayer()
			if wanderController.getTimeLeft() == 0:
				checkNewState()
		WANDER:
			animatedSprite.play("Walk")
			seekPlayer()
			if wanderController.getTimeLeft() == 0:
				checkNewState()
			var direction = global_position.direction_to(wanderController.target_position)
			velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			animatedSprite.flip_h = velocity.x > 0
			if global_position.distance_to(wanderController.target_position) <= MAX_SPEED * delta:
				checkNewState()
		CHASE:
			chasePlayer(delta)
	velocity = move_and_slide(velocity,Vector2.UP)
	jump(delta)



func pickRandomState(stateList):
	stateList.shuffle()
	return stateList.pop_front()

func checkNewState():
	state = pickRandomState([IDLE, WANDER])
	wanderController.startWanderTimer(rand_range(1,3))
	
func seekPlayer():
	if playerDetectionZone.canSeePlayer():
		state = CHASE

func chasePlayer(delta):
	var player = playerDetectionZone.player
	if player != null:
		var direction = (player.global_position - global_position).normalized()
		direction.y = height
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		wanderController.setNewStartPosition(player.global_position) #SETS THE NEW START POSITION AS THE LATEST PLAYER POSITION
	else:
		state = IDLE
	animatedSprite.play("Walk")
	animatedSprite.flip_h = velocity.x > 0


func _on_Hurtbox_area_entered(area):
	var effect = HitEffect.instance()#DON'T KN0W HOW THE FUNC CREATEHITEFFECT WASN'T WORKING
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position
	stats.health -= area.damage
	knockback = area.knockback_vector * KNOCKBACK_SPEED
	


func _on_Stats_noHealth():
	queue_free()
	PlayerStats.setGold(goldGenerator.generateGold())
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position 
	
func jump(_delta):
	if state == WANDER or state == CHASE:
		if is_on_floor() and is_on_wall():
			velocity.y = jump_velocity
