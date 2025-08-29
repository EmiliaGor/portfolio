extends Node2D
@onready var tile_map = $"../TileMap"
@onready var player = $"."

func _ready():
	player.get_child(0).scale *= Globals.global_scale
	player.get_child(1).scale *= Globals.global_scale
	player.get_child(2).scale *= Globals.global_scale

func _process(delta):
	pass
	
func move():
	# skalowanie tilemapy do skali 1 zeby operace sie dobrze wykonywaly
	var tilemap_scale = tile_map.scale
	var tilemap_scale_inverse = Vector2(1/tilemap_scale.x, 1/tilemap_scale.y)
	tile_map.scale *= tilemap_scale_inverse

	var current_tile: Vector2i = tile_map.local_to_map(global_position * tilemap_scale_inverse)
	#znajduje płytkę na przeciwko gracza
	var target_tile: Vector2i
	target_tile.x = round(Vector2.UP.rotated(rotation).x) + current_tile.x
	target_tile.y = round(Vector2.UP.rotated(rotation).y) + current_tile.y
	
	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
	if tile_data.get_custom_data("walkable"):
		global_position = tile_map.map_to_local(target_tile) * tilemap_scale

	# skalowanie tilemapy i player sprite z powrotem do skali z przed ruchu gracza
	tile_map.scale *= tilemap_scale
	
#obroty
func turn(direction):
	if direction == "right":
		rotation_degrees += 90  
		if rotation_degrees > 270:  
			rotation_degrees -= 360
		if rotation_degrees == 360:
			rotation_degrees = 0
	else:
		rotation_degrees -= 90  
		if rotation_degrees < 90:  
			rotation_degrees += 360
		if rotation_degrees == 360:
			rotation_degrees = 0
	print(rotation_degrees)
	
