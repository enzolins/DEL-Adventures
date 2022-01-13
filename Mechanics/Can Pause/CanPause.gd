extends Node

var canPause = false

func canPause():
	canPause = true

func cannotPause():
	canPause = false

func getCanPause():
	return canPause
