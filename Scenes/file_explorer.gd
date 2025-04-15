extends Control

@onready var breadcrumb_bar: BreadcrumbBar = %BreadcrumbBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var debug_folder_path = "User/desktop"
	breadcrumb_bar.set_breadcrumbs(debug_folder_path)
