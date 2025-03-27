extends Panel

@export var MAX_LENGTH : int


@onready var hitbox: Area2D = %Hitbox
@onready var line_ref: Line2D = $DrawLine
@onready var draw_line_panel: Panel = $"."

var queue : Array
var drawing : bool = false:
	set(value):
		drawing = value

func _ready() -> void:
	SignalBus.dot_collided.connect(_on_dot_collided)

func _process(_delta: float) -> void:
	if drawing:
		# Get mouse position, update collision
		var global_pos = get_global_mouse_position()
		var adj_pos = global_pos - position
		hitbox.global_position = global_pos
		var panel_rect = Rect2(self.global_position, self.size)
		
		# Check in bounds of panel
		if (panel_rect.has_point(global_pos)):
			# Add position to queue, remove oldest item if queue is full
			queue.push_front(adj_pos)
			if queue.size() > MAX_LENGTH:
				queue.pop_back()
			
			# Clear all points, draw the current points
			line_ref.clear_points()
			for point in queue:
				line_ref.add_point(point)
		else:
			queue.clear()
			line_ref.clear_points()
	else:
		queue.clear()
		line_ref.clear_points()

func _on_dot_collided(canvas : Util.SymbolCanvas, dot_num : int):
	var canvas_name : String = ""
	match canvas:
		Util.SymbolCanvas.TETRAGRAM:
			canvas_name = "Tetragram"
		Util.SymbolCanvas.TETRAGRAM_PLUS:
			canvas_name = "Tetragram Plus"
		Util.SymbolCanvas.HEXAGRAM:
			canvas_name = "Hexagram"
		Util.SymbolCanvas.OCTAGRAM:
			canvas_name = "Octagram"
	print("Collision: " + canvas_name + " at " + str(dot_num))
