extends Panel
class_name InventorySlot

var item_resource : ItemResource
@onready var margin_container: MarginContainer = $MarginContainer

func set_slot(res: ItemResource) -> void:
	item_resource = res
	var item_texture : TextureRect = TextureRect.new()
	item_texture.texture = item_resource.item_texture
	margin_container.add_child(item_texture)
