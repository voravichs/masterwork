extends HBoxContainer
class_name BreadcrumbBar

signal breadcrumb_selected(path)

# Call this to update breadcrumbs when path changes!
func set_breadcrumbs(path: String):
	# e.g. path = "Root/Documents/Notes"
	var children = get_children()
	for child in children:
		child.free()
	var parts = path.split("/")
	var current_path = ""
	for i in parts.size():
		# Add folder segement as a button
		var btn : Button = Button.new()
		btn.text = parts[i]
		btn.flat = true  # Looks more like a link than a button
		# Construct path up to this segment
		current_path = parts[i] if i == 0 else current_path + "/" + parts[i]
		btn.pressed.connect(_on_breadcrumb_pressed.bind(current_path))
		add_child(btn)
		# Add separator, except after last
		if i < parts.size() - 1:
			var sep = Label.new()
			sep.text = ">"  # Or use a custom icon, texture, etc.
			sep.modulate = Color(0.7,0.7,0.7)
			add_child(sep)

func _on_breadcrumb_pressed(path):
	# Emit a signal, or manually tell your explorer to navigate to 'path'
	print("User clicked breadcrumb:", path)
	breadcrumb_selected.emit(path)
