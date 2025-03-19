class_name ChoiceButton extends Button

var choice_index: int

signal choice_selected(choice_index)

func _on_pressed() -> void:
	choice_selected.emit(choice_index)
