extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


func survol() -> void:
	if $Affichage.is_stopped():
		$Affichage.start()
	var noeud: Control = get_parent()
	var pos: Vector2 = noeud.global_position + noeud.size * 0.7
	global_position = pos
		
func perte_survol() -> void:
	$Affichage.stop()
	hide()

func _on_affichage_timeout() -> void:
	show()
