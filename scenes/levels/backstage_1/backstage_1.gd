extends Node

enum TUTORIAL_TYPE {NONE, DASH, ATTACK, CHARGED_ATTACK};

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


# Attack tutorial
func _on_attack_tutorial_area_entered(_area):
	current_tutorial = TUTORIAL_TYPE.ATTACK;
	$AttackTutorialArea.queue_free();
	$CanvasLayer/ExtraGUI/AttackTutorialLabel.show();
	pass;

func _on_mannequin_pushed():
	current_tutorial = TUTORIAL_TYPE.CHARGED_ATTACK;
	$CanvasLayer/ExtraGUI/AttackTutorialLabel.hide();
	$CanvasLayer/ExtraGUI/ChargeAttackTutorialLabel.show();
	pass;


# Charged attack tutorial
func _on_mannequin_fell():
	$CanvasLayer/ExtraGUI/ChargeAttackTutorialLabel.hide();
	current_tutorial = TUTORIAL_TYPE.NONE;
	get_tree().change_scene_to_file("res://scenes/boss_fight.tscn");
	pass;


func _on_end_area_area_entered(area):
	$AnimationPlayer.play("end_tutorial");
	
	var tween = create_tween();
	tween.tween_property($Camera2D, "global_position", Vector2.ZERO, 3.0);
	tween.parallel();
	tween.tween_property($Camera2D, "zoom", Vector2.ONE * 0.25, 2.0);
	tween.play();
	pass;

func _on_end_tutorial() -> void:
	get_tree().change_scene_to_file("res://scenes/boss_fight.tscn")

func open_curtains() -> void:
	%Curtains/OpenLeft.show();
	%Curtains/OpenRight.show();
	var curtain_tween = create_tween();
	for i in range(%Curtains/LeftSide.get_child_count()):
		var subtween = create_tween();
		var curtain : Sprite2D = %Curtains/LeftSide.get_child(i);
		subtween.tween_property(curtain, "position:x", 70 * i + 35, 0.2).from(70 * i);
		subtween.parallel();
		subtween.tween_property(curtain, "modulate", Color8(100, 100, 100, 100), 0.2);
		subtween.tween_property(curtain, "modulate", Color8(0, 0, 0, 0), 0.25);
		curtain_tween.tween_subtween(subtween);
		curtain_tween.parallel();
		
		subtween = create_tween();
		curtain = %Curtains/RightSide.get_child(i);
		subtween.tween_property(curtain, "position:x", 70 * i + 35, 0.2).from(70 * i);
		subtween.parallel();
		subtween.tween_property(curtain, "modulate", Color8(100, 100, 100, 100), 0.2);
		subtween.tween_property(curtain, "modulate", Color8(0, 0, 0, 0), 0.25);
		curtain_tween.tween_subtween(subtween);
		pass;
	curtain_tween.play();
	pass;

func close_curtains() -> void:
	%Curtains/OpenLeft.hide();
	%Curtains/OpenRight.hide();
	%Curtains/LeftSide.show();
	%Curtains/RightSide.show();
	var curtain_tween = create_tween();
	
	for i in range(%Curtains/LeftSide.get_child_count() - 1, 0, -1):
		var subtween = create_tween();
		var curtain : Sprite2D = %Curtains/LeftSide.get_child(i);
		subtween.tween_property(curtain, "position:x", 70 * i - 35, 0.2).from(70 * i);
		subtween.parallel();
		subtween.tween_property(curtain, "modulate", Color8(100, 100, 100, 100), 0.2);
		subtween.tween_property(curtain, "modulate", Color8(255, 255, 255, 255), 0.25);
		curtain_tween.tween_subtween(subtween);
		curtain_tween.parallel();
		
		subtween = create_tween();
		curtain = %Curtains/RightSide.get_child(i);
		subtween.tween_property(curtain, "position:x", 70 * i - 35, 0.2).from(70 * i);
		subtween.parallel();
		subtween.tween_property(curtain, "modulate", Color8(100, 100, 100, 100), 0.2);
		subtween.tween_property(curtain, "modulate", Color8(255, 255, 255, 255), 0.25);
		curtain_tween.tween_subtween(subtween);
		pass;
	curtain_tween.play();
	pass;
