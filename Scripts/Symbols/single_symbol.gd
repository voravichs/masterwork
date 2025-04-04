extends Control

@export var char_display : String
@export var dimensions: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var letter_texture = Global.GET_LETTER_TEXTURE(char_display, dimensions)
	if letter_texture:
		var letter_rect = TextureRect.new()
		letter_rect.texture = letter_texture
		add_child(letter_rect)
