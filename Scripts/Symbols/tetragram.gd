extends Control
class_name SymbolPattern

const SYMBOL : Util.SymbolCanvas = Util.SymbolCanvas.TETRAGRAM
@onready var dot_1: Node2D = $Dot1
@onready var dot_2: Node2D = $Dot2
@onready var dot_3: Node2D = $Dot3
@onready var dot_4: Node2D = $Dot4
@onready var connections: Node2D = $Connections

var draw_toggle : bool = false

signal new_origin
signal new_destination

var origin_dot : Node2D:
	get: return origin_dot
var destination_dot : Node2D:
	get: return destination_dot

func _on_dot_entered(dot_num: int) -> void:
	if draw_toggle:
		var dot_refs = {
			1: dot_1,
			2: dot_2,
			3: dot_3,
			4: dot_4,
		}
		if !origin_dot:
			origin_dot = dot_refs[dot_num]
			new_origin.emit()
		elif origin_dot and !destination_dot:
			destination_dot = dot_refs[dot_num]
			new_destination.emit()

func reset_tracing():
	var dest_num : int = destination_dot.dot_num
	reset_all_dots()
	_on_dot_entered(dest_num)

func reset_all_dots():
	origin_dot = null
	destination_dot = null
