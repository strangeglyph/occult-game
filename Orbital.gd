extends Sprite

signal orbital_updated(id, old_rotation, new_rotation)

export var orbital_id = 1
const base_orbital_period_secs: int = 60
export var orbital_period_factor: float = 1

onready var _globals = $"/root/Game"

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	delta = delta * _globals.game_speed_factor
	var fract_revolution = delta / (base_orbital_period_secs * orbital_period_factor)
	var old_rotation = self.rotation_degrees
	self.rotation_degrees += 360 * fract_revolution
	self.rotation_degrees = fmod(self.rotation_degrees, 360)
	emit_signal("orbital_updated", orbital_id, old_rotation, self.rotation_degrees)
