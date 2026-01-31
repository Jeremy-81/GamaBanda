extends Hitbox

@export var fall_speed = 1000.0;

func _physics_process(delta):
	position.y += fall_speed * delta;
	pass;
