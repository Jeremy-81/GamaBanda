extends Hitbox

@export var speed : float = 2400.0;
@export var lifetime : float = 1.0;
@export var objective : Node2D;
var direction : Vector2;
var is_active := false;

func _ready():
	super();
	rotation = randf() * PI - PI / 2.0;
	
	direction = global_position.direction_to(objective.global_position);
	var target_rotation : float = global_position.angle_to_point(objective.global_position);
	if target_rotation > PI/2.0 or target_rotation < -PI/2.0:
		target_rotation += PI;
	
	var tween = create_tween();
	tween.tween_property(self, "modulate:a", 1.0, 0.2).from(0.0);
	tween.parallel();
	tween.tween_property(self, "rotation", target_rotation, 0.2);
	tween.tween_callback(func(): is_active = true);
	tween.play();
	$LifeTimer.start(lifetime - 0.4 + 0.2);
	pass;

func activate():
	pass;

func _physics_process(delta):
	if !is_active: return;
	position += direction * delta * speed;
	pass;


func _on_life_timer_timeout():
	$CollisionShape2D.disabled = true;
	var tween = get_tree().create_tween();
	tween.tween_property($Label, "visible_ratio", 0.0, 0.4);
	tween.parallel();
	tween.tween_property(self, "modulate:a", 0.0, 0.4);
	tween.tween_callback(queue_free);
	tween.play();
	pass;
