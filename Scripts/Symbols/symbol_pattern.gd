extends Control
class_name SymbolPattern

@export var pattern : Util.PatternType

@onready var dot_scene : PackedScene = preload("res://Scenes/Symbols/Dot.tscn")

var draw_toggle : bool = false
var graph : Dictionary = {}
var dot_refs : Dictionary

signal new_origin
signal new_destination
signal found_match

var origin_dot : Dot:
	get: return origin_dot
var destination_dot : Dot:
	get: return destination_dot

func _ready() -> void:
	for i in range(0,Util.get_symbol_info(pattern)["num_dots"]):
		var dot : Dot = dot_scene.instantiate()
		dot.position = Util.get_symbol_info(pattern)["coords"][i]
		dot.dot_num = i
		dot_refs[i] = dot
		graph[i] = []
		dot.entered.connect(_on_dot_entered.bind(i))
		add_child(dot)

func _on_dot_entered(dot_num: int) -> void:
	if draw_toggle:
		if !origin_dot:
			origin_dot = dot_refs[dot_num]
			new_origin.emit()
		elif origin_dot and !destination_dot:
			destination_dot = dot_refs[dot_num]
			var valid_pairs : Array = [Vector2(0, 3), Vector2(3, 0), Vector2(1, 2), Vector2(2, 1)]
			var current_pair : Vector2 = Vector2(origin_dot.dot_num, destination_dot.dot_num)
			if graph[origin_dot.dot_num].has(destination_dot.dot_num) \
				or graph[destination_dot.dot_num].has(origin_dot.dot_num):
				destination_dot = null
			elif (pattern == Util.PatternType.TETRAGRAM_PLUS) and (current_pair in valid_pairs): 
				destination_dot = null
			else:
				new_destination.emit()

func reset_tracing() -> void:
	var dest_num : int = destination_dot.dot_num
	reset_all_dots()
	_on_dot_entered(dest_num)

func reset_all_dots() -> void:
	origin_dot = null
	destination_dot = null

func update_graph() -> void:
	graph[origin_dot.dot_num].append(destination_dot.dot_num)
	graph[destination_dot.dot_num].append(origin_dot.dot_num)
	var matched_symbol : Dictionary = SymbolMatch.check_match(graph, pattern)
	if matched_symbol:
		found_match.emit(matched_symbol)

func reset_graph() -> void:
	graph = {}
	for dot : int in dot_refs:
		graph[dot_refs[dot].dot_num] = []
