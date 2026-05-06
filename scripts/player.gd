extends CharacterBody2D
class_name Player


var speed = 100.00
var bump_strength: int = 1


@export var hitbox: Area2D
@export var collision_shape_2d: CollisionShape2D
@export var thunk_sound: AudioStreamPlayer2D


func _physics_process(delta: float) -> void:
	process_movement(delta)
	move_and_slide()


# Movement
func process_movement(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	var target_velocity: Vector2 = direction * speed

	var acceleration := 300.0
	var friction := 50.0

	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)


func _on_hitbox_body_entered(body: Node2D) -> void:
	if !Input.is_action_pressed("bump") && body is Grave:
		var push_strength: float = 250.0
		var direction := (global_position - body.global_position).normalized()
		velocity += direction * push_strength
		body.take_damage(bump_strength)
		thunk_sound.play()
		

func add_loot(data: LootData) -> bool:
	return true
