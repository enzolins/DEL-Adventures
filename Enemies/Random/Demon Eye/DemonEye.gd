extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/VFx/EnemyDeathEffect.tscn")
const HitEffect = preload("res://Effects/VFx/HitEffect.tscn")

export(PackedScene) var PROJECTILE: PackedScene = preload("res://Enemies/Random/Demon Eye/DemonEyeProjectile.tscn")


export var GRAVITY = 1000

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var state = IDLE

onready var animatedSprite = $AnimatedSprite
onready var stats = $Stats
onready var hurtbox = $Hurtbox
onready var playerDetectionZone = $PlayerDetectionZone
onready var goldGenerator = $GoldGenerator
onready var timer = $AttackRate


#STATE MACHINE - STATES
enum{
	IDLE,
	SHOOT
}

func _ready():
	animatedSprite.play("Idle")
	
func _physics_process(delta):
	velocity.y += GRAVITY * delta
	#ACTUAL STATE MACHINE
	match state:
		IDLE:
			animatedSprite.play("Idle")
			seekPlayer()

		SHOOT:
			chasePlayer(delta)
			if timer.is_stopped():
				shootArrow()



func pickRandomState(stateList):
	stateList.shuffle()
	return stateList.pop_front()

#func checkNewState():
#	state = pickRandomState([IDLE, WANDER])
#	wanderController.startWanderTimer(rand_range(1,3))
	
func seekPlayer():
	if playerDetectionZone.canSeePlayer():
		state = SHOOT

func chasePlayer(delta):
	var player = playerDetectionZone.player
	if player != null:
		if player.global_position.x - global_position.x < 0:
			animatedSprite.play("LookLeft")
		else:
			animatedSprite.play("LookRight")
	else:
		state = IDLE


func _on_Hurtbox_area_entered(area):
	var effect = HitEffect.instance()#DON'T KN0W HOW THE FUNC CREATEHITEFFECT WASN'T WORKING
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position
	stats.health -= area.damage
	


func _on_Stats_noHealth():
	queue_free()
	PlayerStats.setGold(goldGenerator.generateGold())
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position 
	
	
func shootArrow():
	var player = playerDetectionZone.player
	if player != null:
		var direction = playerDetectionZone.playerHead()
		direction.y += 2 
		var projectile = PROJECTILE.instance()
		get_tree().current_scene.add_child(projectile)
		projectile.global_position = self.global_position
		projectile.global_position.y -= 4
		projectile.global_position.x -= 2
		var projectileRotation = self.global_position.direction_to(direction).angle()
		projectile.rotation = projectileRotation
		timer.start()
	else:
		state = IDLE

