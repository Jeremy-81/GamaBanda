extends CharacterBody2D

var DASH_SPEED : float = 2500.0;

var gravity = 1500.0;

var h_direction : float = 0.0;
var h_speed : float = 256.0;
var v_speed : float = 0.0;

func _process(delta):
	# Dash state overwrites all movement.
	if $DashTimer.time_left > 0.0:
		velocity = Vector2(DASH_SPEED * h_direction, 0.0);
		move_and_slide();
		return;
	
	h_direction = Input.get_axis("go_left", "go_right");
	
	if Input.is_action_just_pressed("dash"):
		h_direction = sign(h_direction);
		$DashTimer.start();
		return;
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		v_speed = -800.0;
	v_speed += gravity * delta;
	
	velocity = Vector2(h_direction * h_speed, v_speed);
	move_and_slide();
	v_speed = velocity.y;
	pass;
