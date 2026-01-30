extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

func moove_to_background() -> void:
	sprite_2d.scale = sprite_2d.scale /2
	
func attack() -> void:
	pass


func _on_timer_timeout() -> void:
	moove_to_background()
