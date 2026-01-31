extends AnimatableBody2D

@export var damage: float;
@export var speed: float;
@export var lifetime : float = 3.0;

@export var objective : Node2D;

func _ready():
	$Hitbox.damage = damage;
	$LifeTimer.start(lifetime);

func _physics_process(delta: float) -> void:
	var direction : Vector2 = global_position.direction_to(objective.global_position);
	global_position += direction * speed * delta;

func _on_life_timer_timeout():
	queue_free();

func _on_hitbox_has_damaged():
	queue_free();
