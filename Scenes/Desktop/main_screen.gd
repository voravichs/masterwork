extends Control

@onready var icons: IconManager = %Icons

const ICON_MANAGER = preload("res://Scenes/Desktop/IconManager.tscn")
const FILE_EXP = preload("res://Scenes/Desktop/FileExplorer.tscn")

var icon_manager_ref : IconManager

func _ready() -> void:
	var icons : IconManager = ICON_MANAGER.instantiate()
	icon_manager_ref = icons
	icons.path = "desktop"
	icons.double_clicked.connect(_on_double_click_icon)
	add_child(icons)

func _on_double_click_icon(icon : FileEntryIcon):
	open_file_entry(icon.desktop_resource.path)

func open_file_entry(path: String):
	var file_found : FileSystemEntry = FileSystem.find_by_path(path)
	if !file_found:
		print("ERR: File not defined in filesystem!")
		return
	if file_found.is_folder():
		var file_explorer = FILE_EXP.instantiate()
		file_explorer.path = path
		add_child(file_explorer)
		icon_manager_ref.drag_enabled = false

func _on_mouse_entered() -> void:
	print("enter desktop")

func _on_mouse_exited() -> void:
	print("exit desktop")
