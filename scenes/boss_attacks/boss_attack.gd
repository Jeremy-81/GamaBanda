extends AnimatableBody2D

@export var damage: float
@export var target: Node
@export var speed: float

var player

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	var step := speed * delta
	var direction = player.global_position
	global_position += direction * step

func get_damage() -> float:
	return damage
