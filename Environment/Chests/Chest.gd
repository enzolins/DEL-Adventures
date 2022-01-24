extends Node2D

const Coin = preload("res://Environment/Chests/Coin/Coin.tscn")

var is_opened = false

onready var playerDetectionZone = $PlayerDetectionZone
onready var animatedSprite = $AnimatedSprite
onready var collision = $Collision/CollisionShape2D


func _physics_process(_delta):
	if is_opened == false:
		animatedSprite.play("Closed")
	var player = playerDetectionZone.player
	if player != null and is_opened == false:
		if Input.is_action_just_pressed("ui_interact"):
			is_opened = true
			animatedSprite.play("Opened")
			collision.position.y = -1
			var coin = Coin.instance()
			coin.position = global_position
			get_tree().current_scene.add_child(coin)


