extends Node
class_name ObjectPooler

@export var object: PackedScene
@export var start_pool_size: int = 1
@export var expand_pool: bool = true

var object_pool = []

func _ready():
	for i in range(start_pool_size):
		instantiate_new_pool_object()

func get_object_from_pool():
	for o in object_pool:
		if "is_active" in o and not o.is_active:
			return o
	if expand_pool:
		return instantiate_new_pool_object()
	push_warning("No Objects in pool!")
	return null
	
func instantiate_new_pool_object():
	var new_o = object.instantiate()
	add_child(new_o)
	object_pool.append(new_o)
	return new_o

func get_object_pool():
	return object_pool
