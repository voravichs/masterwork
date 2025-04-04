extends Control

@onready var timer: Timer = $Timer

var text_to_display : String = ""
var current_index : int = 0
var skip : bool
var is_typing : bool
var vocal_beep : SoundEffect.SOUND_EFFECT_TYPE

const CHAR_DIMENSIONS = 40

func display_text(text: String, sfx: SoundEffect.SOUND_EFFECT_TYPE) -> void:
	text_to_display = text.to_upper()
	vocal_beep = sfx
	current_index = 0
	for child in get_children():
		if child != timer:
			child.queue_free()
	is_typing = true
	timer.start()

func _type_out_symbols() -> void:
	if current_index < text_to_display.length():
		if skip:
			for n in range(current_index,text_to_display.length()):
				var char_display : String = text_to_display[current_index]
				var letter_texture : Texture = Global.GET_LETTER_TEXTURE(char_display, CHAR_DIMENSIONS)
				if letter_texture:
					var letter_rect : TextureRect = TextureRect.new()
					letter_rect.texture = letter_texture
					add_child(letter_rect)
				current_index += 1
			timer.stop()
			is_typing = false
			skip = false
		else:
			var char_display : String = text_to_display[current_index]
			var letter_texture : Texture = Global.GET_LETTER_TEXTURE(char_display, CHAR_DIMENSIONS)
			if letter_texture:
				var letter_rect : TextureRect = TextureRect.new()
				letter_rect.texture = letter_texture
				AudioManager.create_audio(vocal_beep)
				add_child(letter_rect)
			current_index += 1
	else:
		timer.stop()
		is_typing = false
		skip = false
