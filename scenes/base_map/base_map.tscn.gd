extends Node2D

func _ready() -> void:
	for static_platform in $StaticPlatforms.get_children():
		var platform_body := StaticBody2D.new();
		var platform_collision := CollisionPolygon2D.new();
		platform_collision.polygon = static_platform.polygon;
		platform_body.add_child(platform_collision);
		static_platform.add_child(platform_body);
		pass;
	pass;
