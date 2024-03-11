extends Node

func _enter_tree():
	get_node("/root").get_texture().flags |= Texture.FLAG_FILTER
