class_name DialogueUI extends CanvasLayer

@onready var portrait: TextureRect = %Portrait
@onready var portrait_name: RichTextLabel = %PortraitName
@onready var dialogue_line: DialogueLabel = %DialogueLine
@onready var dialogue_options: GridContainer = %DialogueOptions
@onready var choice_button_scn = preload("res://Scenes/UI/choice_button.tscn")
@onready var vocal_beep: AudioStreamPlayer = %VocalBeep
@onready var symbol_dialogue = %SymbolDialogue

var waiting_on_decision: bool = false
var portrait_db_ref
var line : DialogueLine
var dialogue_resource
var cat_vocal_beep = preload("res://Assets/Sounds/SFX/catvocalbeep.mp3")

const DIALOGUE_FILE = "res://Dialogues/test_dialogue.dialogue"

# Emitted when dialogue is complete
signal finished_dialogue()

func with_data(input_dialogue_resource, dialog_title) -> DialogueUI:
	# Get the first line in the starting dialogue
	dialogue_resource = input_dialogue_resource
	line = await input_dialogue_resource.get_next_dialogue_line(dialog_title)
	return self

func _ready() -> void:
	# Preload portrait database
	portrait_db_ref = preload("res://Scripts/Data/portraits_db.gd")
	# For debug purposes
	if line == null:
		var debug_dialogue_resource = load(DIALOGUE_FILE)
		dialogue_resource = debug_dialogue_resource
		line = await debug_dialogue_resource.get_next_dialogue_line("null")
	# Set that line to the dialogue box and type it out
	process_dialogue()
	# clear any previous options
	clear_options()
	#symbol_dialogue.display_text("I'm Kaito Tachibana. I programmed a really fucked up AI Human.")

func _input(event: InputEvent) -> void:
	# Prevent input if next line is null
	if (line == null):
		finished_dialogue.emit()
		return
	if event.is_action_pressed("dialogic_default_action"):
		# Skip typing out if input detected while typing
		if dialogue_line.is_typing:
			dialogue_line.skip_typing()
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
func clear_options():
	var options_children = dialogue_options.get_children()
	for child in options_children:
		child.queue_free()

# sets the dialogue text to DialogueLine, and set the portrait
func process_dialogue():
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
	#dialogue_line.dialogue_line = line
	#dialogue_line.type_out()
	symbol_dialogue.display_text(line.text)

# Changes the line and shows the responses in a formatted way
func _show_responses():
	for i in range(line.responses.size()):
		var btn_obj: ChoiceButton = choice_button_scn.instantiate()
		btn_obj.choice_index = i
		btn_obj.text = line.responses[i].text
		btn_obj.choice_selected.connect(_on_choice_selected)
		dialogue_options.add_child(btn_obj)

# Called when a dialogue choice is selected
func _on_choice_selected(choice_index: int):
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
