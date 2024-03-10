extends Object

class_name Currency

var name: String
var flavor: String
var color: Color
var icon: Texture

func _init(name: String, flavor, color: Color, icon: Texture):
	self.name = name
	self.flavor = flavor
	self.color = color
	self.icon = icon
	

func bbcode(label: RichTextLabel, prefix: String, postfix: String):
	return "[color=#%s]%s[img=%d]%s[/img]%s[/color]" % [
		color.to_html(),
		prefix,
		label.get_font("normal_font").get_height() - 7,
		icon.resource_path,
		postfix
	]	

# Does not append to label, just uses the label to get font height info
func bbcode_with_name(label: RichTextLabel):
	return bbcode(label, "", " %s" % name)

func bbcode_icon_only(label: RichTextLabel):
	return bbcode(label, "", "")
