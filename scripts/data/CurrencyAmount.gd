extends Object

class_name CurrencyAmount

var currency: Currency
var amount: int

func _init(currency: Currency, amount: int):
	self.currency = currency
	self.amount = amount


func to_bbcode(label: RichTextLabel):
	return "%s %s" % [
		currency.bbcode_icon_only(label),
		Formatter.format_number(amount)
	]
