extends Node
class_name FileSystemEntry

var entry_name: String
var parent: FileSystemEntry = null
var path: String

func _init(_name: String, _parent=null):
	entry_name = _name
	parent = _parent
	path = _compute_path()

func _compute_path() -> String:
	if parent == null:
		return entry_name
	return "%s/%s" % [parent.path, entry_name]

func is_folder() -> bool:
	return false  # Override in Folder
