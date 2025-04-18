extends FileSystemEntry
class_name Folder

var children: Array = []

func _init(_name: String, _resource_path: String, _parent=null):
	super(_name, _resource_path, _parent)

func add_folder_child(child: FileSystemEntry):
	children.append(child)
	child.parent = self

func is_folder() -> bool:
	return true

func list_entries() -> Array:
	return children
