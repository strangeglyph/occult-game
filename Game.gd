extends Node2D

export var game_speed_factor: int = 60


var _Card: PackedScene = preload("res://Card.tscn") 

var _flip_comet = false
var _comets_clicked = 0
var _comets_missed = 0
var _comets_active = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	_setup_console()
	
	_connect_generator($Candle)
	$Candle.connect("bought", self, "_on_candle_bought")
	_connect_generator($Geometry)
	
	create_card_from_boost(Globals.BOOST_INITIATION)
	

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
	
func create_card_from_boost(boost: Boost):
	var card = _Card.instance()
	var panel = card.get_node("Panel")
	panel.get_node("Name").bbcode_text = "[center][b]%s[/b][/center]" % boost.name
	
	var flavor = "[i][color=#%s]%s[/color][/i]" % [Globals.COLOR_FLAVOR.to_html(), boost.flavor]
	var description = boost.description
	panel.get_node("FlavorAndDesc").bbcode_text = "%s\n%s" % [flavor, description]
	
	panel.get_node("Icon").texture = boost.image
	
	var cost_lbl = panel.get_node("Cost")
	var cost = ""
	var first = true
	for curr_amt in boost.cost:
		if not first:
			curr_amt += "  "
		else:
			first = false
		
		cost += curr_amt.currency.bbcode(cost_lbl, "%s " % Formatter.format_number(curr_amt.amount), "")
			
	cost_lbl.bbcode_text = cost
	
	card.position.x = 150
	card.position.y = 300
	add_child(card)
	
