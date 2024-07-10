extends CharacterBody2D

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
