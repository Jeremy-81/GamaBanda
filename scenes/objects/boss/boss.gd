extends CharacterBody2D

signal boss_ready(name, hp)
signal boss_damage(hp)
signal boss_died()

@export var boss_name: String
@export var hp: float
@export var heavy_damage_bar: float
@export var player : Node

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hit_paritcules := preload("uid://hqlkttia3yu4")

var in_range: bool = false
var atck_rand := RandomNumberGenerator.new()

func _ready() -> void:
	await get_tree().process_frame;
	boss_ready.emit(boss_name, hp);

func _on_timer_timeout() -> void:
	attack();


func attack() -> void:
	var rand_attack = atck_rand.randi_range(1, 10)
	var attack : Node = preload("res://scenes/boss_attacks/homing_attack/homing_attack.tscn").instantiate();
	
	attack.objective = player;
	
	add_child(attack)
	
	attack.global_position = global_position
	if rand_attack < 5:
		pass
	else: 
		attack.damage *= 2
		attack.speed *= 4


func take_damage(damage: float, ko_damage: float) -> void:
	if ko_damage == 0.0:
		var hit_p = hit_paritcules.instantiate()
		hit_p.global_position = position
		get_parent().add_child(hit_p)
		hit_p.emitting = true
	else:
		$BigHitParticles.emitting = true;
	
	hp -= damage
	if hp < 0.0:
		hp = 0.0
	boss_damage.emit(hp)
	if hp == 0.0:
		boss_die()

func boss_die() -> void:
	boss_died.emit()
	queue_free()
