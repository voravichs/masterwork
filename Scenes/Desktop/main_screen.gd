extends Control

@onready var icons: IconManager = %Icons

const ICON_MANAGER = preload("res://Scenes/Desktop/IconManager.tscn")
const FILE_EXP = preload("res://Scenes/Desktop/FileExplorer.tscn")

var icon_manager_ref : IconManager

func _ready() -> void:
	var icons : IconManager = ICON_MANAGER.instantiate()
	icon_manager_ref = icons
	icons.path = "desktop"
	icons.parent_z = z_index
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
		file_explorer.close.connect(_on_close_file_ex)
		add_child(file_explorer)
	else:
		file_found.scene_reference.close.connect(_on_close_file)
		add_child(file_found.scene_reference)

func _on_close_file_ex(fex: FileExplorer):
	GlobalDragHandler.unregister_drop_target(fex.icon_manager)
	remove_child(fex)

func _on_close_file(node: Node):
	remove_child(node)
