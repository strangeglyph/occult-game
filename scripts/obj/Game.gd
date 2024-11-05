extends Node2D

export var game_speed_factor: int = 60


var _Card: PackedScene = preload("res://scenes/Card.tscn") 

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
	
	$Orbital1.connect("orbital_period_passed", self, "_on_inner_period_passed")
	
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
	Console.write_line("Candle bought")
	if new_amt == 1:
		$Tween.interpolate_method($OverlayLayer/Shadow, "set_radius", 0.013, 0.125, 
			1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT);
		$Tween.interpolate_method($OverlayLayer/Shadow, "set_penumbra_size", 1, 0.3,
			1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT);
		$Tween.interpolate_method($OverlayLayer/Shadow, "set_color", Color.black, Color(0.1, 0.1, 0.1, 0.9),
			1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT);
		$Tween.start()
	if new_amt == 2:
		$Tween.interpolate_method($OverlayLayer/Shadow, "set_radius", 0.125, 0.25, 
			1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT);
		$Tween.interpolate_method($OverlayLayer/Shadow, "set_penumbra_size", 0.3, 0.2,
			1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT);
		$Tween.interpolate_method($OverlayLayer/Shadow, "set_color", Color(0.1, 0.1, 0.1, 0.9), Color(0.3, 0.3, 0.3, 0.7),
			1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT);
		$Tween.start()
	if new_amt == 3:
		$Tween.interpolate_method($OverlayLayer/Shadow, "set_radius", 0.25, 1, 
			1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT);
		$Tween.interpolate_method($OverlayLayer/Shadow, "set_penumbra_size", 0.2, 0.0,
			1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT);
		$Tween.interpolate_method($OverlayLayer/Shadow, "set_color", Color(0.3, 0.3, 0.3, 0.7), Color(1.0, 1.0, 1.0, 0.0),
			1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT);
		$Tween.interpolate_callback($OverlayLayer/Shadow, 1.0, "queue_free")
		$Tween.start()
	# $Orbital1.visible = true
	# $Orbital1.set_process(true)
	# if new_amt == 2:
	#	$Geometry.enabled = true

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
	var comet = preload("res://scenes/Comet.tscn").instance()
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
	
func _on_inner_period_passed(__id):
	var dreams = CurrencyService.lookup(Globals.CURR_DREAMS)
	var to_fade = ceil(dreams / 10.0)
	CurrencyService.spend_or_drain(Globals.CURR_DREAMS, to_fade)
	
	var impressions = CurrencyService.lookup(Globals.CURR_IMPRESSIONS)
	if impressions > 10:
		var to_convert = impressions / 10
		CurrencyService.spend_or_drain(Globals.CURR_IMPRESSIONS, to_convert)
		CurrencyService.gain(Globals.CURR_DREAMS, to_convert)
	
	var lore = CurrencyService.lookup(Globals.CURR_LORE)
	if lore > 10:
		var to_convert = lore / 10
		CurrencyService.spend_or_drain(Globals.CURR_LORE, to_convert)
		CurrencyService.gain(Globals.CURR_IMPRESSIONS, to_convert)
