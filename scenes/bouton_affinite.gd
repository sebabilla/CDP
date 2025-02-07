extends TextureRect

const LARG_HAUT_MIN: Vector2 = Vector2(48, 16)
var couleurs: Array[Texture] = [
	preload("res://images/orange.png"),
	preload("res://images/gris.png"),
	preload("res://images/vert.png")
	]
var donneur_indice: int = 0
var receveur_indice: int = 0
var receveur_nom: String = ""

func _ready() -> void:
	custom_minimum_size = LARG_HAUT_MIN
	stretch_mode = STRETCH_KEEP_CENTERED	

## Le bouton doit connaitre les élèves donneur (i) et receveur (j), et le chemin
## de la grille pour actualiser le surlignage
func qui_suis_je(i: int, j: int) -> void:
	if i == j:
		modulate.a = 0
		process_mode = PROCESS_MODE_DISABLED
		return
	donneur_indice = i
	receveur_indice = j
	receveur_nom = Globals.section.get_nom_eleve(receveur_indice)
	if Globals.section.positif_existe(donneur_indice, receveur_nom):
		texture = couleurs[2]
	elif Globals.section.negatif_existe(donneur_indice, receveur_nom):
		texture = couleurs[0]
	else:
		texture = couleurs[1]

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Noeuds.grille.maj_soulignage(global_position.y)
		if Globals.section.positif_existe(donneur_indice, receveur_nom):
			Globals.section.enlever_positif(donneur_indice, receveur_nom)
			Globals.section.ajouter_negatif(donneur_indice, receveur_nom)
			texture = couleurs[0]
		elif Globals.section.negatif_existe(donneur_indice, receveur_nom):
			Globals.section.enlever_negatif(donneur_indice, receveur_nom)
			texture = couleurs[1]
		else:
			Globals.section.ajouter_positif(donneur_indice, receveur_nom)
			texture = couleurs[2]
