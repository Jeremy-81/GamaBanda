extends Node

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

func _laught_circle_attack():
	var laught_scene := preload("res://scenes/boss_attacks/laugh_attack/laugh_attack.tscn");
	var attack_direction = Vector2.UP * 800.0;
	
	for i in range(5):
		var laught = laught_scene.instantiate();
		
		laught.position = $Player.global_position + attack_direction.rotated(TAU / 5.0 * i);
		laught.objective = $Player;
		laught.lifetime = 800.0 / laught.speed * 1.5;
		
		add_child(laught);
	
	pass;


func _on_hand_fall_timer_timeout():
	_laught_circle_attack();
	pass;
