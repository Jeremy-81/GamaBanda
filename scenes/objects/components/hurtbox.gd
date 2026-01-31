class_name Hurtbox
extends Area2D

@export var entity : Node;
@export var is_player := false;
@export var invencibility_time : float = 0.0;

signal damaged(damage: float, ko_damage: float, damage_dealer: Node);

var _invencibility_timer : Timer = null;

func _init():
	monitorable = true;
	monitoring = false;
	
	# Layer separation
	set_collision_layer_value(1, false);
	set_collision_mask_value(1, false);

func _ready():
	if is_player:
		set_collision_layer_value(2, true);
		set_collision_mask_value(5, true);
	else:
		set_collision_layer_value(3, true);
		set_collision_mask_value(4, true);
	pass;

func _enter_tree():
	# Setups the invencibility timer
	if invencibility_time > 0.0:
		_invencibility_timer = Timer.new();
		_invencibility_timer.wait_time = invencibility_time;
		add_child(_invencibility_timer);


func take_damage(damage: float, ko_damage: float, damage_dealer: Node) -> void:
	# Checks invencibility frames
	if _invencibility_timer:
		if _invencibility_timer.time_left > 0.0:
			return;
	
	if entity.has_method("take_damage"):
		entity.take_damage(damage, ko_damage);
	else: 
		push_error("No take_damage method in the called entity");
	
	if _invencibility_timer:
		_invencibility_timer.start();
	damaged.emit(damage, ko_damage, damage_dealer);
