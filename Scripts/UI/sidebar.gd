extends Control

@onready var ui: CanvasLayer = get_tree().get_first_node_in_group("ui")
@onready var inventory: Button = $Inventory

var inventory_ui_reference : Control

const INVENTORY_UI = preload("res://Scenes/UI/Inventory.tscn")

func _on_inventory_pressed() -> void:
	inventory_ui_reference = INVENTORY_UI.instantiate()
	ui.add_child(inventory_ui_reference)
	inventory.disabled = true
	Global.OCCUPIED = true
	inventory_ui_reference.close.connect(_close_inventory)

func _close_inventory() -> void:
	ui.remove_child(inventory_ui_reference)
	inventory.disabled = false
	Global.OCCUPIED = false
