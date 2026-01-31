extends CharacterBody2D

signal boss_ready(name, hp)
signal boss_damage(hp)
signal boss_died()

@export var boss_name: String
@export var hp: float
@export var heavy_damage_bar: float
@export var damage: float
@export var player : Node

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hit_paritcules := preload("uid://hqlkttia3yu4")
@onready var big_hit_paritcules: GPUParticles2D = $BigHitParitcules

var in_range: bool = false
var atck_rand := RandomNumberGenerator.new()

func _ready() -> void:
	await get_tree().process_frame
	boss_ready.emit(boss_name, hp)
	player.attack_boss.connect(take_player_damage)

func _on_timer_timeout() -> void:
	attack()

func attack() -> void:
	var rand_attack = atck_rand.randi_range(1, 10)
	var attack : Node = preload("res://scenes/boss_attacks/boss_attack.tscn").instantiate()
	attack.player = player
	
	add_child(attack)
	attack.global_position = global_position
	if rand_attack < 5:
		pass
	else: 
		attack.damage *= 2
		attack.speed *= 4

func get_damage() -> float:
	return damage

func take_player_damage(amount: float, type: int) -> void:
	if in_range:
		take_damage(amount, type)

func take_damage(amount: float, type: int) -> void:
	if type == 0:
		var hit_p = hit_paritcules.instantiate()
		hit_p.global_position = position
		get_parent().add_child(hit_p)
		hit_p.emitting = true
	else:
		big_hit_paritcules.emitting = true
		
	hp -= amount
	if hp < 0.0:
		hp = 0.0
	
	boss_damage.emit(hp)
	if hp == 0.0:
		boss_die()


func boss_die() -> void:
	boss_died.emit()
	queue_free()
