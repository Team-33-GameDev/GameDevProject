extends Node3D

signal factory_manager_opened

#func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		## Получаем камеру
		#var camera = get_viewport().get_camera_3d()
		#if not camera:
			#return
		#
		## Пускаем луч из камеры в точку клика
		#var from = camera.project_ray_origin(event.position)
		#var to = from + camera.project_ray_normal(event.position) * 100
		#
		#var space_state = get_world_3d().direct_space_state
		#var query = PhysicsRayQueryParameters3D.create(from, to)
		#var result = space_state.intersect_ray(query)
		#
		#if result:
			#var collider = result.collider
			#print("🎯 Попали в: ", collider.name if collider else "ничего")
			#
			## Проверяем, попали ли в наш автомат
			#var target = collider
			#while target:
				#if target.name.to_lower().contains("factory") or target.name.to_lower().contains("manager"):
					#print("✅ Клик по Factory Manager!")
					#factory_manager_opened.emit()
					#break
				#target = target.get_parent()
				
func click() -> void:
	print("factory_manager_entity: Player click shop station and method click() is runing")
	## Получаем камеру
	var camera = get_viewport().get_camera_3d()
	if not camera:
		return
	
	# Пускаем луч из камеры в точку клика
	#var from = camera.project_ray_origin(event.position)
	#var to = from + camera.project_ray_normal(event.position) * 100
	
	#var space_state = get_world_3d().direct_space_state
	#var query = PhysicsRayQueryParameters3D.create(from, to)
	#var result = space_state.intersect_ray(query)
	print("✅ Клик по Factory Manager!")
	factory_manager_opened.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	#if result:
		#var collider = result.collider
		#print("🎯 Попали в: ", collider.name if collider else "ничего")
		#
		## Проверяем, попали ли в наш автомат
		#var target = collider
		#while target:
			#if target.name.to_lower().contains("factory") or target.name.to_lower().contains("manager"):
				#print("✅ Клик по Factory Manager!")
				#factory_manager_opened.emit()
				#break
			#target = target.get_parent()
