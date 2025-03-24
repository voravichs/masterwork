extends Control

@onready var timer: Timer = $Timer

var spritesheet = preload("res://Assets/Sprites/mw_letters.png")
var text_to_display = ""
var current_index = 0
var character_mapping = {
	"A": 0, "B": 1, "C": 2, "D": 3, "E": 4, "F": 5, "G": 6, "H": 7,
	"I": 8, "J": 9, "K": 10, "L": 11, "M": 12, "N": 13, "O": 14, "P": 15,
	"Q": 16, "R": 17, "S": 18, "T": 19, "U": 20, "V": 21, "W": 22, "X": 23,
	"Y": 24, "Z": 25, ".": 26, " ": 27
}

const SPRITE_WIDTH = 40
const SPRITE_HEIGHT = 40
const num_columns = 28

func display_text(text: String):
	text_to_display = text.to_upper()
	current_index = 0
	for child in get_children():
		if child != timer:
			child.queue_free()
	timer.start()

func get_letter_texture(char: String) -> AtlasTexture:
	var index = character_mapping.get(char, null)
	if index != null:
		var x = (index % num_columns) * SPRITE_WIDTH
		var y = (index / num_columns) * SPRITE_HEIGHT
		var atlas_tex = AtlasTexture.new()
		atlas_tex.atlas = spritesheet
		atlas_tex.region = Rect2(Vector2(x, y), Vector2(SPRITE_WIDTH, SPRITE_HEIGHT))
		return atlas_tex
	return null


func _on_timer_timeout() -> void:
	if current_index < text_to_display.length():
		var char = text_to_display[current_index]
		var letter_texture = get_letter_texture(char)
		if letter_texture:
			var letter_rect = TextureRect.new()
			letter_rect.texture = letter_texture
			add_child(letter_rect)
		current_index += 1
	else:
		timer.stop()
