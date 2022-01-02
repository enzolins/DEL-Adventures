extends Control

onready var coinAnimation = $Coin/AnimationPlayer
onready var goldAmount = $GoldAmount

func _ready():
	coinAnimation.play("Rotate")
	PlayerStats.connect("goldChanged", self, "setCoinAmount")


func setCoinAmount(value):
	goldAmount.text = String(value)
