extends Node

class_name Custom_AStar

static var Open = Array()
static var Closed = Array()
static var Path = Array()

static var tile_cost = int()								# Cost of move onto this tile
static var f = float() 									# Total cost
static var g = float() 									# Cost to this tile
static var h = float() 									# Heuristic cost

static var start_point = Vector2i()						# Global coordinates of starting point
static var end_point = Vector2i()							# Global coordinates of starting point
static var path = PackedVector2Array()						# Array of path point's coordinates

static var coords = Vector2i()								# Coordinates vector
static var walkable = int()								# Walkability of tile
static var parent_coords = Vector2i()						# Parent tile coordinates
static var Tile = [f , g, tile_cost, coords, parent_coords, walkable]	# Data layout for each tile

static var Tile_map										# Variable for Tilemap Object


# Array for searching through neighboring tiles
const search_array = [Vector2i(1, 0), Vector2i(1, 1), Vector2i(0, 1), Vector2i(-1,1), \
					Vector2i(-1,0), Vector2i(-1,-1), Vector2i(0,-1), Vector2i(1,-1)]

enum Tile_state { Walkable, Obstacle, Ocupied, Oc_moving}



static func clear():		# Clears all variables
	Open.clear()
	Closed.clear()
	Path.clear()
	tile_cost = 0
	f = 0
	g = 0
	h = 0
	start_point = Vector2i(0,0)
	end_point = Vector2i(0,0)
	path.clear()
	coords = Vector2i(0,0)
	walkable = 0
	parent_coords = Vector2i(0,0)
	Tile_map = null


static func pull_Tile_map_data(tile_map, _coords):
	var map_coords = _coords
	
	var atlas_coords = tile_map.get_cell_atlas_coords(0, map_coords)
	
	if atlas_coords[0] == Tile_state.Walkable:
		walkable = 0
	elif atlas_coords[0] == Tile_state.Obstacle:
		walkable = 1
	elif atlas_coords[0] == Tile_state.Ocupied:
		walkable = 1
	elif atlas_coords[0] == Tile_state.Oc_moving:
		walkable = 0
	
	tile_cost = 1
	
	Tile[0] = null			# Total cost (f) is initially unknown
	Tile[1] = 0
	Tile[2] = tile_cost
	Tile[3] = map_coords
	Tile[4] = null			# Parent tile is added later
	Tile[5] = walkable
	
	return Tile.duplicate()



static func Search_neighbors(tile_map, current_coords):
	
	# in square grid with diagonal movement there is always 8 neighbors => hardcoded number of neighbors
	var neighbors_coords = [null, null, null, null, null, null, null, null]
	var neighbors = [null, null, null, null, null, null, null, null]
	var neighbors_out = Array()
	
	for i in search_array.size():		# Collecting all neighbors
		neighbors_coords[i] = current_coords + search_array[i]
		neighbors[i] = pull_Tile_map_data(tile_map, neighbors_coords[i])
	
	for n in neighbors.size():			# Outputed are only tiles that are walkable
		if neighbors[n][5] == Tile_state.Walkable:
			neighbors_out.append(neighbors[n])
	
	return neighbors_out.duplicate()


static func calculate_cost(parent_cost, _coords, _end_point, _tile_cost):
	
	var c = Array()
	c.resize(4)
	
	c[0] = max(_end_point[0], _coords[0])
	c[1] = min(_end_point[0], _coords[0])
	c[2] = max(_end_point[1], _coords[1])
	c[3] = min(_end_point[1], _coords[1])				# Calculations to secure positive numbers of h
	
	h = sqrt((c[0] - c[1])**2 + (c[2] - c[3])**2)	# Heuristic function - Euclidian Distance
	
	g = parent_cost + _tile_cost 					# New cost for the currently expanded tile
	
	f = g + h										# Total cost
	
	var transfer = Vector2(f, g)
	
	return transfer



