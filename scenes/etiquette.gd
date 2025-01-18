extends Control

signal mouvement(indice: int) #-1 arret, sinon indice eleve

var eleve: int = -1
var ecran: Vector2 = Vector2.ZERO

func _ready() -> void:
	$Label.mouse_filter = Control.MOUSE_FILTER_STOP
	
func _process(_delta: float) -> void:
	var pos: Vector2 = get_global_mouse_position()
	pos = pos.clamp(Vector2.ZERO, ecran)
	global_position = pos
	Gestion.set_pos_eleve(eleve, pos)
	
func initialiser(don: int) -> void:
	ecran = get_viewport().get_visible_rect().size
	eleve = don
	$Label.text = Gestion.get_nom_eleve(eleve)
	$Label.position = -$Label.size / 2
	global_position = Gestion.get_pos_eleve(eleve)
	set_process(false)

func _on_label_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			ecran = get_viewport().get_visible_rect().size
			if event.pressed:
				set_process(true)
				mouvement.emit(eleve)
			else:
				set_process(false)
				mouvement.emit(-1)
