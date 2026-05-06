extends StaticBody2D
class_name Grave

const loot_scene := preload("res://scenes/loot.tscn")
const flash_color := Color(2.454, 2.454, 2.454, 1.0)

var health: int

@export var data: GraveData
@export var sprite_2d: Sprite2D
@export var grave_break_sound: AudioStreamPlayer2D
@export var collision_shape_2d: CollisionShape2D


func _ready() -> void:
	health = data.max_health
	sprite_2d.texture = data.texture


func take_damage(amount: int) -> void:
	health -= amount
	_flash()
	if health < 1:
		_destroy()


func _flash() -> void:
	sprite_2d.modulate = flash_color
	var tween = create_tween()
	tween.tween_property(sprite_2d, "modulate", Color.WHITE, 0.1)


func _destroy() -> void:
	visible = false
	collision_shape_2d.set_deferred("disable", true)
	_drop_loot()
	grave_break_sound.play()
	await grave_break_sound.finished
	queue_free()
	

func _drop_loot() -> void:
	var loot = loot_scene.instantiate()
	loot.position = position
	loot.loot_data = data.grave_resource
	
	var level_root = get_parent().get_parent()
	var loot_container = level_root.get_node("LootContainer")
	loot_container.add_child(loot)
	

	var tween = loot.create_tween()
	tween.set_parallel(true)
	
	var random_x = randf_range(-20, 20)
	var target_x = loot.position.x + random_x
	
	tween.tween_property(loot, "position:y", loot.position.y - 20, 0.3)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(loot, "position:y", loot.position.y, 0.3)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD).set_delay(0.3)

	tween.tween_property(loot, "position:x", target_x, 0.6)\
		.set_ease(Tween.EASE_OUT)
