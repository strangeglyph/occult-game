extends KinematicBody2D
class_name DragDroppable

signal begin_drag()
signal end_drag()
signal drag_update()

var _is_dragging: bool = false
var _offset: Vector2 = Vector2(0, 0)

func _ready():
	input_pickable = true
	connect("input_event", self, "_drag_input_event")

func begin_drag():
	_is_dragging = true
	_offset = $"..".position - get_global_mouse_position()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	emit_signal("begin_drag")
	DragDropManager.emit_signal("begin_drag", self)

func end_drag():
	_is_dragging = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	emit_signal("end_drag")
	DragDropManager.emit_signal("end_drag", self)

func _process(delta):
	if _is_dragging:
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			$"..".position = get_global_mouse_position() + _offset
			emit_signal("drag_update")
			DragDropManager.emit_signal("drag_update", self)
		else:
			end_drag()

func _drag_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				begin_drag()
			elif _is_dragging:
				end_drag()
