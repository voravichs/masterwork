extends Node2D

@export var letter : String

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var letter_sprite: Sprite2D = $Letter
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interaction_area: InteractionArea = $InteractionArea
@onready var interaction_collision: CollisionShape2D = $InteractionArea/CollisionShape2D

func _ready() -> void:
	letter_sprite.frame = Global.CHARACTER_MAP[letter]
	animation_player.play("float")
	interaction_area.interact = Callable(self, "_unlock_letter")

func _unlock_letter() -> void:
	if (!Global.DISCOVERED_CHARACTER[letter]):
		Global.DISCOVERED_CHARACTER[letter] = true
		player.show_floating_text("Unlocked " + letter + "!")
		animation_player.play("deactivate")
		interaction_collision.disabled = true
	Global.OCCUPIED = false
