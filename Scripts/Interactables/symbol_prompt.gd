extends Node2D

@export var pattern : Util.PatternType

@onready var interaction_area : InteractionArea = $InteractionArea
@onready var ui: CanvasLayer = get_tree().get_first_node_in_group("ui")

const SYMBOL_CANVAS = preload("res://Scenes/UI/SymbolCanvas.tscn")

var symbol_canvas_ref: SymbolCanvas 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "_open_symbol_canvas")

func _open_symbol_canvas() -> void:
	symbol_canvas_ref = SYMBOL_CANVAS.instantiate()
	ui.add_child(symbol_canvas_ref)
	symbol_canvas_ref.symbol_drawn.connect(_symbol_result)
	await symbol_canvas_ref.symbol_drawn

func _symbol_result(matched_symbol: Dictionary) -> void:
	symbol_canvas_ref.queue_free()
	print(matched_symbol)
	Global.OCCUPIED = false
