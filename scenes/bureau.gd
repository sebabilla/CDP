extends Control

var eleve: int = -1
var deplacer: bool = true
var ecran: Vector2 = Vector2.ZERO

func _ready() -> void:
	$Label.mouse_filter = Control.MOUSE_FILTER_STOP
	$Label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	$Label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	$Label.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY
	
func _process(_delta: float) -> void:
	if deplacer:
		var pos: Vector2 = get_global_mouse_position()
		pos = pos.clamp(Vector2.ZERO, ecran)
		global_position = pos
		if eleve >= 0:
			Gestion.set_pos_eleve(eleve, pos)
	else:
		$Label.rotation = global_position.angle_to_point(get_global_mouse_position())
		
func initialiser(don: int) -> void:
	ecran = get_viewport().get_visible_rect().size
	eleve = don
	$Label.size = Gestion.TAILLE_TABLE
	$Label.position = -$Label.size / 2
	$Label.pivot_offset = $Label.size / 2
	if eleve < 0:
		global_position = 2 * Gestion.TAILLE_TABLE + Vector2(-1*eleve,-3*eleve)
	else:
		$Label.text = Gestion.get_nom_eleve(eleve)
		global_position = Gestion.get_pos_eleve(eleve)
	set_process(false)

func _on_label_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			set_process(true)
			if event.button_index == MOUSE_BUTTON_LEFT:
				ecran = get_viewport().get_visible_rect().size
				deplacer = true
			if event.button_index == MOUSE_BUTTON_RIGHT:
				deplacer = false
		else:
			set_process(false)
			_aligner()
				
func _aligner() -> void:
	if deplacer:
		global_position = global_position.snapped(Vector2(16, 16))
		if eleve >= 0:
			Gestion.set_pos_eleve(eleve, global_position)
	else:
		$Label.rotation_degrees = snapped($Label.rotation_degrees, 10)
		
