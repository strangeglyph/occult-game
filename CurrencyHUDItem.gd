tool
extends Control


export(String, "Lore") var type_name: String
var type: Currency
export var init_visible: bool = false

func _ready():
	var internal_name = "CURR_%s" % type_name.to_upper().replace(" ", "_")
	assert(internal_name in Globals)
	type = Globals.get(internal_name)	

	$Icon.texture = type.icon
	
	$Name.clear()
	$Name.push_bold()
	$Name.push_color(type.color)
	$Name.add_text(type.name)
	
	$Count.clear()
	$Count.add_text(Formatter.format_number(CurrencyService.lookup(type)))
	
	CurrencyService.connect("currency_updated", self, "_on_currency_updated")
	
	if not init_visible:
		self.hide()


func _make_custom_tooltip(for_text):
	var tooltipRoot = preload("res://CurrencyHUDTooltip.tscn").instance()
	var name = tooltipRoot.get_node("Panel/Name")
	name.bbcode_text = "[b][color=#%s]%s[/color][/b]" % [self.type.color.to_html(), self.type.name]
	
	var flavor = tooltipRoot.get_node("Panel/Flavor")
	flavor.bbcode_text = "[i][color=#%s]%s[/color][/i]" % [Globals.COLOR_FLAVOR.to_html(), self.type.flavor]
	
	return tooltipRoot

func _on_currency_updated(type: Currency, old: int, new: int):
	if type != self.type:
		return
	$Count.clear()
	$Count.add_text(Formatter.format_number(new))
	
	if new != 0 and not init_visible:
		self.show()
