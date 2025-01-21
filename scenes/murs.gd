## Attache au noeud mur dans plan.tscn
## Affiche un fond clair pour capturer le plan de classe.
extends Control

var murs: Rect2 = Rect2(Vector2.ZERO, Vector2.ZERO)

func _ready() -> void:
	hide()

func _draw() -> void:
	if murs == Rect2(Vector2.ZERO, Vector2.ZERO):
		return
	draw_rect(murs, Color.WHITE, true)

func montrer_court(zone: Rect2) -> void:
	montrer(zone)
	$Timer.start()
	
func _on_timer_timeout() -> void:
	cacher()
	
func montrer(zone: Rect2) -> void:
	show()
	var decalage: Vector2 = global_position - position 
	zone.position = zone.position - decalage
	murs = zone
	queue_redraw()
	
func cacher() -> void:
	murs = Rect2(Vector2.ZERO, Vector2.ZERO)
	queue_redraw()
	hide()
