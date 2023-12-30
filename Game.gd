extends Node2D

export var game_speed_factor: int = 60

var _flip_comet = false
var _comets_clicked = 0
var _comets_missed = 0
var _comets_active = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_setup_console()
	
	_connect_generator($Candle)
	$Candle.connect("bought", self, "_on_candle_bought")
	_connect_generator($Geometry)
	

func _set_game_speed(speed: int):
	if speed < 1:
		Console.write_line("Cannot reduce gamespeed below 1")
		return
	game_speed_factor = speed

# For console command
func _gain_currency(type: String, amt: int):
	if type == "lore":
		CurrencyService.gain(CurrencyService	.Type.LORE, amt)
	else:
		Console.write_line("Unknown currency: " + type)

func _setup_console():
	Console.add_command("dothetimewarpagain", self, "_set_game_speed")\
			.set_description("Change game speed")\
			.add_argument("speed", TYPE_INT)\
			.register()
			
	Console.add_command("fromtheaether", self, "_gain_currency")\
			.set_description("Gain (or lose) things")\
			.add_argument("type", Console.FilterType.new(["lore"], Console.FilterType.MODE.ALLOW))\
			.add_argument("amt", TYPE_INT)\
			.register()
			
	Console.add_command("goodomens", self, "_spawn_comet")\
			.register()

func _connect_generator(gen: Generator):
	$Orbital1.connect("orbital_updated", gen, "_on_orbital_updated")

func _on_candle_bought(old_amt, new_amt):
	$Orbital1.visible = true
	$Orbital1.set_process(true)
	if new_amt == 2:
		$Geometry.enabled = true

func _on_comet_clicked():
	_comets_clicked += 1
	Console.write_line("comets clicked: " + str(_comets_clicked))

func _on_comet_passed(comet, clicked: bool):
	_comets_active -= 1
	if not clicked:
		_comets_missed -= 1
		Console.write_line("comets missed: " + str(_comets_missed))
	remove_child(comet)

func _spawn_comet():
	var comet = preload("res://Comet.tscn").instance()
	comet.position = $Circle.position
	comet.randomize_transform = true
	if _flip_comet:
		comet.scale.x *= -1
	comet.connect("comet_clicked", self, "_on_comet_clicked")
	comet.connect("comet_passed", self, "_on_comet_passed")
	_comets_active += 1
	add_child(comet)
