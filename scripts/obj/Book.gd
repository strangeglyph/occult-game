extends Node2D


signal book_opened

var _book_opened = false
var _current_active_page: CollisionObject2D = null

func _ready():
	_current_active_page = $WritingPage
	

func _on_BookCollider_mouse_entered():
	if not self._book_opened:
		self._book_opened = true
		_current_active_page.input_pickable = true
		emit_signal("book_opened")

func close():
	_book_opened = false
	_current_active_page.input_pickable = false
