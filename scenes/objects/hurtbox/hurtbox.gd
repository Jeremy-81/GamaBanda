extends Area2D

@export var entity : Node;
@export var damage : float;
@export var hit_on_touch : bool = false;
@export var is_player : bool = false;

func _init():
	if hit_on_touch:
		#area_entered.connect(_hit_on_touch);
		pass;
	if is_player:
		set_collision_layer_value(1, true);
		set_collision_layer_value(1, true);
	pass;

#func deal_damage(damagable : Hitbox) -> void:
	#if entity.has_method("take_damage"):
		#entity.take_damage(amount);
	#else: 
	#	push_error("No take_damage method in the called entity")

#func _hit_on_touch():
#	deal_damage
#	pass;
