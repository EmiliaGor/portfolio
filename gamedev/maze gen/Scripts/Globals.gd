extends Node

var tile_size = 32
var default_tilemap_scale = 0.6

# default map size - small
#var tilemap_scale = 0.6
#var grid_size_x = 11
#var grid_size_y = 15

# medium size map
var tilemap_scale = 0.4
var grid_size_x = 17
var grid_size_y = 25

# big map
#var tilemap_scale = 0.35
#var grid_size_x = 19
#var grid_size_y = 27

var global_scale = tilemap_scale / default_tilemap_scale

var step_delay = 0
var allow_loops = true
var letters_to_show = []
var show_labels = false
var player_count

signal fringe_changed
