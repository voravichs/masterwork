extends Node2D

func _ready() -> void:
	$DesktopIcon.hover_on.connect(_test)
	

func _test():
	print("test")
