extends Node


const COLOR_FLAVOR: Color = Color("#c4c4c4")
const COLOR_COMET: Color = Color.darkgray

var CURR_LORE = Currency.new(
	"Lore", 
	"Old tomes, new blog posts - knowledge comes from unexpected places",
	Color("#a500bc"), 
	load("res://img/lore.svg")
)

var BOOST_INITIATION = Boost.new(
	"Initiation",
	"An irrevocable shift in perspective",
	"Begin a new chapter of your journey",
	load("res://icon.png"),
	[CurrencyAmount.new(CURR_LORE, 10)]
)
