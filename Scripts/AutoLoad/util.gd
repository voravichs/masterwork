extends Node

enum GAME_SCENES {
	GAME,
	MENU
}

enum PatternType {
	TETRAGRAM,
	TETRAGRAM_PLUS,
	HEXAGRAM,
	OCTAGRAM
}

enum ItemType {
	UPGRADE,
	PUZZLE
}

enum FileEntryType {
	FOLDER,
	FILE
}

const SYMBOL_CANVAS_DATA = {
	PatternType.TETRAGRAM: {
		"num_dots": 4,
		"coords": [
			Vector2(-25,-25),
			Vector2(25,-25),
			Vector2(-25,25),
			Vector2(25,25),
		]
	},
	PatternType.TETRAGRAM_PLUS: {
		"num_dots": 5,
		"coords": [
			Vector2(-25,-25),
			Vector2(25,-25),
			Vector2(-25,25),
			Vector2(25,25),
			Vector2(0,0)
		]
	},
	PatternType.HEXAGRAM: {
		"num_dots": 6,
		"coords": [
			Vector2(0, -25),
			Vector2(21.65, -12.5),
			Vector2(21.65, 12.5),
			Vector2(0, 25),
			Vector2(-21.65, 12.5),
			Vector2(-21.65, -12.5)
		]
	},
	PatternType.OCTAGRAM: {
		"num_dots": 8,
		"coords": [
			Vector2(0, -30),
			Vector2(21.21, -21.21),
			Vector2(30, 0),
			Vector2(21.21, 21.21),
			Vector2(0, 30),
			Vector2(-21.21, 21.21),
			Vector2(-30, 0),
			Vector2(-21.21, -21.21)
		]
	}
}

func get_symbol_info(symbol_type: PatternType) -> Dictionary:
	if SYMBOL_CANVAS_DATA.has(symbol_type):
		return SYMBOL_CANVAS_DATA[symbol_type]
	return {}
