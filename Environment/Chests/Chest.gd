extends Node2D

var is_opened = false

onready var playerDetectionZone = $PlayerDetectionZone
onready var animatedSprite = $AnimatedSprite
onready var goldGenerator = $GoldGenerator
onready var collision = $Collision/CollisionShape2D


func _process(delta):
	if is_opened == false:
		animatedSprite.play("Closed")
	var player = playerDetectionZone.player
	if player != null and is_opened == false:
		if Input.is_action_just_pressed("ui_interact"):
			PlayerStats.setGold(goldGenerator.generateGold())
			is_opened = true
			animatedSprite.play("Opened")
			collision.position.y = -1


