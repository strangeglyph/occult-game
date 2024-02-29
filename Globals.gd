extends Node


const COLOR_FLAVOR: Color = Color("#c4c4c4")
const COLOR_COMET: Color = Color.darkgray

var LORE_INFO = IconInfo.new("Lore", Color("#a500bc"), load("res://img/lore.svg"))

var BOOST_INITIATION = Boost.new(
	"Initiation",
	"An irrevocable shift in perspective",
	"Begin a new chapter of your journey",
	load("res://icon.png"),
	[CurrencyAmount.new(CurrencyService.Type.LORE, 10)]
)
