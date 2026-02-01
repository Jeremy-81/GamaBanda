class_name Player
extends CharacterBody2D

signal life_changed(life)
signal player_ready(name, hp)
signal player_died

@export var hp: float
@export var player_name: String
@export var damage: float
@export var ko_damage: float

@onready var dash_timer: Timer = $DashTimer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var screen_shadow: TextureRect = %ScreenShadow
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var camera_transform: RemoteTransform2D = $CameraTransform


var in_range: bool = false
var loading_attack: float = 0.0

var base_darken_factor : float;

var DASH_SPEED : float = 2500.0;
var can_dash : bool = false;
var has_jumped : bool = false;
var in_coyote_time : bool = false;

var gravity : float = 2200.0;
var jump_speed : float = 1200.0;

var h_direction : float = 0.0;
var h_speed : float = 800.0;
var v_speed : float = 0.0;

@export var attack_counter : int = 0;

func _ready():
	base_darken_factor = screen_shadow.texture.gradient.get_offset(0);
	
	await get_tree().process_frame
	player_ready.emit(player_name, hp)


func _process(delta) -> void:
	# Dash state overwrites all movement.
	if dash_timer.time_left > 0.0:
		velocity = Vector2(DASH_SPEED * h_direction, v_speed);
		move_and_slide();
		return;
	
	h_direction = Input.get_axis("go_left", "go_right");
	
	if h_direction != 0.0:
		animation_tree.set("parameters/Direction/blend_position", h_direction);
	animation_tree.set("parameters/Movement/blend_position", h_direction);
	
	if is_on_floor():
		can_dash = true;
		has_jumped = false;
		in_coyote_time = false;
	elif not in_coyote_time:
		coyote_timer.start();
		in_coyote_time = true;
	animation_tree.set("parameters/StateMachineJump/conditions/landed", is_on_floor());
	
	var is_speed_falling := false;
	if has_jumped and not is_on_floor() and Input.is_action_pressed("jump"):
		is_speed_falling = true;
	animation_tree.set("parameters/StateMachineJump/conditions/impulse", is_speed_falling);
	
	if Input.is_action_just_pressed("dash") and can_dash and h_direction != 0.0:
		h_direction = sign(h_direction);
		v_speed = 0.0;
		dash_timer.start();
		_shake_screen();
		_darken_screen(dash_timer.wait_time);
		animation_tree.set("parameters/Dash/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);
		can_dash = false;
		return;
	
	if Input.is_action_just_pressed("jump") and (in_coyote_time and coyote_timer.time_left > 0.0 || is_on_floor()):
		v_speed = -jump_speed;
		animation_tree.set("parameters/Jump/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);
	if Input.is_action_just_released("jump") and !has_jumped:
		has_jumped = true;
	
	if is_speed_falling:
		v_speed += gravity * delta * 4;
	else:
		v_speed += gravity * delta;
	
	velocity = Vector2(h_direction * h_speed, v_speed);
	move_and_slide();
	v_speed = velocity.y;
	
	if is_speed_falling and is_on_floor():
		_shake_screen(true, 0.5);
		_darken_screen();
		$FloorImpactParticles.restart();
	
	if Input.is_action_just_pressed("attack"):
		attack_counter = clamp(attack_counter + 1, 0, 1);
		if not animation_tree.get("parameters/Attack/active"):
			animation_tree.set("parameters/Attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE);
	
	if Input.is_action_pressed("attack"):
		loading_attack += delta;
	
	if Input.is_action_just_released("attack") and loading_attack >= 1.0:
		loading_attack = 0.0;


func _shake_screen(random_shake: bool = false, shake_time: float = 1.0) -> void:
	var shake_tween : Tween = get_tree().create_tween();
	var shake_direction : float = (-1.0 if randi() % 2 == 0 else 1.0) if random_shake else h_direction;
	shake_tween.tween_property(camera_transform, "rotation", -0.08 * shake_direction, 0.2 * shake_time);
	shake_tween.tween_property(camera_transform, "rotation", 0., 0.1 * shake_time);
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
	screen_shadow.texture.gradient.set_offset(0, value);
	pass;
	

func take_damage(amount: float, _ko_damage : float) -> void:
	_shake_screen()
	hp -= amount
	if hp < 0.0:
		hp = 0.0
	life_changed.emit(hp)
	if hp == 0.0:
		player_die()

func player_die() -> void:
	player_died.emit()

func consume_attack() -> void:
	attack_counter -= 1;
