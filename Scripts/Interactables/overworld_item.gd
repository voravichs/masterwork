@tool
extends Node2D

@export var item_resource : ItemResource

@onready var icon: Sprite2D = $ItemInteractionController/Sprite2D

const SCENE_PATH = "res://Scenes/Environment/InventoryItem.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint() && item_resource:
		icon.texture = item_resource.item_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint() && item_resource:
		icon.texture = item_resource.item_texture
