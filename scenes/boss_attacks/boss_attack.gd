extends AnimatableBody2D

@export var damage: float
@export var speed: float
@export var player: Node2D

var damage_dealt := false
var traveled := 0.0
var max_travel_time := 3.0

func _physics_process(delta: float) -> void:
	if damage_dealt or player == null:
		return

	traveled += delta
	if traveled >= max_travel_time:
		queue_free()
		return

	var direction = (player.global_position - global_position).normalized()
	global_position += direction * speed * delta
	

func get_damage() -> float:
	damage_dealt = true
	return damage

func destroy_object() -> void:
	queue_free()
