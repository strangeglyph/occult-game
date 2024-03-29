extends Node

signal currency_updated(type, old, new)

var _currencies = {
	Globals.CURR_LORE: 0,
	Globals.CURR_IMPRESSIONS: 0,
	Globals.CURR_DREAMS: 0,
	Globals.CURR_INSIGHT: 0
}


# See if this much currency can be spent, and do so if possible
func spend_if_possible(type: Currency, amt: int) -> bool:
	if _currencies[type] < amt:
		return false
	var old = _currencies[type]
	_currencies[type] -= amt
	emit_signal("currency_updated", type, old, old - amt)
	return true
	
func gain(type: Currency, amt: int):
	var old = _currencies[type]
	_currencies[type] += amt
	emit_signal("currency_updated", type, old, old + amt)

func lookup(type: Currency) -> int:
	return _currencies[type]
	
# Spend `amt` currency. up to its current value
# Returns `true` if the full amount was spent, `false` otherwise
func spend_or_drain(type: Currency, amt: int) -> bool:
	var old = _currencies[type]
	if old < amt:
		_currencies[type] = 0
		emit_signal("currency_updated", type, old, 0)
		return false
	else:
		_currencies[type] -= amt
		emit_signal("currency_updated", type, old, old - amt)
		return true
