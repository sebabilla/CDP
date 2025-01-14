extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func cacher() -> void:
	var barre: Control = get_v_scroll_bar()
	barre.modulate.a = 0
