extends Node2D

@onready var player = $player
@onready var players = [ ]
@onready var tile_map = $TileMap # DO NOT TOUCH OR CHANGE THIS thx ^^
@onready var maze_exit = $maze_exit

var hud_enabled = true
var active_player
var active_player_id
const maze = preload("res://Scenes/tile_map.tscn")
const player_scene = preload("res://Scenes/player.tscn")
var colours = (
	[Color(0, 0, 0, 0.6),
	Color(1, 0, 0, 0.4),
	Color(1, 1, 0, 0.4),
	Color(0, 1, 0, 0.4),
	Color(0, 0.6, 9, 0.4),
	Color(0.2, 0, 1, 0.4)]
	)

func _ready() -> void:
	# set tilemap size
	tile_map.scale = Vector2(Globals.tilemap_scale, Globals.tilemap_scale)
	# add player scene instances to players[] array
	for i in Globals.player_count:
		if i == 0:
			players.append(player)
			print("i==0")
		else:
			var player_instance = player_scene.instantiate()
			add_child(player_instance)
			players.append(player_instance)
		# assign colour to player
		players[i].get_child(2).position -= Vector2(Globals.tile_size/2, Globals.tile_size/2)
		players[i].get_child(2).color = colours[i]
	# loading players check
	for i in players.size():
		print(i)
	print("^^^ ", players.size())
	# rand ustaw pozycje gracza + proximity to others
	for i in players.size():
		# rand generate position on tile map & assign mapped position to player
		players[i].position = tile_map.map_to_local(tile_map.find_empty_tile()) * tile_map.scale
		# check if this position is occupied
		var j = 0
		while j < i:
			while players[i].position == players[j].position:
				players[i].position = tile_map.map_to_local(tile_map.find_empty_tile()) * tile_map.scale
				print("rerolled initial player position bc of conflict")
			j += 1
			
	# rand generate maze exit
	maze_exit.position = tile_map.map_to_local(tile_map.find_empty_tile()) * tile_map.scale
	for i in players.size():
		while maze_exit.position == players[i].position:
			maze_exit.position = tile_map.map_to_local(tile_map.find_empty_tile()) * tile_map.scale
			print("rerolled initial maze_exit position bc of conflict")

	# set active player to first in array
	if players.size() >= 1:
		active_player = players[0]
		active_player_id = 0
		active_player.get_child(0).visible = true

#func on_fringe_changed():
	$CanvasLayer/spots_visited_column.text = "\n".join(Globals.letters_to_show)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("show_hud"):
		hud_enabled = not hud_enabled
		$"CanvasLayer".set_visible(hud_enabled)

	if Input.is_action_just_pressed("reset"):
		var new_maze = maze.instantiate()
		var existing_maze = get_children().filter(func(x):
			return "TileMap" in x.name)[0]
		existing_maze.queue_free()
		add_child(new_maze)

	var ma = get_children().filter(func(x):
		return "TileMap" in x.name)[0]
	ma.find_empty_tile()
	$CanvasLayer/spots_visited_column.text = "\n".join(Globals.letters_to_show)
	
	# pod to sa podpiete buttony do sterowania mroweczkami
	if Input.is_action_just_pressed("next_player"):
		active_player_id += 1
		if active_player_id >= players.size():
			active_player_id = 0
		print("active_player_id")
		print(active_player_id)
		if players[active_player_id] != active_player:
			# toggle active frame visibility
			active_player.get_child(0).visible = false
			active_player = players[active_player_id]
			active_player.get_child(0).visible = true
	elif Input.is_action_just_pressed("previous_player"):
		active_player_id -= 1
		if active_player_id < 0:
			active_player_id = (players.size() - 1)
		print("active_player_id")
		print(active_player_id)
		if players[active_player_id] != active_player:
			active_player.get_child(0).visible = false
			active_player = players[active_player_id]
			active_player.get_child(0).visible = true
	
	# pod to sa tez podpiete buttony do sterowania mroweczkami
	if Input.is_action_just_pressed("move_forward"):
		active_player.move()
	elif Input.is_action_just_pressed("turn_right"):
		active_player.turn("right")
	elif Input.is_action_just_pressed("turn_left"):
		active_player.turn("left")
		
	# check if player reached exit
	var j = 1 # bo morderca jest pierwszy a on nie moze wyjsc z labiryntu
	while j < players.size():
		if players[j].position == maze_exit.position:
			print("player ", j + 1, " escaped")
			# usunac instancje (pionek zmiesc z planszy)
			players[j].queue_free()
			# usuniecie z tablicy
			players.remove_at(j)
			# jezeli usunieto aktywnego gracza to przeskoczy na nastepnego
			if j == active_player_id:
				print("active_player_id")
				print(active_player_id)
				if active_player_id >= players.size():
					active_player_id = 0
				if players[active_player_id] != active_player:
					# toggle active frame visibility
					active_player.get_child(0).visible = false
					active_player = players[active_player_id]
					active_player.get_child(0).visible = true
		j += 1
	# zmniejsza sie players.size() ale nie Globals.player_count

# Buttons to move the players around
func _on_move_up_button_pressed():
	Input.action_press("move_forward")
	Input.action_release("move_forward")

func _on_turn_left_button_pressed():
	Input.action_press("turn_left")
	Input.action_release("turn_left")

func _on_turn_right_button_pressed():
	Input.action_press("turn_right")
	Input.action_release("turn_right")

func _on_prev_player_button_pressed():
	Input.action_press("previous_player")
	Input.action_release("previous_player")

func _on_next_player_button_pressed():
	Input.action_press("next_player")
	Input.action_release("next_player")


func _on_grid_size_slider_value_changed(value: float) -> void:
	Globals.grid_size_x = value

func _on_solve_speed_slider_value_changed(value: float) -> void:
	Globals.step_delay = value

func _on_allow_loops_toggled(button_pressed: bool) -> void:
	Globals.allow_loops = button_pressed

func _on_show_labels_toggled(button_pressed: bool) -> void:
	Globals.show_labels = button_pressed
	$CanvasLayer/spots_visited_column.set_visible(button_pressed)
