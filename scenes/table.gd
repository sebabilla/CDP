extends Label

var eleve: int = -1

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	pivot_offset = Gestion.TAILLE_TABLE / 2
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	autowrap_mode = TextServer.AUTOWRAP_ARBITRARY
	
func _process(_delta: float) -> void:
	if eleve < 0:
		global_position = get_global_mouse_position() - size / 2
	else:
		Gestion.set_pos_eleve(eleve, get_global_mouse_position())
		global_position = Gestion.get_pos_eleve(eleve) - size / 2
	
func initialiser(don: int) -> void:
	eleve = don
	size = Gestion.TAILLE_TABLE
	if eleve < 0:
		global_position = Gestion.TAILLE_TABLE + Vector2(-1*eleve,-3*eleve)
	else:
		text = Gestion.get_nom_eleve(eleve)
		global_position = Gestion.get_pos_eleve(eleve) - size / 2
	set_process(false)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				set_process(true)
			else:
				set_process(false)
				_aligner()
				
func _aligner() -> void:
	var x:int = roundi(global_position.x)
	var modx: int = x % 16
	x = x - modx if modx < 8 else x + (16 - modx)
	var y: int = roundi(global_position.y)
	var mody: int = y % 16
	y = y - mody if mody < 8 else y + (16 - mody)
	global_position = Vector2(x, y)
	
	if eleve >= 0:
		Gestion.set_pos_eleve(eleve, global_position + size / 2)
