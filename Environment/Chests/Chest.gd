extends Node2D

const Coin = preload("res://Environment/Chests/Coin/Coin.tscn")

var is_opened = false

onready var playerDetectionZone = $PlayerDetectionZone
onready var animatedSprite = $AnimatedSprite
onready var collision = $Collision/CollisionShape2D
onready var animationPlayer = $AnimationPlayer
onready var e = $E

func _ready():
	e.visible = false

func _physics_process(_delta):
	if is_opened == false:
		animatedSprite.play("Closed")
	var player = playerDetectionZone.player
	if player != null and is_opened == false:
		e.visible = true
		animationPlayer.play("Pulse")
		if Input.is_action_just_pressed("ui_interact"):
			is_opened = true
			animatedSprite.play("Opened")
			collision.position.y = -1
			var coin = Coin.instance()
			get_tree().get_root().call_deferred("add_child", coin)
			coin.global_position = global_position
	else:
		e.visible = false
		animationPlayer.stop()
