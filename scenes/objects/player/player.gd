extends CharacterBody2D

var gravity = 1500.0;

var h_speed : float = 256.0;
var v_speed : float = 0.0;

func _process(delta):
	var h_direction : float = Input.get_axis("go_left", "go_right");
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		v_speed = -800.0;
	v_speed += gravity * delta;
	
	velocity = Vector2(h_direction * h_speed, v_speed);
	move_and_slide();
	v_speed = velocity.y;
	pass;
