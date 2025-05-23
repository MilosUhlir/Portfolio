GDPC                �                                                                         X   res://.godot/exported/133200997/export-08d1e3c2b6ce474532775eb2c79c840a-environment.scn         �      ��%Q�u7�ud%B8��    P   res://.godot/exported/133200997/export-6a6a2d64feb611bd00115e0ad0692b2e-gui.scn @2      J      ��V��א��eo�    P   res://.godot/exported/133200997/export-b20e5b9a6a36c90835598587a6632344-unit.scn�J             PB�`���W�q]�FڷG    ,   res://.godot/global_script_class_cache.cfg   O      �       (F�"{�N���6֌�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex�5            ：Qt�E�cO���    H   res://.godot/imported/tileset.png-a39e944f25b35d62f55d4f98a36e2b5e.ctex �C      �       >'�?88yǅ������       res://.godot/uid_cache.bin  PS      �       ]�����a$T��8�       res://Custom_AStar.gd                 !�]�R�q��|����       res://environment.gd      �      �5�79�kB����       res://environment.tscn.remap�M      h       �P�\�v-�Z���ku        res://gui.gd�1      a       �Mu��l�,@���} 3       res://gui.tscn.remap0N      `       W1p3��	�$�zzo�[       res://icon.svg  �O      �      k����X3Y���f       res://icon.svg.import   �B      �       �#���F��ǾL       res://project.binary�S      �      ��h�!m햼�ɱD       res://tileset.png.importD      �       �F(`��Y����]�r       res://unit.gd   �D      �      �!tP�#�IJb��	�       res://unit.tscn.remap   �N      a       ��?臆*�=��P��/                extends Object

class_name Custom_AStar

var Open = Array()
var Closed = Array()
var Path = Array()

var tile_cost = int()								# Cost of move onto this tile
var f = float() 									# Total cost
var g = float() 									# Cost to this tile
var h = float() 									# Heuristic cost

var start_point = Vector2i()						# Global coordinates of starting point
var end_point = Vector2i()							# Global coordinates of starting point
var path = PackedVector2Array()						# Array of path point's coordinates

var coords = Vector2i()								# Coordinates vector
var walkable = int()								# Walkability of tile
var parent_coords = Vector2i()						# Parent tile coordinates
var Tile = [f , g, tile_cost, coords, parent_coords, walkable]	# Data layout for each tile

var Tile_map										# Variable for Tilemap Object


# Array for searching through neighboring tiles
const search_array = [Vector2i(1, 0), Vector2i(1, 1), Vector2i(0, 1), Vector2i(-1,1), \
					Vector2i(-1,0), Vector2i(-1,-1), Vector2i(0,-1), Vector2i(1,-1)]

enum Tile_state { Walkable, Obstacle}



func clear():		# Clears all variables
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


func pull_Tile_map_data(tile_map, _coords):
	var map_coords = _coords
	var atlas_coords = tile_map.get_cell_atlas_coords(0, map_coords)
	
	if atlas_coords[0] == Tile_state.Walkable:
		walkable = 0
	elif atlas_coords[0] == Tile_state.Obstacle:
		walkable = 1
	
	tile_cost = 1 # For this demo all walkable tiles have cost of 1
	
	Tile[0] = null			# Total cost (f) is initially unknown
	Tile[1] = 0
	Tile[2] = tile_cost
	Tile[3] = map_coords
	Tile[4] = null			# Parent tile is added later
	Tile[5] = walkable
	
	return Tile.duplicate()



func Search_neighbors(tile_map, current_coords):
	
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


func calculate_cost(parent_cost, _coords, _end_point, _tile_cost):
	
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



func Find_path(tile_map, start_point, end_point, debug = bool(false)):
	print('\n A* START \n')
	
	clear()
	var expanded_tile
	Tile_map = tile_map
	
	start_point = Tile_map.local_to_map(start_point)
	var start_tile = pull_Tile_map_data(Tile_map, start_point)
	start_tile[0] = 0
	start_tile[1] = 0
	print('start_tile: ',start_tile)
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
	print('end_tile: ', end_tile)
	
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
			print('\n END REACHED \n')
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
		
		# repeat (end of while here)
	
	# pushing coordinates from Closed into Path
	for i in Closed.size():						# searching and pushing end tile into Path first
		if Closed[i][3] == end_point:
			var node = [Closed[i][3], Closed[i][4]]
			Path.append(node)
			break
	
	while Path.front()[0] != start_point:		# searching and pushing all other tiles depending on their parent
		for i in Closed.size():
			if Closed[i][3] == Path.front()[1]:
				var node = [Closed[i][3], Closed[i][4]]
				print('node: ', node)			# console printing of subsequent tiles
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
          extends Node2D

