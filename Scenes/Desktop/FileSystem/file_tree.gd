@tool
extends Tree

var root_item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refresh()

func refresh() -> void:
	clear() # Remove any previous content
	var root_folder = FileSystem.get_root()
	if root_folder == null:
		return
	root_item = create_item()
	root_item.set_text(0, "User") # column 0
	_add_children_recursive(root_folder, root_item)

func _add_children_recursive(folder: Folder, tree_item: TreeItem):
	# Store path on the folder itself
	tree_item.set_metadata(0, folder.path)   # Or folder reference

	for entry : FileSystemEntry in folder.list_entries():
		var child_item = create_item(tree_item)
		child_item.set_text(0, entry.entry_name)
		child_item.set_metadata(0, entry.path) # <-- Store for both folders and files!

		if entry.is_folder():
			_add_children_recursive(entry, child_item)
