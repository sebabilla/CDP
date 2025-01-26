extends Node

## Feedback visuel, l'écran vibre
func echec() -> void:
	var racine: Node = get_tree().root.get_node("Main")
	var tween: Tween = create_tween()
	tween.tween_property(racine, "position", Vector2(5, 5), 0.05).from(Vector2.ZERO)
	tween.tween_property(racine, "position", Vector2(-5, -5), 0.1).from(Vector2(5,5))
	tween.tween_property(racine, "position", Vector2.ZERO, 0.05).from(Vector2(-5,-5))
