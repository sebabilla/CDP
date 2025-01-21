extends TextureRect

const LARG_HAUT_MIN: Vector2 = Vector2(48, 16)
var couleurs: Array[Texture] = [
	preload("res://images/gris.png"),
	preload("res://images/vert.png"),
	preload("res://images/orange.png")
	]
var donneur_indice: int = 0
var receveur_indice: int = 0
var receveur_nom: String = ""
var chemin_parent: NodePath

func _ready() -> void:
	custom_minimum_size = LARG_HAUT_MIN
	stretch_mode = STRETCH_KEEP_CENTERED	
	
func qui_suis_je(i: int, j: int, chemin: NodePath) -> void:
	if i == j:
		modulate.a = 0
		process_mode = PROCESS_MODE_DISABLED
		return
	donneur_indice = i
	receveur_indice = j
	receveur_nom = Gestion.get_nom_eleve(receveur_indice)
	if Gestion.positif_existe(donneur_indice, receveur_nom):
		texture = couleurs[1]
	elif Gestion.negatif_existe(donneur_indice, receveur_nom):
		texture = couleurs[2]
	else:
		texture = couleurs[0]
	chemin_parent = chemin

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_node(chemin_parent).maj_soulignage(global_position.y)
		if Gestion.positif_existe(donneur_indice, receveur_nom):
			Gestion.enlever_positif(donneur_indice, receveur_nom)
			Gestion.ajouter_negatif(donneur_indice, receveur_nom)
			texture = couleurs[2]
		elif Gestion.negatif_existe(donneur_indice, receveur_nom):
			Gestion.enlever_negatif(donneur_indice, receveur_nom)
			texture = couleurs[0]
		else:
			Gestion.ajouter_positif(donneur_indice, receveur_nom)
			texture = couleurs[1]
