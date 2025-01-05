extends Object

class_name Fadeable

var FADE_IN_BURN: Material = load("res://materials/BurnFadeIn.tres")
var FADE_IN_WATER: Material = load("res://materials/OceanFadeIn.tres")
var FADE_IN_PLAIN: Material = load("res://materials/PlainFadeIn.tres")


var effect: Material

func _init(effect: Material):
	self.effect = effect
