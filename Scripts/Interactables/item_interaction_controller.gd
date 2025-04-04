extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var items: Node = get_tree().get_first_node_in_group("items")
@onready var item: Node2D = $".."

const SCENE_PATH = "res://Scenes/Environment/InventoryItem.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "_pickup_item")

func _pickup_item() -> void :
	Inventory.add_item(item.item_resource)
	items.remove_child(item)
	Global.OCCUPIED = false
