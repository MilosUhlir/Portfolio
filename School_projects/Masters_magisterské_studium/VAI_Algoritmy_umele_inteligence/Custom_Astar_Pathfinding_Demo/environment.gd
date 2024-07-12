extends Node2D

@onready var tilemap = $TileMap
@onready var unit = $Unit

var Astar = preload("res://Custom_AStar.gd").new()

var path = Array()


# DEBUG TOOLS
var debug_toggle = false
var debug


enum Tile_state { Walkable, Obstacle}


func _ready():
	unit.motion_mode = unit.MOTION_MODE_FLOATING



func test_function():
	var start = Vector2i(32, 32)
	print(start)
	var end = Vector2i(1000, 500)
	print(end)
	
	debug = Astar.Find_path(tilemap, start, end, true)
	debug_print(debug)



func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			var target = get_local_mouse_position()
			path.clear()
			path = Astar.Find_path(tilemap, unit.position, target, debug_toggle)
			
			if debug_toggle:
				debug_print(path)
				if not path.is_empty():
					path = path.pop_front()
			
			unit.path = path
			unit.debug()
	
	
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.is_pressed():
			var mouse = tilemap.local_to_map(get_local_mouse_position())
			var cell_atlas_c = tilemap.get_cell_atlas_coords(0, mouse)
			print(cell_atlas_c)
			if cell_atlas_c[0] == Tile_state.Walkable:
				tilemap.set_cell(0, mouse, 0, Vector2i(1, 0))
			elif cell_atlas_c[0] == Tile_state.Obstacle:
				tilemap.set_cell(0, mouse, 0, Vector2i(0, 0))


func debug_print(_debug):
	if not _debug.is_empty():
		print('Path with parents: ', _debug[1])
		print('Outputed Path: ', _debug[0])
