extends Control

signal mouvement(indice: int) #-1 arret, sinon indice eleve

var eleve: int = -1
var ecran: Vector2 = Vector2.ZERO

func _ready() -> void:
	$Label.mouse_filter = Control.MOUSE_FILTER_STOP
	
func _process(_delta: float) -> void:
	global_position = get_global_mouse_position().clamp(Vector2.ZERO, ecran)
	Globals.section.set_pos_eleve(eleve, global_position)

## indice de l'élève de l'étiquette
func initialiser(indice: int) -> void:
	eleve = indice
	$Label.text = Globals.section.get_nom_eleve(eleve)
	$Label.position = -$Label.size / 2
	global_position = Globals.section.get_pos_eleve(eleve)
	set_process(false)

func _on_label_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			ecran = get_viewport().get_visible_rect().size
			if event.pressed:
				set_process(true)
				mouvement.emit(eleve)
				ecran = get_viewport().get_visible_rect().size
			else:
				set_process(false)
				mouvement.emit(-1)
