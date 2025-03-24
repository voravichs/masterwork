extends CharacterBody2D

@export var dialogue_file : String = "res://Dialogues/test_dialogue.dialogue"
@export var starting_dialogue : String = "start"

@onready var interaction_area : InteractionArea = $InteractionArea 
@onready var sprite = $Sprite2D
@onready var root: Node2D = get_tree().get_first_node_in_group("root")

const DIALOG_UI = preload("res://Scenes/UI/DialogueUI.tscn")

var dialog_ui_reference: DialogueUI

func _ready() -> void:
	interaction_area.interact = Callable(self, "_show_dialogue")

func _show_dialogue():
	var debug_dialogue_resource = load(dialogue_file)
	dialog_ui_reference = DIALOG_UI.instantiate().with_data(debug_dialogue_resource, "start")
	root.add_child(dialog_ui_reference)
	dialog_ui_reference.finished_dialogue.connect(_remove_dialogue)
	await dialog_ui_reference.finished_dialogue

func _remove_dialogue():
	root.remove_child(dialog_ui_reference)
	Global.INTERACTING = false
