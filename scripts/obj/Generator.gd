extends Node2D
class_name Generator

signal bought(old_amt, new_amt)

var _amt: int = 0
export var power_consumption_per_gen: int = 0
export var power_per_gen: int = 1
export var orbital_trigger_angle: float = 0.0
export var cost_scale: float = 1.2
export var initial_cost = [0, 1]
export var enabled: bool = true setget set_enabled

export var tooltip_name: String = "Generator Name"
export var tooltip_flavor: String = "Flavor Text"

# Called when the node enters the scene tree for the first time.
func _ready():
	if not enabled:
		hide()
		$Button.disabled = true

func next_cost() -> int:
	if _amt < initial_cost.size():
		return initial_cost[_amt]
	return int(initial_cost[-1] * pow(cost_scale, _amt - initial_cost.size() + 1))

func amt() -> int:
	return _amt

func _on_Button_pressed():
	if CurrencyService.spend_if_possible(Globals.CURR_LORE, next_cost()):
		_amt += 1
		emit_signal("bought", _amt - 1, _amt)

func _on_orbital_updated(id, old_rotation, new_rotation):
	if not enabled:
		return
	if id != 1:
		return
	# case 1: standard move past trigger angle
	# case 2: full rotation completed and overflow
	var entered = (new_rotation >= orbital_trigger_angle &&
			(old_rotation < orbital_trigger_angle || old_rotation > new_rotation))
	if entered:
		CurrencyService.gain(Globals.CURR_LORE, _amt * power_per_gen)
		

func set_enabled(is_enabled: bool):
	enabled = is_enabled
	if is_enabled:
		show()
		$Button.disabled = false
	else:
		hide()
		$Button.disabled = true
		
func make_tooltip(_text: String) -> Control:
	var tooltipRoot = preload("res://scenes/GeneratorTooltip.tscn").instance()
	var tooltip = tooltipRoot.get_node("Panel")
	tooltip.get_node("Name").bbcode_text = "[b]%s[/b]" % tooltip_name
	
	var flavor = "[i][color=#%s]%s[/color][/i]" % [Globals.COLOR_FLAVOR.to_html(), tooltip_flavor]
	var description: String
	if power_consumption_per_gen == 0:
		description = "Generates %s  %s  (%s each)" % [
			Formatter.format_number(_amt * power_per_gen), 
			Globals.CURR_LORE.bbcode_with_name(tooltip.get_node("FlavorAndDesc")),
			Formatter.format_number(power_per_gen)
		]
	else:
		description = "Consumes %s  %s  to generate %s (-%s/+%s each)" % [
			Formatter.format_number(_amt * power_consumption_per_gen),
			Globals.CURR_LORE.bbcode_with_name(tooltip.get_node("FlavorAndDesc")),
			Formatter.format_number(_amt * power_per_gen),
			Formatter.format_number(power_consumption_per_gen),
			Formatter.format_number(power_per_gen)
		]
	tooltip.get_node("FlavorAndDesc").bbcode_text = "%s\n%s" % [flavor, description]
	tooltip.get_node("CostStats/Amt").bbcode_text = "%s " % [
		Globals.CURR_LORE.bbcode(tooltip.get_node("CostStats/Amt"), "%s " % Formatter.format_number(next_cost()), ""),
	]
	tooltip.get_node("OwnedStats/Amt").bbcode_text = Formatter.format_number(_amt)
	return tooltipRoot
