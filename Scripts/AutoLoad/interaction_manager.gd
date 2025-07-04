extends Node2D

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var label : Label = $Label

const base_text = "[E] to "

var active_areas : Array[InteractionArea] = []
var can_interact : bool = true

func register_area(area: InteractionArea) -> void:
	active_areas.push_back(area)

func unregister_area(area: InteractionArea) -> void:
	var index : int = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)

func _process(_delta: float) -> void:
	if active_areas.size() > 0 && can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		label.text = base_text + active_areas[0].action_name
		label.global_position = active_areas[0].global_position
		label.global_position.y -= 48
		label.global_position.x -= label.size.x / 2
		label.show()
	else:
		label.hide()

func _sort_by_distance_to_player(area1: InteractionArea, area2: InteractionArea) -> bool:
	var area1_to_player : float = player.global_position.distance_to(area1.global_position)
	var area2_to_player : float = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && can_interact:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			Global.OCCUPIED = true
			await active_areas[0].interact.call()
			can_interact = true
