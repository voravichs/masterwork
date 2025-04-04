extends Node

var spritesheet : Texture = preload("res://Assets/Sprites/mw_letters_FULL.png")
var RNG : RandomNumberGenerator = RandomNumberGenerator.new()
var DEBUG_CHAR_SPEED: int = 300
var OCCUPIED: bool = false
var MAX_INVENTORY_SLOTS : int = 12

var CHARACTER_MAP : Dictionary = {
	"A": 0, "B": 1, "C": 2, "D": 3, "E": 4, "F": 5, "G": 6, "H": 7,
	"I": 8, "J": 9, "K": 10, "L": 11, "M": 12, "N": 13, "O": 14, "P": 15,
	"Q": 16, "R": 17, "S": 18, "T": 19, "U": 20, "V": 21, "W": 22, "X": 23,
	"Y": 24, "Z": 25, ".": 26, " ": 27, "<": 28, ">": 29
}

var DISCOVERED_CHARACTER : Dictionary = {
	"A": false, "B": false, "C": false, "D": false, "E": false, 
	"F": false, "G": false, "H": false, "I": false, "J": false, 
	"K": false, "L": false, "M": false, "N": false, "O": false, 
	"P": false, "Q": false, "R": false, "S": false, "T": false, 
	"U": false, "V": false, "W": false, "X": false, "Y": false, 
	"Z": false, ".": true, " ": true, "<": true, ">": true
}

func GET_LETTER_TEXTURE(char_display: String, dimensions: int) -> AtlasTexture:
	var index : int = CHARACTER_MAP.get(char_display, -1)
	
	if index != -1:
		var x : int = (index % CHARACTER_MAP.size()) * dimensions
		var y : int = (1 if DISCOVERED_CHARACTER.get(char_display) else 0)  * dimensions
		var atlas_tex : AtlasTexture = AtlasTexture.new()
		atlas_tex.atlas = spritesheet
		atlas_tex.region = Rect2(Vector2(x, y), Vector2(dimensions, dimensions))
		return atlas_tex
	return null
