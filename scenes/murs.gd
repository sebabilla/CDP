# Attache au noeud mur dans plan.tscn
extends Control

var murs: Rect2 = Rect2(Vector2.ZERO, Vector2.ZERO)

func _ready() -> void:
	hide()

func _draw() -> void:
	if murs == Rect2(Vector2.ZERO, Vector2.ZERO):
		return
	draw_rect(murs, Color.WHITE, true)

## Identifier la zone à "éclairer" pour faire la capture	
func def_rect_murs() -> Rect2:
	var zone: Rect2 = Globals.section.get_pos_min_max()
	if zone == Rect2(Vector2.ZERO, Vector2.ZERO):
		return Rect2(Vector2.ZERO, Vector2.ZERO)
	zone.position = zone.position - Globals.section.taille_table
	zone.size = zone.size + 2 * Globals.section.taille_table
	return zone

## Affiche un fond clair pour capturer le plan
func montrer(zone: Rect2) -> void:
	show()
	var decalage: Vector2 = global_position - position 
	zone.position = zone.position - decalage
	murs = zone
	queue_redraw()

## Cache le fond clair
func cacher() -> void:
	murs = Rect2(Vector2.ZERO, Vector2.ZERO)
	queue_redraw()
	hide()
	
