extends FileSystemEntry
class_name FileEntry

var scene_reference: PackedScene = null

func _init(_name: String, _parent=null, _scene:PackedScene=null):
	super(_name, _parent)
	scene_reference = _scene

func has_scene() -> bool:
	return scene_reference != null

func instantiate_scene() -> Node:
	if has_scene():
		return scene_reference.instantiate()
	return null
