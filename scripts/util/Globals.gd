extends Node


const COLOR_FLAVOR: Color = Color("#c4c4c4")
const COLOR_COMET: Color = Color.darkgray
const COLOR_CHANNEL_CIRCLE_HINT: Color = COLOR_COMET
const COLOR_CHANNEL_CIRCLE_ACTIVE_CHANNEL = Color.goldenrod
const COLOR_CHANNEL_CIRCLE_DROP_HINT = Color.cyan
const COLOR_INK: Color = Color("#050546")
const COLOR_INK_ACTIVE: Color = Color.gold
const COLOR_INK_ACTIVE_TRANS: Color = Color(COLOR_INK_ACTIVE.r, COLOR_INK_ACTIVE.g, COLOR_INK_ACTIVE.b, 0.0)


var CURR_LORE = Currency.new(
	"Lore", 
	"Old tomes, new blog posts - knowledge comes from unexpected places",
	Color("#a500bc"), 
	load("res://img/lore.svg")
)

var CURR_INSIGHT = Currency.new(
	"Insight",
	"Understanding dawns, and recontextualizes everything",
	Color("#db5c07"),
	load("res://icon.png")
)

var CURR_IMPRESSIONS = Currency.new(
	"Impressions",
	"Memories fade",
	Color("#0e408f"),
	load("res://icon.png")
)

var CURR_DREAMS = Currency.new(
	"Dreams",
	"The subconcious knows. The subconcious [i]remembers[/i]",
	Color("#0e7e8f"),
	load("res://icon.png")
)


var BOOST_INITIATION = Boost.new(
	"Initiation",
	"An irrevocable shift in perspective",
	"Begin a new chapter of your journey",
	load("res://icon.png"),
	[CurrencyAmount.new(CURR_LORE, 10)]
)
