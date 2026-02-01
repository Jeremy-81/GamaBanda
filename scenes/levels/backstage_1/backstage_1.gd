extends Node

enum TUTORIAL_TYPE {NONE, DASH};

var current_tutorial : TUTORIAL_TYPE = TUTORIAL_TYPE.NONE;
var dash_tween : Tween = null;

func _ready():
	$Player/CameraTransform.remote_path = $Camera2D.get_path();
	
	for static_platform in $StaticPlatforms.get_children():
		var platform_body := StaticBody2D.new();
		var platform_collision := CollisionPolygon2D.new();
		platform_collision.polygon = static_platform.polygon;
		platform_body.add_child(platform_collision);
		static_platform.add_child(platform_body);
		pass;
	pass;

func _process(_delta):
	if current_tutorial == TUTORIAL_TYPE.DASH:
		if Input.is_action_just_pressed("dash"):
			end_dash_tutorial();
	pass;

func _laught_circle_attack():
	var laught_scene := preload("res://scenes/boss_attacks/laugh_attack/laugh_attack.tscn");
	var attack_direction = Vector2.UP * 600.0;
	
	for i in range(3):
		var laught = laught_scene.instantiate();
		
		laught.position = $Player.global_position + attack_direction.rotated(TAU / 5.0 * i);
		laught.objective = $Player;
		laught.lifetime = 600.0 / laught.speed * 1.5;
		
		add_child(laught);
	
	pass;

func spawn_hand():
	var hand_scene := preload("res://scenes/boss_attacks/hand_fall_attack/hand_fall_attack.tscn");
	var hand = hand_scene.instantiate();
	hand.position.x = $Player.global_position.x;
	hand.position.y = $Player.global_position.y - 700.0;
	hand.fall_speed = 3200.0;
	add_child(hand);
	pass;

func spawn_dash_tutorial():
	current_tutorial = TUTORIAL_TYPE.DASH;
	dash_tween = create_tween();
	
	dash_tween.tween_callback(
		func():
			spawn_hand();
			Engine.time_scale = 0.1;
			$CanvasLayer/ExtraGUI/DashTutorialLabel.show();
			
	);
	dash_tween.tween_interval(0.4);
	dash_tween.tween_callback(
		func():
			Engine.time_scale = 1.0;
	);
	
	dash_tween.play();
	pass;

func end_dash_tutorial():
	dash_tween.kill();
	Engine.time_scale = 1.0;
	$CanvasLayer/ExtraGUI/DashTutorialLabel.hide();
	pass;

func _on_hand_fall_timer_timeout():
	pass;

func _on_dash_tutorial_area_area_entered(_area):
	spawn_dash_tutorial();
	$DashTutorialArea.queue_free();
	pass;


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/boss_fight.tscn")
