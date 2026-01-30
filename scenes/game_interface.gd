extends Control

@export var boss: Node

@onready var boss_name: Label = $MarginContainer/VBoxContainer/VBoxContainer/BossName
@onready var boss_life: ProgressBar = $MarginContainer/VBoxContainer/VBoxContainer/BossLife

func _ready() -> void:
	boss.boss_ready.connect(boss_interface_init)


func boss_interface_init(name, hp) -> void:
	boss_name.text = name
	boss_life.max_value = hp
	boss_life.value = hp
