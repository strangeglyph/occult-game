extends KinematicBody2D


var _num_runes = 35
var next_rune = 0

var _tweens = []

signal rune_drawn
signal page_filled

func _ready():
	reinit_runes()
	init_tweens()

func get_rune(i):
	return get_child(i)

func reinit_runes():
	for i in range(0, _num_runes):
		_reinit_rune(i)
		
func _reinit_rune(idx):
	var rune = get_rune(idx)
	rune.rotation_degrees = rand_range(-5, 5)
	rune.scale.x = rand_range(.47, .53)
	rune.scale.y = rand_range(.47, .53)
	rune.modulate = Globals.COLOR_INK
	rune.visible = false
	rune.playing = false
	rune.frame = 0
	
func init_tweens():
	for i in range(0, _num_runes):
		_tweens.push_back(get_tree().create_tween())
		
func _init_tween(idx):
	var rune = get_rune(idx)
	var tween = get_tree().create_tween()
		
	tween.tween_property(rune, "modulate", Globals.COLOR_INK_ACTIVE, .25)\
		.set_trans(Tween.TRANS_EXPO)\
		.set_ease(Tween.EASE_IN)
	tween.tween_property(rune, "modulate", Color.white, .125)\
		.set_trans(Tween.TRANS_LINEAR)\
		.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(rune, "modulate", Globals.COLOR_INK_ACTIVE_TRANS, 1)\
		.set_trans(Tween.TRANS_EXPO)\
		.set_ease(Tween.EASE_OUT)
	tween.tween_callback(self, "_reinit_rune", [idx])
	_tweens[idx] = tween
	
	
func draw_next_rune():
	if next_rune < _num_runes:
		var tween = _tweens[next_rune]
		if tween.is_running():
			tween.kill()
			_reinit_rune(next_rune)
			
		var rune = get_rune(next_rune)
		rune.visible = true
		rune.playing = true
		next_rune += 1
		emit_signal("rune_drawn")

func page_completed():
	emit_signal("page_filled")
	next_rune = 0
	for i in range(0, _num_runes):
		_init_tween(i)

		
func _on_WritingPage_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			draw_next_rune()
			if next_rune == _num_runes:
				page_completed()

