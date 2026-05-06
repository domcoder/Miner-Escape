extends Area2D

var loot_data: LootData
@export var sprite_2d: Sprite2D


func _ready() -> void:
	sprite_2d.texture = loot_data.texture


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.add_loot(loot_data):
			queue_free()
