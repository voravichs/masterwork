extends FileSystemEntry
class_name KeyFileEntry

var key_id : String

func _init(_name: String, _resource_path: String, _key_id: String, _parent=null):
	super(_name, _resource_path, _parent)
	key_id = _key_id
