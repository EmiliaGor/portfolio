extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (has_overlapping_bodies()):
		Global.cur_lv+=1;
		get_tree().change_scene_to_file(Global.level_ar[Global.cur_lv] )
		
