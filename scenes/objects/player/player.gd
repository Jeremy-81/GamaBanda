extends CharacterBody2D

@export var hp: float

var base_darken_factor : float;

var DASH_SPEED : float = 2500.0;
var can_dash : bool = false;
var has_jumped : bool = false;
var in_coyote_time : bool = false;

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
		in_coyote_time = false;
	elif not in_coyote_time:
		$CoyoteTimer.start();
		in_coyote_time = true;
	
	var is_speed_falling := false;
	if has_jumped and not is_on_floor() and Input.is_action_pressed("jump"):
		is_speed_falling = true;
	
	if Input.is_action_just_pressed("dash") and can_dash and h_direction != 0.0:
		h_direction = sign(h_direction);
		v_speed = 0.0;
		$DashTimer.start();
		_shake_screen();
		_darken_screen($DashTimer.wait_time);
		can_dash = false;
		return;
	
	if Input.is_action_just_pressed("jump") and (in_coyote_time and $CoyoteTimer.time_left > 0.0 || is_on_floor()):
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
		_shake_screen(true, 0.5);
		_darken_screen();
		$FloorImpactParticles.restart();
	pass;


func _shake_screen(random_shake := false, shake_time : float = 1.0) -> void:
	var shake_tween : Tween = get_tree().create_tween();
	var shake_direction : float = (-1.0 if randi() % 2 == 0 else 1.0) if random_shake else h_direction;
	shake_tween.tween_property($CameraTransform, "rotation", -0.08 * shake_direction, 0.2 * shake_time);
	shake_tween.tween_property($CameraTransform, "rotation", 0., 0.1 * shake_time);
	shake_tween.play();
	pass;

func _darken_screen(wait_time : float = 0.0) -> void:
	var darken_tween : Tween = get_tree().create_tween();
	darken_tween.tween_method(_update_darken, base_darken_factor, 0.9 * base_darken_factor, 0.1);
	if wait_time > 0.1:
		darken_tween.tween_interval(wait_time - 0.1);
	darken_tween.tween_method(_update_darken, 0.9 * base_darken_factor, base_darken_factor, 0.08);
	darken_tween.play();
	pass;

func _update_darken(value) -> void:
	%ScreenShadow.texture.gradient.set_offset(0, value);
	pass;
	

func take_damage(amount: float) -> void:
	hp -= amount
