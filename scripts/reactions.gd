extends Node

## Feedback visuel, l'écran vibre
func echec(texte = "") -> void:
	if texte.is_empty(): pass
	else: Noeuds.popup_message.ouverture(texte)
	var tween: Tween = create_tween()
	tween.tween_property(Noeuds.main, "position", Vector2(5, 5), 0.05).from(Vector2.ZERO)
	tween.tween_property(Noeuds.main, "position", Vector2(-5, -5), 0.1).from(Vector2(5,5))
	tween.tween_property(Noeuds.main, "position", Vector2.ZERO, 0.05).from(Vector2(-5,-5))
