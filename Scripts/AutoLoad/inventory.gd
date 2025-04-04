extends Node

var inventory : Array[ItemResource] = []
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")

signal inventory_updated

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory.resize(Global.MAX_INVENTORY_SLOTS)

func add_item(item: ItemResource) -> void:
	inventory_updated.emit()
	for slot in range(0, Global.MAX_INVENTORY_SLOTS):
		if !inventory[slot]:
			inventory[slot] = item
			return

func remove_item() -> void:
	inventory_updated.emit()

func increase_inventory_size() -> void:
	inventory_updated.emit()
