extends Control

onready var coinAnimation = $Coin/AnimationPlayer
onready var coinAmount = $CoinAmount

func _ready():
	coinAnimation.play("Rotate")
	#PlayerStats.connect("goldChanged", self, "setCoinAmount")


func setCoinAmount(value):
	coinAmount.text = String(value)
