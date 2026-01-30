extends CharacterBody2D

var base_darken_factor : float;

var DASH_SPEED : float = 2500.0;
var can_dash : bool = false;
var has_jumped : bool = false;

var gravity : float = 1800.0;

var h_direction : float = 0.0;
var h_speed : float = 800.0;
var v_speed : float = 0.0;

func _ready():
	base_darken_factor = %ScreenShadow.texture.gradient.get_offset(0);
	pass;


func _process(delta) -> void:
	# Dash state overwrites all movement.
	if $DashTimer.time_left > 0.0:
		velocity = Vector2(DASH_SPEED * h_direction, v_speed);
		move_and_slide();
		return;
	
	h_direction = Input.get_axis("go_left", "go_right");
	
	if is_on_floor():
		can_dash = true;
		has_jumped = false;
	
	var is_speed_falling := false;
	if has_jumped and not is_on_floor() and Input.is_action_pressed("jump"):
		is_speed_falling = true;
	
	if Input.is_action_just_pressed("dash") and can_dash:
		h_direction = sign(h_direction);
		v_speed = 0.0;
		$DashTimer.start();
		_shake_screen();
		_darken_screen();
		can_dash = false;
		return;
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		v_speed = -800.0;
	if Input.is_action_just_released("jump") and !has_jumped:
		has_jumped = true;
	
	if is_speed_falling:
		v_speed += gravity * delta * 16;
	else:
		v_speed += gravity * delta;
	
	velocity = Vector2(h_direction * h_speed, v_speed);
	move_and_slide();
	v_speed = velocity.y;
	
	if is_speed_falling and is_on_floor():
		$FloorImpactParticles.restart();
	pass;


func _shake_screen() -> void:
	var shake_tween = get_tree().create_tween();
	shake_tween.tween_property($CameraTransform, "rotation", -0.08 * h_direction, 0.2);
	shake_tween.tween_property($CameraTransform, "rotation", 0., 0.1);
	shake_tween.play();
	pass;

func _darken_screen() -> void:
	var darken_tween = get_tree().create_tween();
	darken_tween.tween_method(_update_darken, base_darken_factor, 0.9 * base_darken_factor, 0.1);
	darken_tween.tween_interval($DashTimer.wait_time - 0.1);
	darken_tween.tween_method(_update_darken, 0.9 * base_darken_factor, base_darken_factor, 0.08);
	darken_tween.play();
	pass;

func _update_darken(value) -> void:
	%ScreenShadow.texture.gradient.set_offset(0, value);
	pass;
