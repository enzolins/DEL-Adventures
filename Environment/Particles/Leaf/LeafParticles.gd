extends Node2D


onready var lighGreen = $LightGreen
onready var darkGreen = $DarkGreen
onready var middlegreen = $MiddleGreen

func _ready():
	lighGreen.emitting = true
	darkGreen.emitting = true
	middlegreen.emitting = true
