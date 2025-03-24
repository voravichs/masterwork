extends Node2D

@onready var interaction_area : InteractionArea = $InteractionArea 
@onready var light = $PointLight2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "_toggle_lamp")

func _toggle_lamp():
	if light.visible:
		light.hide()
	else:
		light.show()
	Global.INTERACTING = false
