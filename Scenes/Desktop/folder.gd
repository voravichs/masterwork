extends FileSystemEntry
class_name Folder

var children: Array = []

func _init(_name: String, _coords: Vector2, _resource_path: String, _parent=null):
	super(_name, _coords, _resource_path, _parent)

func add_folder_child(child: FileSystemEntry):
	children.append(child)
	child.parent = self

func remove_folder_child(child: FileSystemEntry):
	children.erase(child)
	child.parent = null

func is_folder() -> bool:
	return true

func list_entries() -> Array:
	return children
