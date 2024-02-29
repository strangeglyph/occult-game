extends Object

class_name IconInfo

var name: String
var color: Color
var icon: Texture

func _init(name: String, color: Color, icon: Texture):
	self.name = name
	self.color = color
	self.icon = icon
	
# Does not append to label, just uses the label to get font height info
func bbcode(label: RichTextLabel):
	return " [color=#%s][img=%d]%s[/img] %s[/color] " % [
		color.to_html(),
		label.get_font("normal_font").get_height() - 7,
		icon.resource_path,
		name
	]

