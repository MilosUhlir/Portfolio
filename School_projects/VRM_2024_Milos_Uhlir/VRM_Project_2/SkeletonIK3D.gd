extends SkeletonIK3D

@onready var anim = $animation


@onready var HOME = $"../../../../Home_target"
@onready var Target_1 = $"../../../../Target_1"
@onready var Target_2 = $"../../../../Target_2"

#@onready var TEST = $"../../../../Home_target"


func _ready():
	#print(TEST)
	#print(target_node)
	set_home_position()


func change_target(new_target):
	if new_target == 0:
		target_node = "../../../../Home_target"
	elif new_target == 1:
		target_node = "../../../../Target_1"
	elif new_target == 2:
		target_node = "../../../../Target_2"
	print(target_node)


func set_home_position():
	target_node = "../../../../Home_target"
	start()
	interpolation = 1.0


func move_to_target():
	start()
	if str(target_node) == "../../../../Target_1":
		anim.play("home_tar1")
	elif str(target_node) == "../../../../Target_2":
		anim.play("home_tar2")


func start_pap():
	start()
	anim.play("target_move")
	print(anim)
