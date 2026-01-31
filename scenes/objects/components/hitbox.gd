class_name Hitbox
extends Area2D

@export var entity : Node;
@export var damage : float;
@export var ko_damage : float = 0.0;
@export var hit_on_touch : bool = false;
@export var is_player : bool = false;

# Signals if has damaged some entity on the attack
signal has_damaged();

func _init():
	monitorable = false;
	monitoring = true;
	
	# Layer separation
	set_collision_layer_value(1, false);
	set_collision_mask_value(1, false);
	pass;

func _ready():
	if hit_on_touch:
		area_entered.connect(_hit_on_touch);
	
	if is_player:
		set_collision_layer_value(4, true);
		set_collision_mask_value(3, true);
	else:
		set_collision_layer_value(5, true);
		set_collision_mask_value(2, true);
	pass;

# Deals damage to all the overlapping hurtboxes
func attack(extra_damage : float = 0.0, extra_ko : float = 0.0) -> void:
	var is_touching := false;

	for damagable_area in get_overlapping_areas():
		if damagable_area is Hurtbox:
			is_touching = true;
			damagable_area.take_damage(damage + extra_damage, ko_damage + extra_ko, entity);
	
	if is_touching:
		has_damaged.emit();
	pass;

# Deals damage to a specific hutbox
func deal_damage(damagable : Hurtbox) -> void:
	damagable.take_damage(damage, ko_damage, entity);
	has_damaged.emit();

func _hit_on_touch(area : Area2D):
	if area is Hurtbox:
		deal_damage(area);
	pass;
