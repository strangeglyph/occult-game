extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(ev):
	if Input.is_key_pressed(KEY_SPACE):
		$CardA.material.set_shader_param("START_TIME", Time.get_ticks_msec() / 1000.0);
		$CardB.material.set_shader_param("START_TIME", Time.get_ticks_msec() / 1000.0);
		$CardC.material.set_shader_param("START_TIME", Time.get_ticks_msec() / 1000.0);
