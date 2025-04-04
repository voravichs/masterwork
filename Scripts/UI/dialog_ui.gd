extends Control
class_name DialogueUI 

@onready var portrait: TextureRect = %Portrait
@onready var portrait_name: RichTextLabel = %PortraitName
@onready var dialogue_line: DialogueLabel = %DialogueLine
@onready var dialogue_options: GridContainer = %DialogueOptions
@onready var choice_button_scn : PackedScene = preload("res://Scenes/UI/choice_button.tscn")
@onready var symbol_dialogue : Control  = %SymbolDialogue

var waiting_on_decision: bool = false
var portrait_db_ref : Script
var line : DialogueLine
var dialogue_resource : DialogueResource
var vocal_beep : SoundEffect.SOUND_EFFECT_TYPE

const DIALOGUE_FILE = "res://Dialogues/test_dialogue.dialogue"

# Emitted when dialogue is complete
signal finished_dialogue()

func with_data(input_dialogue_resource : DialogueResource, dialog_title : String, sfx: SoundEffect.SOUND_EFFECT_TYPE) -> DialogueUI:
	# Get the first line in the starting dialogue
	dialogue_resource = input_dialogue_resource
	vocal_beep = sfx
	line = await input_dialogue_resource.get_next_dialogue_line(dialog_title)
	return self

func _ready() -> void:
	# Preload portrait database
	portrait_db_ref = preload("res://Scripts/Data/portraits_db.gd")
	# For debug purposes
	if !line:
		var debug_dialogue_resource : DialogueResource = load(DIALOGUE_FILE)
		dialogue_resource = debug_dialogue_resource
		line = await debug_dialogue_resource.get_next_dialogue_line("null")
	if !vocal_beep:
		vocal_beep = SoundEffect.SOUND_EFFECT_TYPE.CAT_VOCAL_BEEP
	# Set that line to the dialogue box and type it out
	process_dialogue()
	# clear any previous options
	clear_options()

func _input(event: InputEvent) -> void:
	# Prevent input if next line is null
	if (line == null):
		finished_dialogue.emit()
		return
	if event.is_action_pressed("dialogic_default_action"):
		# Skip typing out if input detected while typing
		#if dialogue_line.is_typing:
			#dialogue_line.skip_typing()
			#return
		if symbol_dialogue.is_typing:
			symbol_dialogue.skip = true
			return
		# Prevent input if still waiting on a decision
		if waiting_on_decision:
			return
		# Get the next line
		line = await dialogue_resource.get_next_dialogue_line(line.next_id)
		# If end of dialogue, stop input
		if (line == null):
			dialogue_line.dialogue_line = line
			clear_options()
			finished_dialogue.emit()
			return
		# Process dialogue into DialogueLine and Portrait
		process_dialogue()
		# Show responses after typing complete if they exist
		if line.responses.size() > 0:
			waiting_on_decision = true
			dialogue_line.finished_typing.connect(_show_responses)

# Clear all previous options from the options container
func clear_options() -> void:
	var options_children : Array = dialogue_options.get_children()
	for child : Node in options_children:
		child.queue_free()

# sets the dialogue text to DialogueLine, and set the portrait
func process_dialogue() -> void:
	# Error checking for portrait and line's character
	if !portrait_db_ref.PORTRAITS.has(line.character):
		printerr("Bad portrait_db key")
		return
	# Set portrait
	portrait.set_portrait(portrait_db_ref.PORTRAITS[line.character][0])
	# Portrait name
	if line.character == "EMPTY":
		portrait_name.text = ""
	else:
		portrait_name.text = "[center]" + line.character 
	# Type out dialogue
	symbol_dialogue.display_text(line.text, vocal_beep)

# Changes the line and shows the responses in a formatted way
func _show_responses() -> void:
	for i in range(line.responses.size()):
		var btn_obj: ChoiceButton = choice_button_scn.instantiate()
		btn_obj.choice_index = i
		btn_obj.text = line.responses[i].text
		btn_obj.choice_selected.connect(_on_choice_selected)
		dialogue_options.add_child(btn_obj)

# Called when a dialogue choice is selected
func _on_choice_selected(choice_index: int) -> void:
	waiting_on_decision = false
	line = await dialogue_resource.get_next_dialogue_line(line.responses[choice_index].next_id)
	if (line == null):
		dialogue_line.dialogue_line = line
		clear_options()
		return
	process_dialogue()
	if line.responses.size() > 0:
		dialogue_line.finished_typing.connect(_show_responses)
	clear_options()
