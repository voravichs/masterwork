extends Control
class_name FileExplorer

@onready var breadcrumb_bar: BreadcrumbBar = %BreadcrumbBar
@onready var icon_input: Control = %IconInput

const ICON_MANAGER = preload("res://Scenes/Desktop/IconManager.tscn")

var path : String
var icon_manager_ref : IconManager

signal close

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var debug_folder_path = "User/desktop"
	if !path:
		path = debug_folder_path
	breadcrumb_bar.set_breadcrumbs(path)
	var icons : IconManager = ICON_MANAGER.instantiate()
	icon_manager_ref = icons
	icons.path = path
	icons.parent_z = z_index
	icons.double_clicked.connect(_on_double_click_icon)
	icon_input.add_child(icons)

func _on_double_click_icon() -> void:
	print("poggies")

func _on_close() -> void:
	close.emit(self)
