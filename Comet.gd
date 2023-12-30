extends Node2D


const STEEPNESS_LOWER_BOUND = .25
const STEEPNESS_UPPER_BOUND = 4
const Y_OFFSET_LOWER_BOUND_FRAC = 0.01 # of viewport height
const Y_OFFSET_UPPER_BOUND_FRAC = 0.25 # of viewport height

const STEPS: int = 150
const STROKE_LEN: int = 15
const STROKE_LEN_SQ = STROKE_LEN * STROKE_LEN
const _STROKE_EPS: float = 1.0
const _MAX_ITERATIONS = 10

const _POINTS: Array = []
const _CUMULATIVE_DISTANCE: Array = []

const _NAME_OPTS: Array = [
	"Kepler",
	"Sagittarius",
	"Trismegistus",
	"Agrippa",
]

const _SUFFIX_OPTS: Array = [
	"(i)",
	"(ii)",
	"(iii)",
	"(iv)",
	"-a",
	"-b",
	"-c",
	"α",
	"β",
	"γ",
	"δ",
	"ζ",
	"η",
	"λ",
	"μ",
	"ω",
	"א",
	"ב",
	"ג‎",
	"ד",
	"ה‎",
	" (pres.)", # presumed
	" (pred.)", # predicted
	" (cont.)", # contested
]

var name: String = ""

export var randomize_transform = false
var _steepness = 1.0


export var path_fade_in_time = 4.0
export var travel_time = 20.0
var _speed: float # per unit of time
var _elapsed_time = 0
var _comet_idx = 0
var _clicked = false
var _at_end = false
var _end_signalled = false

signal comet_clicked
signal comet_passed(comet, has_been_clicked)


# Called when the node enters the scene tree for the first time.
func _ready():
	if _POINTS.size() == 0:
		regenerate_points(1024)
	if randomize_transform:
		randomize_transform()
	randomize_name()
	_speed = _CUMULATIVE_DISTANCE[-1] / travel_time
	$Comet.position = _next_comet_point()
		
func randomize_transform():
	self.position.y -= rand_range(Y_OFFSET_LOWER_BOUND_FRAC, Y_OFFSET_UPPER_BOUND_FRAC) * get_viewport().size.y
	self.rotation = rand_range(0.0, 360.0)
	self._steepness = rand_range(STEEPNESS_LOWER_BOUND, STEEPNESS_UPPER_BOUND)

func randomize_name():
	var core = 
	
func _process(delta: float):
	_elapsed_time += delta
	if _elapsed_time <= path_fade_in_time:
		update()
	if not _at_end:
		_update_comet_pos(delta)	
	if _at_end and not _end_signalled:
		emit_signal("comet_passed", self, _clicked)
		_end_signalled = true

func _update_comet_pos(delta: float):
	var dist = _speed * delta
	
	var to = _next_comet_point()
	var remaining_in_segment_sq = $Comet.position.distance_squared_to(to)
	if remaining_in_segment_sq < (dist*dist):
		if _comet_idx < _POINTS.size() - 1:
			_comet_idx += 1
			to = _next_comet_point()
		else:
			_at_end = true
		
	$Comet.position = $Comet.position.move_toward(to, dist)
	$Comet.position.y = _steepness * _at_x($Comet.position.x)
	var derivative = -2 * _steepness * 0.001 * $Comet.position.x
	$Comet.rotation = Vector2(-1, -derivative).angle()

func _draw():
	var elapsed_frac = _elapsed_time / path_fade_in_time
	var cutoff_dist = _CUMULATIVE_DISTANCE[-1] * elapsed_frac
	
	for i in range(1, _POINTS.size()):
		if i % 2 == 0:
			continue
		
		var from = _POINTS[i-1]
		var to = _POINTS[i]
		from.y *= _steepness
		to.y *= _steepness
		
		var cum_dist_so_far = _CUMULATIVE_DISTANCE[i]
		if cum_dist_so_far >= cutoff_dist:
			var remaining = cutoff_dist - _CUMULATIVE_DISTANCE[i-1]
			if remaining > 0:
				draw_line(from, from.move_toward(to, remaining), Globals.COLOR_COMET, 1, true)
			return
		else:
			draw_line(from, to, Globals.COLOR_COMET, 1, true)
			
func regenerate_points(width: int):
	_POINTS.clear()
	_CUMULATIVE_DISTANCE.clear()
	
	var toX = 1.1 * (width / 2) 
	var fromX = -toX
	
	var currentPos = Vector2(fromX, _at_x(fromX))
	var currentCumDist = 0.0
	_POINTS.append(currentPos)
	_CUMULATIVE_DISTANCE.append(0.0)
	
	while currentPos.x < toX:
		var nextPos = _next_point(currentPos)
		var dist = currentPos.distance_to(nextPos)

		_POINTS.append(nextPos)
		_CUMULATIVE_DISTANCE.append(currentCumDist + dist)
		
		currentPos = nextPos
		currentCumDist += dist
					

func _next_comet_point() -> Vector2:
	var point = _POINTS[_comet_idx]
	point.y *= _steepness
	return point

# Pick the next point such that the euclidean distance between current and next
# is approximately `stroke_len`
# Approximately log(stroke_len) tries, bounded by `_max_iterations`
func _next_point(current: Vector2) -> Vector2:
	var lower: Vector2 = current
	var upper = Vector2(current.x + STROKE_LEN, _at_x(current.x + STROKE_LEN))
	
	var candidate: Vector2
	
	for i in range(_MAX_ITERATIONS):
		candidate = (lower + upper) / 2
		var dist_sq = current.distance_squared_to(candidate)
	
		if dist_sq < STROKE_LEN_SQ - _STROKE_EPS:
			lower = candidate
		elif dist_sq > STROKE_LEN_SQ + _STROKE_EPS:
			upper = candidate
		else:
			break
			
	return candidate


func _at_x(x: float) -> float:
	return -0.001*x*x

# set to false has no effect	
func click():
	if _clicked:
		return
	_clicked = true
	$Comet/Sprite.modulate = Color.darkgray
	emit_signal("comet_clicked")


func _on_Comet_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			click()
