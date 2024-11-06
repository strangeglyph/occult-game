extends KinematicBody2D


var _num_runes = 35
var next_rune = 0

var _tweens = []


const _TEXT = "Thou who openeth this tome, we beg of thee: Desist. Naught but pain and sorrow "\
	+ "awaiteth thee, dear reader; neither gain nor honor are bound within these pages. "\
	+ "Heed this warning of us who were considered wise and powerful: What is written here "\
	+ "is dangerous and repulsive."
var _text_idx = 0
var _text_buffer = 0

export(Array, SpriteFrames) var letter_runes = []
export(SpriteFrames) var terminator_rune = load("img/runes/urbit_anim/urbit_anim.tres")

signal rune_drawn
signal page_filled

func _ready():
	_text_idx = rand_range(0, _TEXT.length())
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
	
	if _text_buffer == 0:
		rune.frames = terminator_rune
		for i in range(0, 4):
			var next_byte = _TEXT.ord_at(_text_idx)
			_text_idx += 1
			if _text_idx == _TEXT.length():
				_text_idx = 0
				
			_text_buffer += next_byte << (8 * i)
	else:
		var next_rune_shape = letter_runes[_text_buffer % letter_runes.size()]
		_text_buffer /= letter_runes.size()
		rune.frames = next_rune_shape
	
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
	tween.tween_property(rune, "modulate", Globals.COLOR_INK_ACTIVE_TRANS, .25)\
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

