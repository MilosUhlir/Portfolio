extends CanvasLayer


@onready var robot_IK = $"../robo_zizala_v2/Armature/Skeleton3D/SkeletonIK3D"


func _on_target_1_pressed():
	robot_IK.change_target(1)


func _on_target_2_pressed():
	robot_IK.change_target(2)


func _on_reset_scene_pressed():
	robot_IK.set_home_position()
	robot_IK.change_target(0)
	$"../Target_1".transform.origin = Vector3(3, 2.65, 5)


func _on_home_pressed():
	robot_IK.change_target(0)


func _on_move_to_target_pressed():
	robot_IK.move_to_target()


func _on_start_pick_and_place_pressed():
	robot_IK.start_pap()
