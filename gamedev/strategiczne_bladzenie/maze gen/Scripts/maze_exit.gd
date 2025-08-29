extends Node2D
@onready var exit = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	exit.get_child(0).scale *= Globals.global_scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
