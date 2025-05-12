extends Node

var root: Folder

func _ready():
	var json_text = FileAccess.get_file_as_string("res://Scripts/Data/file_system.json")
	var json_data = JSON.parse_string(json_text)
	root = _build_entry(json_data, null)

func _build_entry(data: Dictionary, parent):
	var entry : FileSystemEntry
	if data.type == "folder":
		entry = Folder.new(data.name, data.resource, parent)
		for child in data.children:
			entry.add_folder_child(_build_entry(child, entry))
	elif data.type == "file":
		var scene_instance: Node = null
		if data.has("scene_path"):
			var packed_scene: PackedScene = load(data.scene_path)
			if packed_scene:
				scene_instance = packed_scene.instantiate()
				if data.has("scene_args") and typeof(data.scene_args) == TYPE_DICTIONARY:
					var args: Dictionary = data.scene_args
					for key in args.keys():
						if key in scene_instance:
							scene_instance.set(key, args[key])
						else:
							print_debug("Warning: scene instance has no variable or setter for key '%s'" % key)
		entry = FileEntry.new(data.name, data.resource, parent, scene_instance)
	return entry

func get_root():
	return root

func find_by_path(path: String) -> FileSystemEntry:
	var parts = path.split("/")
	var entry : FileSystemEntry = root
	for p in parts:
		var entry_list = entry.list_entries()
		for e : FileSystemEntry in entry_list:
			if e.entry_name == p:
				entry = e
				break
			else:
				entry = null
		if entry == null:
			return null
	return entry

#func remove_entry(path: String):
	#var parts = path.split("/")
	#var entry : FileSystemEntry = root
	#for p in parts:
		#var entry_list = entry.list_entries()
		#for e : FileSystemEntry in entry_list:
			#if e.entry_name == p:
				#entry = e
				#break
			#else:
				#entry = null
	#var parent : Folder = entry.parent
	#parent.remove_folder_child(entry)

#func add_entry(path: String):
	#var parts = path.split("/")
	#var entry : FileSystemEntry = root
	#for p in parts:
		#var entry_list = entry.list_entries()
		#for e : FileSystemEntry in entry_list:
			#if e.entry_name == p:
				#entry = e
				#break
			#else:
				#entry = null
	#var parent : Folder = entry.parent
	#parent.add_folder_child(entry)
