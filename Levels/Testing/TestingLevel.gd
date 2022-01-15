extends Node2D

func _ready():
	self.connect("pressed", self, "queue_free")

func test():
	print("OK")