@onready var tilemap = $TileMap
@onready var unit = $Unit

var Astar = preload("res://Custom_AStar.gd").new()

var path = Array()


# DEBUG TOOLS
var debug_toggle = false
var debug



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



func debug_print(_debug):
	if not _debug.is_empty():
		print('Path with parents: ', _debug[1])
		print('Outputed Path: ', _debug[0])
             RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    texture    margins    separation    texture_region_size    use_texture_padding    0:0/0    0:0/0/script    1:0/0    1:0/0/script    script    tile_shape    tile_layout    tile_offset_axis 
   tile_size    uv_clipping    navigation_layer_0/layers 
   sources/0    tile_proxies/source_level    tile_proxies/coords_level    tile_proxies/alternative_level 	   _bundled       Script    res://environment.gd ��������   PackedScene    res://gui.tscn ��Y�gQx
   Texture2D    res://tileset.png LՄ��yb'   PackedScene    res://unit.tscn wH��e�ec   !   local://TileSetAtlasSource_am0f2 H         local://TileSet_56xgt �         local://PackedScene_cr7xw          TileSetAtlasSource                   -   @   @                   	          
               TileSet                         -   @   @                                  PackedScene          	         names "   
      Environment    script    Node2D    GUI    TileMap 	   tile_set    format    layer_0/tile_data    Unit 	   position    	   variants                                             �                                                                                                                          	          
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             	           	          	          	          	          	          	          	          
           
         
         
          
          
          
                                                                                         	          	          	          	         	         	          	          	          	         	 	         
 	          	                                                                                                	                                                                                           	                                                                                       	                                                                               	                                                                                                 	                                                                                                    	                                                                     
                                                          ����       ��         ��        ��        ��        ��        ��        ��        ��        ��        ��	        ��
          
         
         
         
         
         
         
         
         
        	 
        
 
         
         
         
         
         
         
         
         
         	                                                                                           ��        ��        ��        ��        ��        ��        ��        ��       
 ��       	 ��        ��        ��        ��        ��        ��        ��        ��        ��         ��                
     D  �C      node_count             nodes     &   ��������       ����                      ���                            ����                                 ���         	                conn_count              conns               node_paths              editable_instances              version             RSRC            extends CanvasLayer

@onready var env = $".."



func _on_button_pressed():
	env.test_function()
               RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://gui.gd ��������      local://PackedScene_1dvls          PackedScene          	         names "   	      GUI    script    CanvasLayer    Button    offset_right    offset_bottom    text    _on_button_pressed    pressed    	   variants                      �B     0B      Test Path
