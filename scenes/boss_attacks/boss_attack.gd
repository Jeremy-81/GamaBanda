extends AnimatableBody2D

@export var damage: float
@export var speed: float
@export var player: Node

var damage_dealt := false


func _physics_process(delta: float) -> void:
	if damage_dealt:
		return
	var step := speed * delta
	var direction = player.global_position
	global_position += direction * step


func get_damage() -> float:
	damage_dealt = true
	return damage

func destroy_object() -> void:
	queue_free()