static func Find_path(tile_map, start_point, end_point, debug = bool(false)):
	#print('\n A* START \n')
	
	clear()
	var expanded_tile
	Tile_map = tile_map
	
	start_point = Tile_map.local_to_map(start_point)
	var start_tile = pull_Tile_map_data(Tile_map, start_point)
	start_tile[0] = 0
	start_tile[1] = 0
	#print('start_tile: ',start_tile)
	Open.append(start_tile)
	
	#var debug_point = pull_Tile_map_data(Tile_map, Vector2i(0, 0))
	#debug_point[0] = 1
	#debug_point[1] = 0
	#print('debug_point: ', debug_point)
	#Open.append(debug_point)
	
	end_point = Tile_map.local_to_map(end_point)
	var end_tile = pull_Tile_map_data(Tile_map, end_point)
	end_tile[0] = 0
	end_tile[1] = 0
	#print('end_tile: ', end_tile)
	
	if end_tile[5] == Tile_state.Obstacle:
		return Path
	
	while not Open.is_empty(): # main loop of A*
		Open.sort()
		# end point check when multiple tiles have (aproximately) same cost
		var count = Open.count(Open[0][0])
		if count > 1:
			for i in count:
				if int(Open[i][3]) == int(end_point):
					expanded_tile = Open.pop_at(i)
					Closed.append(expanded_tile)
		else:
			# transfer curently expanded tile from open to closed
			expanded_tile = Open.pop_front()
			Closed.append(expanded_tile)
		
		#print('expanded_tile:', expanded_tile)
		
		# search end-condition check (end-point check)
		if expanded_tile[3] == end_point:
			#print('\n END REACHED \n')
			#return [Open, Closed]
			break
		
		# expand current tile 
		var neighbors_list = Search_neighbors(Tile_map, expanded_tile[3])
		
		# Open and Closed check for all child tiles
		if Open.size() > 0:			# Checking for ocurence of childs in OPEN
			for o in Open.size():
				for n in neighbors_list.size():
					if Open[o][3] == neighbors_list[n][3]:
						var cost = calculate_cost(expanded_tile[1], neighbors_list[n][3], \
													end_point, neighbors_list[n][2])
						neighbors_list[n][0] = cost[0]
						neighbors_list[n][1] = cost[1]
						
						if Open[o][0] > neighbors_list[n][0]:
							neighbors_list[n][4] = expanded_tile[3]
							Open[o] = neighbors_list.pop_at(n)
							break
						else:
							neighbors_list.remove_at(n)
							break
		
		if Closed.size() > 0:		# Checking for ocurence of childs in CLOSED
			for c in Closed.size():
				for n in neighbors_list.size():
					if Closed[c][3] == neighbors_list[n][3]:
						var cost = calculate_cost(expanded_tile[1], neighbors_list[n][3], \
														 end_point, neighbors_list[n][2])
						neighbors_list[n][0] = cost[0]
						neighbors_list[n][1] = cost[1]
						
						if Closed[c][0] > neighbors_list[n][0]:
							neighbors_list[n][4] = expanded_tile[3]
							Closed[c] = neighbors_list.pop_at(n)
							break
						else:
							neighbors_list.remove_at(n)
							break
		
		if neighbors_list.size() > 0:		# Pushing the rest of children into OPEN
			while neighbors_list.size() > 0:
				for i in neighbors_list.size():
					var cost = calculate_cost(expanded_tile[1], neighbors_list[i][3], \
													 end_point, neighbors_list[i][2])
					neighbors_list[i][0] = cost[0]
					neighbors_list[i][1] = cost[1]
					neighbors_list[i][4] = expanded_tile[3]
					Open.append(neighbors_list.pop_at(i))
					break
		
		if Closed.size() > 2500:
			print('break')
			break
		
		# repeat (end of while here)
	
	# pushing coordinates from Closed into Path
	for i in Closed.size():						# searching and pushing end tile into Path first
		if Closed[i][3] == end_point:
			var node = [Closed[i][3], Closed[i][4]]
			Path.append(node)
			break
	
	if Path.is_empty():
		return Path
	
	
	while Path.front()[0] != start_point:		# searching and pushing all other tiles depending on their parent
		for i in Closed.size():
			if Closed[i][3] == Path.front()[1]:
				var node = [Closed[i][3], Closed[i][4]]
				#print('node: ', node)			# console printing of subsequent tiles
				Path.push_front(node)
				break
	
	var Path_out = Array()
	for i in Path.size():						# Transforming coordinates from internal to global
		Path_out.append(Tile_map.map_to_local(Path[i][0]))
	
	if debug:
		var ret_deb = [Path_out, Path.duplicate()]
		Path.clear()
		return ret_deb
	else:
		return Path_out.duplicate()
