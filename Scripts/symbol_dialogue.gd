extends Control

@onready var timer: Timer = $Timer

var spritesheet = preload("res://Assets/Sprites/mw_letters_FULL.png")
var text_to_display = ""
var current_index = 0

var skip : bool
var is_typing : bool

const SPRITE_WIDTH = 40
const SPRITE_HEIGHT = 40
const num_columns = 28

func display_text(text: String):
	text_to_display = text.to_upper()
	current_index = 0
	for child in get_children():
		if child != timer:
			child.queue_free()
	is_typing = true
	timer.start()

func get_letter_texture(char_display: String) -> AtlasTexture:
	var index = Global.CHARACTER_MAP.get(char_display, null)
	if index != null:
		var x = (index % num_columns) * SPRITE_WIDTH
		var y = (1 if Global.DISCOVERED_CHARACTER.get(char_display) else 0)  * SPRITE_HEIGHT
		var atlas_tex = AtlasTexture.new()
		atlas_tex.atlas = spritesheet
		atlas_tex.region = Rect2(Vector2(x, y), Vector2(SPRITE_WIDTH, SPRITE_HEIGHT))
		return atlas_tex
	return null


func _on_timer_timeout() -> void:
	if current_index < text_to_display.length():
		if skip:
			for n in range(current_index,text_to_display.length()):
				var char_display = text_to_display[current_index]
				var letter_texture = get_letter_texture(char_display)
				if letter_texture:
					var letter_rect = TextureRect.new()
					letter_rect.texture = letter_texture
					add_child(letter_rect)
				current_index += 1
			timer.stop()
			is_typing = false
			skip = false
		else:
			var char_display = text_to_display[current_index]
			var letter_texture = get_letter_texture(char_display)
			if letter_texture:
				var letter_rect = TextureRect.new()
				letter_rect.texture = letter_texture
				add_child(letter_rect)
			current_index += 1
	else:
		timer.stop()
		is_typing = false
		skip = false
