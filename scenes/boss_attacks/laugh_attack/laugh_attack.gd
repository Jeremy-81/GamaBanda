extends Hitbox

@export var speed : float = 2400.0;
@export var lifetime : float = 1.0;
@export var objective : Node2D;
var direction : Vector2;

func _ready():
	$LifeTimer.start(lifetime - 0.4);
	direction = global_position.direction_to(objective.global_position);
	rotation = global_position.angle_to_point(objective.global_position);
	if rotation_degrees > 90.0 or rotation_degrees < -90.0:
		rotation += PI;
	pass;

func _physics_process(delta):
	position += direction * delta * speed;
	pass;


func _on_life_timer_timeout():
	var tween = get_tree().create_tween();
	tween.tween_property($Label, "visible_ratio", 0.0, 0.4);
	tween.parallel();
	tween.tween_property(self, "modulate:a", 0.0, 0.4);
	tween.tween_callback(queue_free);
	tween.play();
	pass;
