extends Node2D

@export var dot_num: int

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dot: Sprite2D = $Dot

var flash : bool = true

signal entered

func _on_dot_enter() -> void:
	if flash:
		animation_player.play("dot_flash")
	entered.emit()

func _on_dot_exit() -> void:
	animation_player.stop()

func toggle_flash():
	flash = not flash
