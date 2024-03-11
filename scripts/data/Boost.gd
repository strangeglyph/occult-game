extends Object

class_name Boost

enum Status { LOCKED, UNLOCKED, BOUGHT }

var name: String
var flavor: String
var description: String
var image: Texture
var cost: Array
var status: int

func _init(name: String, flavor: String, description: String, image: Texture, cost: Array):
	self.name = name
	self.flavor = flavor
	self.description = description
	self.image = image
	self.cost = cost
	self.status = Status.LOCKED
