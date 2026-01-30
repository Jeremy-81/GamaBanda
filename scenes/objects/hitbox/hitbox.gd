extends Area2D

@export var entity: Node

func take_damage(amount: float) -> void:
	if entity.has_method("take_damage"):
		entity.take_damage(amount)
	else: 
		push_error("No take_damage method in the called entity")
