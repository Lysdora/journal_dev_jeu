extends Area2D

# ID de l'item (correspondant à une clé dans le dictionnaire Global.items)
@export var item_id = "potion_sante"

func _ready() -> void:
	pass



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.ajouter_item(item_id)
		queue_free()
