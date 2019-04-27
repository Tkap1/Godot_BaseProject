extends Node

class SafeYield extends Node:
	
	signal done
	
	var who_yields
	
	var object_to_track
	var var_name
	var wanted_value
	
	func _init(_who_yields):
		
		who_yields = weakref(_who_yields)
		Global.add_child(self)
		set_process(false)
		
		
	func _process(delta):
		
		if object_to_track.get(var_name) == wanted_value:
			if safe_to_call():
				emit_signal("done")
			queue_free()
		
		
	func wait(object, signal_name):
		
		yield(object, signal_name)
		if safe_to_call():
			emit_signal("done")
		queue_free()
		
	func wait_timer(duration):
		
		yield(get_tree().create_timer(duration), "timeout")
		if safe_to_call():
			emit_signal("done")
		queue_free()
		
		
	func track_var(_object_to_track, _var_name : String, _wanted_value):
		
		set_process(true)
		object_to_track = _object_to_track
		var_name = _var_name
		wanted_value = _wanted_value
		
			
	func safe_to_call() -> bool:
		
		if who_yields.get_ref():
			return true
		return false
	
		