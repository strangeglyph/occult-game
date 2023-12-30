extends Control


export(CurrencyService.Type) var type: int
export var currency_name: String = "Name"
export var flavor: String = "Flavor"
export var color: Color = Color.wheat
export var icon: Texture = load("res://icon.png")
export var init_visible: bool = false

func _ready():
	$Icon.texture = icon
	
	$Name.clear()
	$Name.push_bold()
	$Name.push_color(color)
	$Name.add_text(name)
	
	$Count.clear()
	$Count.add_text(Formatter.format_number(CurrencyService.lookup(type)))
	
	CurrencyService.connect("currency_updated", self, "_on_currency_updated")
	
	if not init_visible:
		self.hide()


func _make_custom_tooltip(for_text):
	var tooltipRoot = preload("res://CurrencyHUDTooltip.tscn").instance()
	var name = tooltipRoot.get_node("Panel/Name")
	name.bbcode_text = "[b][color=#%s]%s[/color][/b]" % [self.color.to_html(), self.currency_name]
	
	var flavor = tooltipRoot.get_node("Panel/Flavor")
	flavor.bbcode_text = "[i][color=#%s]%s[/color][/i]" % [Globals.COLOR_FLAVOR.to_html(), self.flavor]
	
	return tooltipRoot

func _on_currency_updated(type: int, old: int, new: int):
	if type != self.type:
		return
	$Count.clear()
	$Count.add_text(Formatter.format_number(new))
	
	if new != 0 and not init_visible:
		self.show()
