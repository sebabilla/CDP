extends Label

signal mouvement(indice: int) #-1 arret, sinon indice eleve

var eleve: int

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	
func _process(_delta: float) -> void:
	Gestion.set_pos_eleve(eleve, get_global_mouse_position())
	global_position = Gestion.get_pos_eleve(eleve) - size * 0.5
	
func initialiser(don: int) -> void:
	eleve = don
	text = Gestion.get_nom_eleve(eleve)
	global_position = Gestion.get_pos_eleve(eleve) - size * 0.5
	set_process(false)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				set_process(true)
				mouvement.emit(eleve)
			else:
				set_process(false)
				mouvement.emit(-1)
