extends Control

var n_table: int
var deplacer: bool = true
var ecran: Vector2 = Vector2.ZERO

func _ready() -> void:
	$Label.mouse_filter = Control.MOUSE_FILTER_STOP
	$Label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	$Label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	$Label.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY
	
func _process(_delta: float) -> void:
	if deplacer: 
		global_position = get_global_mouse_position().clamp(Vector2.ZERO, ecran)
	else:
		$Label.rotation = global_position.angle_to_point(get_global_mouse_position())

## Quel type de table? indice positif pour élève, indice négatif pour table vierge
func initialiser(indice: int) -> void:
	ecran = get_viewport().get_visible_rect().size
	n_table = indice
	$Label.size = Globals.section.taille_table
	$Label.position = -$Label.size / 2
	$Label.pivot_offset = $Label.size / 2
	if n_table < 0: # tables vierges
		global_position = Globals.section.get_pos_table_vierge(-n_table - 1)
		rotation_degrees = Globals.section.get_angle_table_vierge(-n_table - 1)
	else: # tables avec nom
		$Label.text = Globals.section.get_nom_eleve(n_table)
		global_position = Globals.section.get_pos_eleve(n_table)
		rotation_degrees = Globals.section.get_angle_eleve(n_table)
	set_process(false)

func _on_label_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			set_process(true)
			move_to_front()
			if event.button_index == MOUSE_BUTTON_LEFT:
				ecran = get_viewport().get_visible_rect().size
				deplacer = true
			if event.button_index == MOUSE_BUTTON_RIGHT:
				deplacer = false
		else:
			_aligner()
			set_process(false)
			
func _aligner() -> void:
	if deplacer:
		global_position = global_position.snapped(Vector2(16, 16))
		if n_table >= 0:
			Globals.section.set_pos_eleve(n_table, global_position)
		else:
			Globals.section.set_pos_table_vierge(- n_table -1, global_position)
	else:
		$Label.rotation_degrees = snapped($Label.rotation_degrees, 10)
		if n_table >= 0:
			Globals.section.set_angle_eleve(n_table, $Label.rotation_degrees)
		else:
			Globals.section.set_angle_table_vierge(-n_table - 1, $Label.rotation_degrees)
		
