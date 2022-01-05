extends Node

export(int) var MAX = 0
export(int) var MIN = 0


var RNG = RandomNumberGenerator.new()


func generateGold():
	if(MAX != null and MIN != null):
		randomize()
		var random = (randi() % MAX + MIN)
		if random > MAX:
			random = MAX
		return random
	else:
		return 0
		
