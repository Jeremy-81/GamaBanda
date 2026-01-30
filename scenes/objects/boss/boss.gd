extends CharacterBody2D

signal boss_ready(name, hp)
signal boss_damage(hp)
signal boss_died()

@export var boss_name: String
@export var hp: float
@export var heavy_damage_bar: float
@export var damage: float


@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	await get_tree().process_frame
	boss_ready.emit(boss_name, hp)
	
func _process(delta: float) -> void:
	pass

func moove_to_background() -> void:
	sprite_2d.scale = sprite_2d.scale /2
	
func attack(target) -> void:
	pass

func _on_timer_timeout() -> void:
	moove_to_background()

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
