@tool
extends Control
class_name FileEntryIcon

@export var desktop_resource : DesktopResource

@onready var icon: Sprite2D = $Sprite2D
@onready var label: Label = $Label
@onready var panel: Panel = $Panel
@onready var drag_boundary: Control = $DragBoundary

const SCENE_PATH = "res://Scenes/Environment/InventoryItem.tscn"

var coords :Vector2i

signal hover_on
signal hover_off

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint() && desktop_resource:
		icon.texture = desktop_resource.texture
		label.text = desktop_resource.name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint() && desktop_resource:
		icon.texture = desktop_resource.texture
		label.text = desktop_resource.name

func _on_area_2d_mouse_entered() -> void:
	hover_on.emit(self)

func _on_area_2d_mouse_exited() -> void:
	hover_off.emit(self)
