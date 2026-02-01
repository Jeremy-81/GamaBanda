extends Node2D

@onready var boss: CharacterBody2D = $Boss
@onready var player: CharacterBody2D = $Player

func _ready():
	$Player/CameraTransform.remote_path = $Camera2D.get_path();
	$BaseMap/Front/Curtains.open_curtains();


func _laught_circle_attack():
	var laught_scene := preload("res://scenes/boss_attacks/laugh_attack/laugh_attack.tscn");
	var attack_direction = Vector2.UP * 600.0;
	
	for i in range(3):
		var laught = laught_scene.instantiate();
		
		laught.position = $Player.global_position + attack_direction.rotated(TAU / 3.0 * i);
		laught.objective = $Player;
		laught.lifetime = 600.0 / laught.speed * 1.5;
		
		add_child(laught);
	
	pass;

func spawn_hand():
	var hand_scene := preload("res://scenes/boss_attacks/hand_fall_attack/hand_fall_attack.tscn");
	var hand = hand_scene.instantiate();
	hand.position.x = $Player.global_position.x;
	hand.position.y = $Player.global_position.y - 700.0;
	add_child(hand);
	pass;
