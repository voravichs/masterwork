extends Control
class_name FileEntryIcon

@export var desktop_resource : DesktopResource

@onready var icon: Sprite2D = $Sprite2D
@onready var label: Label = $Label
@onready var panel: Panel = $Panel
@onready var drag_boundary: Control = $DragBoundary
@onready var lock: Sprite2D = $Lock

const SCENE_PATH = "res://Scenes/Environment/InventoryItem.tscn"

var coords :Vector2i
var file_system_entry: FileSystemEntry

signal hover_on
signal hover_off

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	icon.texture = desktop_resource.texture
	label.text = file_system_entry.entry_name
	if "lock_id" in file_system_entry:
		if file_system_entry.lock_id:
			lock.visible = true
			icon.modulate.a = 0.2
			label.modulate.a = 0.2

## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#if Engine.is_editor_hint() && desktop_resource:
		#icon.texture = desktop_resource.texture
		#label.text = desktop_resource.name

func _on_area_2d_mouse_entered() -> void:
	hover_on.emit(self)

func _on_area_2d_mouse_exited() -> void:
	hover_off.emit(self)
