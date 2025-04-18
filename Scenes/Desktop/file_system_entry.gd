extends Node
class_name FileSystemEntry

var entry_name: String
var parent: FileSystemEntry = null
var path: String
var resource_path : String

func _init(_name: String, _resource_path: String, _parent=null, ):
	entry_name = _name
	parent = _parent
	path = _compute_path()
	resource_path = _resource_path

func _compute_path() -> String:
	if parent == null:
		return entry_name
	return "%s/%s" % [parent.path, entry_name]

func is_folder() -> bool:
	return false  # Override in Folder
