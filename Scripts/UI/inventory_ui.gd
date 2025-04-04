extends PanelContainer
@onready var inv_grid: GridContainer = %InvGrid

signal close

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(0, Global.MAX_INVENTORY_SLOTS):
		var slot : InventorySlot = inv_grid.get_children()[i]
		if Inventory.inventory[i]:
			slot.set_slot(Inventory.inventory[i])

func _on_close_pressed() -> void:
	close.emit()
