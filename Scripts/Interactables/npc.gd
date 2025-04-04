extends CharacterBody2D

@export var dialogue_file : String = "res://Dialogues/test_dialogue.dialogue"
@export var starting_dialogue : String = "start"
@export var vocal_beep : SoundEffect.SOUND_EFFECT_TYPE

@onready var interaction_area : InteractionArea = $InteractionArea 
@onready var sprite : Sprite2D = $Sprite2D
@onready var ui: CanvasLayer = get_tree().get_first_node_in_group("ui")

const DIALOG_UI = preload("res://Scenes/UI/DialogueUI.tscn")

var dialog_ui_reference: DialogueUI

func _ready() -> void:
	interaction_area.interact = Callable(self, "_show_dialogue")

func _show_dialogue() -> void:
	var dialogue_resource : DialogueResource = load(dialogue_file)
	dialog_ui_reference = DIALOG_UI.instantiate().with_data(dialogue_resource, "start", vocal_beep)
	ui.add_child(dialog_ui_reference)
	dialog_ui_reference.finished_dialogue.connect(_remove_dialogue)
	await dialog_ui_reference.finished_dialogue

func _remove_dialogue() -> void:
	dialog_ui_reference.queue_free()
	Global.OCCUPIED = false
