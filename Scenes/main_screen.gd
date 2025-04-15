extends Control

@onready var icons: IconManager = %Icons

func _ready() -> void:
	icons.double_clicked.connect(_on_double_click_icon)

func _on_double_click_icon(icon : DesktopIcon):
	open_file_entry(icon.desktop_resource.path)

func open_file_entry(path: String):
	var file_found : FileSystemEntry = FileSystem.find_by_path(path)
	if !file_found:
		print("ERR: File not defined in filesystem!")
		return
	print(file_found)
