extends Node3D


func anim_reparent():
	reparent($"../robo_zizala_v2/Armature/Skeleton3D/end_effector", true)

func anim_deparent():
	reparent($"../../../../..", true)
