class_name Hitbox
extends Area2D

@export var entity: Node

func take_damage(amount: float) -> void:
	if entity.has_method("take_damage"):
		entity.take_damage(amount)
	else: 
		push_error("No take_damage method in the called entity")

func _on_area_entered(area: Area2D) -> void:
	take_damage(area.get_parent().get_damage())
	if area.get_parent().has_method("destroy_object"):
		area.get_parent().destroy_object()
