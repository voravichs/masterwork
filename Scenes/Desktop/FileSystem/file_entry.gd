extends FileSystemEntry
class_name FileEntry

var scene_reference: Node = null
var locked : bool
var lock_id : String

func _init(_name: String, _resource_path: String, _parent=null, _scene:Node=null):
	super(_name, _resource_path, _parent)
	scene_reference = _scene

func has_scene() -> bool:
	return scene_reference != null

#func instantiate_scene() -> Node:
	#if has_scene():
		#return scene_reference.instantiate()
	#return null
