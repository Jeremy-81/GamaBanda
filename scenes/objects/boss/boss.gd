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

var in_range: bool = false

func _ready() -> void:
	await get_tree().process_frame
	boss_ready.emit(boss_name, hp)
	player.attack_boss.connect(take_player_damage)

func _on_timer_timeout() -> void:
	attack()

func attack() -> void:
	var attack : Node = preload("res://scenes/boss_attacks/boss_attack.tscn").instantiate()
	attack.player = player
	add_child(attack)

func get_damage() -> float:
	return damage

func take_player_damage(amount: float) -> void:
	if in_range:
		take_damage(amount)

func take_damage(amount: float) -> void:
	hp -= amount
	if hp < 0.0:
		hp = 0.0
	
	boss_damage.emit(hp)
	if hp == 0.0:
		boss_die()


func boss_die() -> void:
	boss_died.emit()
	queue_free()
