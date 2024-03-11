tool
extends StaticBody2D

export var radius: int = 100

var _mouse_inside = false
var _is_card_drag = false

var _cards_in_circle = Array()

func _ready():
	connect("mouse_entered", self, "_do_mouse_enter")
	connect("mouse_exited", self, "_do_mouse_exit")

func _draw():
	if Engine.editor_hint:
		draw_arc(Vector2.ZERO, radius, 0, TAU, 64, Globals.COLOR_CHANNEL_CIRCLE_HINT, 2, true)
	elif _is_card_drag:
		if not _mouse_inside:
			draw_arc(Vector2.ZERO, radius, 0, TAU, 64, Globals.COLOR_CHANNEL_CIRCLE_HINT, 2, true)
		else:
			draw_arc(Vector2.ZERO, radius, 0, TAU, 64, Color.cyan, 2, true)

func _do_mouse_enter():
	_mouse_inside = true
	update()
	
func _do_mouse_exit():
	_mouse_inside = false
	update()
	
func _drag_start(obj):
	_is_card_drag = true
	if _mouse_inside:
		_cards_in_circle.erase(obj)
	update()
	
func _drag_end(obj):
	_is_card_drag = false
	if _mouse_inside:
		_cards_in_circle.append(obj)
	update()