Outputs into cosole       node_count             nodes        ��������       ����                            ����                               conn_count             conns                                      node_paths              editable_instances              version             RSRC      GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�m�m۬�}�p,��5xi�d�M���)3��$�V������3���$G�$2#�Z��v{Z�lێ=W�~� �����d�vF���h���ڋ��F����1��ڶ�i�엵���bVff3/���Vff���Ҿ%���qd���m�J�}����t�"<�,���`B �m���]ILb�����Cp�F�D�=���c*��XA6���$
2#�E.@$���A.T�p )��#L��;Ev9	Б )��D)�f(qA�r�3A�,#ѐA6��npy:<ƨ�Ӱ����dK���|��m�v�N�>��n�e�(�	>����ٍ!x��y�:��9��4�C���#�Ka���9�i]9m��h�{Bb�k@�t��:s����¼@>&�r� ��w�GA����ը>�l�;��:�
�wT���]�i]zݥ~@o��>l�|�2�Ż}�:�S�;5�-�¸ߥW�vi�OA�x��Wwk�f��{�+�h�i�
4�˰^91��z�8�(��yޔ7֛�;0����^en2�2i�s�)3�E�f��Lt�YZ���f-�[u2}��^q����P��r��v��
�Dd��ݷ@��&���F2�%�XZ!�5�.s�:�!�Њ�Ǝ��(��e!m��E$IQ�=VX'�E1oܪì�v��47�Fы�K챂D�Z�#[1-�7�Js��!�W.3׹p���R�R�Ctb������y��lT ��Z�4�729f�Ј)w��T0Ĕ�ix�\�b�9�<%�#Ɩs�Z�O�mjX �qZ0W����E�Y�ڨD!�$G�v����BJ�f|pq8��5�g�o��9�l�?���Q˝+U�	>�7�K��z�t����n�H�+��FbQ9���3g-UCv���-�n�*���E��A�҂
�Dʶ� ��WA�d�j��+�5�Ȓ���"���n�U��^�����$G��WX+\^�"�h.���M�3�e.
����MX�K,�Jfѕ*N�^�o2��:ՙ�#o�e.
��p�"<W22ENd�4B�V4x0=حZ�y����\^�J��dg��_4�oW�d�ĭ:Q��7c�ڡ��
A>��E�q�e-��2�=Ϲkh���*���jh�?4�QK��y@'�����zu;<-��|�����Y٠m|�+ۡII+^���L5j+�QK]����I �y��[�����(}�*>+���$��A3�EPg�K{��_;�v�K@���U��� gO��g��F� ���gW� �#J$��U~��-��u���������N�@���2@1��Vs���Ŷ`����Dd$R�":$ x��@�t���+D�}� \F�|��h��>�B�����B#�*6��  ��:���< ���=�P!���G@0��a��N�D�'hX�׀ "5#�l"j߸��n������w@ K�@A3�c s`\���J2�@#�_ 8�����I1�&��EN � 3T�����MEp9N�@�B���?ϓb�C��� � ��+�����N-s�M�  ��k���yA 7 �%@��&��c��� �4�{� � �����"(�ԗ�� �t�!"��TJN�2�O~� fB�R3?�������`��@�f!zD��%|��Z��ʈX��Ǐ�^�b��#5� }ى`�u�S6�F�"'U�JB/!5�>ԫ�������/��;	��O�!z����@�/�'�F�D"#��h�a �׆\-������ Xf  @ �q�`��鎊��M��T�� ���0���}�x^�����.�s�l�>�.�O��J�d/F�ě|+^�3�BS����>2S����L�2ޣm�=�Έ���[��6>���TъÞ.<m�3^iжC���D5�抺�����wO"F�Qv�ږ�Po͕ʾ��"��B��כS�p�
��E1e�������*c�������v���%'ž��&=�Y�ް>1�/E������}�_��#��|������ФT7׉����u������>����0����緗?47�j�b^�7�ě�5�7�����|t�H�Ե�1#�~��>�̮�|/y�,ol�|o.��QJ rmϘO���:��n�ϯ�1�Z��ը�u9�A������Yg��a�\���x���l���(����L��a��q��%`�O6~1�9���d�O{�Vd��	��r\�՜Yd$�,�P'�~�|Z!�v{�N�`���T����3?DwD��X3l �����*����7l�h����	;�ߚ�;h���i�0�6	>��-�/�&}% %��8���=+��N�1�Ye��宠p�kb_����$P�i�5�]��:��Wb�����������ě|��[3l����`��# -���KQ�W�O��eǛ�"�7�Ƭ�љ�WZ�:|���є9�Y5�m7�����o������F^ߋ������������������Р��Ze�>�������������?H^����&=����~�?ڭ�>���Np�3��~���J�5jk�5!ˀ�"�aM��Z%�-,�QU⃳����m����:�#��������<�o�����ۇ���ˇ/�u�S9��������ٲG}��?~<�]��?>��u��9��_7=}�����~����jN���2�%>�K�C�T���"������Ģ~$�Cc�J�I�s�? wڻU���ə��KJ7����+U%��$x�6
�$0�T����E45������G���U7�3��Z��󴘶�L�������^	dW{q����d�lQ-��u.�:{�������Q��_'�X*�e�:�7��.1�#���(� �k����E�Q��=�	�:e[����u��	�*�PF%*"+B��QKc˪�:Y��ـĘ��ʴ�b�1�������\w����n���l镲��l��i#����!WĶ��L}rեm|�{�\�<mۇ�B�HQ���m�����x�a�j9.�cRD�@��fi9O�.e�@�+�4�<�������v4�[���#bD�j��W����֢4�[>.�c�1-�R�����N�v��[�O�>��v�e�66$����P
�HQ��9���r�	5FO� �<���1f����kH���e�;����ˆB�1C���j@��qdK|
����4ŧ�f�Q��+�     [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://br2le6bga6rlh"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
                GST2   �   @      ����               � @        P   RIFFH   WEBPVP8L<   /�  HY{w�@���D;(Hۀ�ӝ�غ���mfb&�g�xntL�!����^(O��u        [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://bgoy4fvy63usi"
path="res://.godot/imported/tileset.png-a39e944f25b35d62f55d4f98a36e2b5e.ctex"
metadata={
"vram_texture": false
}
             extends CharacterBody2D

@onready var Tilemap = $"../TileMap"

const SPEED = 300.0			# unit movement speed
const min_target = 32		# minimal distance from current possition to target
const eps = 10				# distance under which the point is considered reached (tolerance)

var path = Array()			# Array for Path points
var move_to = Vector2()		# coordinates of current movement target
var to = Vector2()			# coordinates of current movement target (internal for function move())



func _ready():
	path.clear()			# deletes all points from path
	
	# rounds global coordinates to map coordinates using 
	# transformation from global to local and back
	position = Tilemap.map_to_local(Tilemap.local_to_map(position))
	
	move_to = position		# sets target to current possition
	velocity = Vector2(0, 0)# sets speed to 0



func _physics_process(_delta):		# physics proces runs every frame
	
	# if distance from target is greater than minimal set velocity
	if position.distance_to(move_to) > min_target:
		velocity = position.direction_to(move_to) * SPEED
	
	move_and_slide()	# internal function for movement physics
	
	#if distance to target is smaller than tolerance stop movement
	if position.distance_to(move_to) <= eps:
		if path.is_empty():	# if path array is empty stop movement
			_ready()
		else:				# else continue to next point
			move_to = move(path)



func move(_path):
	if not _path.is_empty():
		to = _path.pop_front()
	else:
		to = position
	return to



func debug():
	print('Unit path: ',path)
    RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://unit.gd ��������
   Texture2D    res://icon.svg 9P��w�u2      local://PackedScene_7j2py .         PackedScene          	         names "         Unit    script    CharacterBody2D 	   Sprite2D    scale    texture    	   variants                 
   ���>���>               node_count             nodes        ��������       ����                            ����                         conn_count              conns               node_paths              editable_instances              version             RSRC[remap]

path="res://.godot/exported/133200997/export-08d1e3c2b6ce474532775eb2c79c840a-environment.scn"
        [remap]

path="res://.godot/exported/133200997/export-6a6a2d64feb611bd00115e0ad0692b2e-gui.scn"
[remap]

path="res://.godot/exported/133200997/export-b20e5b9a6a36c90835598587a6632344-unit.scn"
               list=Array[Dictionary]([{
"base": &"Object",
"class": &"Custom_AStar",
"icon": "",
"language": &"GDScript",
"path": "res://Custom_AStar.gd"
}])
<svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 814 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H446l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z" fill="#478cbf"/><path d="M483 600c0 34 58 34 58 0v-86c0-34-58-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
              hK�z��`   res://environment.tscn��Y�gQx   res://gui.tscn9P��w�u2   res://icon.svgLՄ��yb'   res://tileset.pngwH��e�ec   res://unit.tscn              ECFG      application/config/name(         Custom Astar Pathfinding Demo      application/run/main_scene          res://environment.tscn     application/config/features$   "         4.2    Forward Plus       application/config/icon         res://icon.svg  #   display/window/size/viewport_height      �     display/window/size/resizable          	   input/LMB�              deadzone      ?      events              InputEventMouseButton         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          button_mask           position              global_position               factor       �?   button_index         canceled          pressed           double_click          script      	   input/RMB�              deadzone      ?      events              InputEventMouseButton         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          button_mask           position              global_position               factor       �?   button_index         canceled          pressed           double_click          script                     