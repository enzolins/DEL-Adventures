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
var state

################################ JUMP VARIABLES ####################################
export var jump_height : float
export var jump_time_to_peak : float
export var jump_time_to_descent : float

onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1
onready var fall_gravity :float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1
#####################################################################################

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var hurtbox = $Hurtbox
onready var player_detection_zone = $PlayerDetectionZone
onready var inner_player_detection_zone = $InnerPlayerDetectionZone
onready var stats = $Stats
onready var gold_generator = $GoldGenerator
onready var can_attack = $CanAttack
onready var can_chase = $CanChase
onready var sprite = $Sprite
onready var attack_hitbox = $AttackHitbox/CollisionPolygon2D


var is_dead: bool = false
var inertia
var inertia_threshold: int = 25
var boss_stats = BossStatsPlaceHolder


enum{
	IDLE,
	CHASE,
	ATTACK,
	DEAD
}

func _ready():
	state = IDLE
	animation_tree.active = true
	boss_stats.max_health = stats.health
	boss_stats.health = stats.health
	boss_stats.previous_health = stats.health

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, delta * FRICTION)
	knockback = move_and_slide(knockback)
	#velocity.y += GRAVITY * delta
	velocity.y += fall_gravity * delta
	match state:
		IDLE:
			idle_state(delta)
			seek_player()
		CHASE:
			chase_state(delta)
		ATTACK:
			attack_state(delta)
		DEAD:
			dead_state(delta)
	
	velocity = move_and_slide(velocity,Vector2.UP)
	jump(delta)

func seek_player():
	if player_detection_zone.canSeePlayer():
		state = CHASE

func flip():
	sprite.flip_h = velocity.x < 0
	if sprite.flip_h:
		attack_hitbox.scale.x = -1
	else:
		attack_hitbox.scale.x = 1

func idle_state(delta):
	animation_state.travel("Idle")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

func chase_state(delta):
	var player = player_detection_zone.player
	var attack_zone = inner_player_detection_zone.canSeePlayer()
	if player != null and not attack_zone and can_chase.time_left <= 0:
		var direction = (player.global_position - global_position).normalized()
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		if velocity.x > inertia_threshold or velocity.x < inertia_threshold:
			inertia = clamp(velocity.x, -inertia_threshold, inertia_threshold)
		animation_state.travel("Run")
		flip()
	elif attack_zone and can_attack.time_left <= 0:
		state = ATTACK
	else:
		state = IDLE

func attack_state(_delta):
	velocity = Vector2.ZERO
	animation_state.travel("Attack")
	can_attack.start()
	can_chase.start()
	state = IDLE
	
func jump(_delta):
	if state == CHASE:
		if is_on_floor() and is_on_wall():
			velocity.y = jump_velocity
			velocity.x = inertia


func dead_state(delta):
	animation_state.travel("Die")
	velocity = Vector2.ZERO

func die():
	PlayerStats.setGold(gold_generator.generateGold())
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position 
	queue_free()


func _on_Hurtbox_area_entered(area):
	animation_state.travel("Hit")
	can_chase.start()
	if is_dead == false:
		var effect = HitEffect.instance()
		var main = get_tree().get_root()
		main.call_deferred("add_child", effect)
		effect.global_position = global_position
	boss_stats.previous_health = stats.health
	stats.health -= area.damage
	boss_stats.health = stats.health
	knockback = area.knockback_vector * KNOCKBACK_SPEED


func _on_Stats_noHealth():
	state = DEAD
	is_dead = true

