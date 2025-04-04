extends Node

var patterns : Dictionary

func _ready() -> void:
	var pattern_db_ref : Script = preload("res://Scripts/Data/pattern_db.gd")
	patterns = pattern_db_ref.PATTERN_DB

func check_match(graph: Dictionary, pattern: Util.PatternType) -> Dictionary:
	var edges : Array[String]
	# Wrangle graph into an array of edges
	for vertex : int in graph:
		for edge : int in graph[vertex]:
			if edge > vertex:
				edges.append(str(vertex) + str(edge))
	edges.sort()
	# Match patterns
	var patterns_to_check : Dictionary = patterns[pattern]
	for pattern_index : String in patterns_to_check:
		var curr_pattern : Array = patterns_to_check[pattern_index].sequence
		if edges == curr_pattern:
			return patterns_to_check[pattern_index]
	return {}
