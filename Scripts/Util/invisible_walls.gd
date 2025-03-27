extends TileMapLayer

const boundary_atlas_pos = Vector2(2,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	place_boundaries()

func place_boundaries():
	var offsets = [
		Vector2i(0,-1),
		Vector2i(0, 1),
		Vector2i(1, 0),
		Vector2i(-1, 0)
	]
	
	var used = get_used_cells()
	for spot in used:
		for offset in offsets:
			var current_spot = spot + offset
			if (get_cell_source_id(current_spot)) == -1:
				set_cell(current_spot, 0, boundary_atlas_pos)
