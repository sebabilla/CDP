extends Control

@onready var bouton_grille: PackedScene = preload("res://scenes/bouton_affinite.tscn")

var N: int = 0
var soulignage: Rect2 = Rect2(Vector2.ZERO, Vector2.ZERO)

## Affiche la grille d'affinité dans l'onglet de la classe en cours, si elle existe
func ouverture() -> void:
	nettoyer_l_onglet()
	N = Globals.section.get_nb_eleves()
	if N == 0: return
	%Affinites.columns = N + 1
	_ajouter_les_cases()
	get_tree().process_frame.connect(_def_rect_souslignage, CONNECT_ONE_SHOT)

## Libère tous les noeuds de la grille de la mémoire
func nettoyer_l_onglet() -> void:
	for noeud in %Affinites.get_children():
		noeud.queue_free()

# Affichage initial de la grille
func _ajouter_les_cases() -> void:
	var liste: Array = Globals.section.liste_eleves()
	_ajouter_label(%Affinites, "")
	for nom in liste:
		_ajouter_label(%Affinites, nom, HORIZONTAL_ALIGNMENT_CENTER)
	for i in N:
		_ajouter_label(%Affinites, liste[i], HORIZONTAL_ALIGNMENT_RIGHT)
		for j in N:
			_ajouter_button_a_grille_relations(i, j)
	
func _ajouter_label(noeud: Control, texte: String, alignement := HORIZONTAL_ALIGNMENT_LEFT) -> void:
	var nouveau: Label = Label.new()
	nouveau.text = texte
	nouveau.horizontal_alignment = alignement
	noeud.add_child(nouveau)

func _ajouter_button_a_grille_relations(i: int, j: int) -> void:
	var b: TextureRect = bouton_grille.instantiate()
	%Affinites.add_child(b)
	b.qui_suis_je(i, j)

# Rectangle de mise en évidence
func _draw() -> void:
	draw_rect(soulignage, Color("546E7A"))

func _def_rect_souslignage() -> void:
	var largeur: float = %Affinites.size.x
	var hauteur: float =  %Affinites.get_child(1).size.y + 4
	var decalage_y: float = $MarginContainer.global_position.y - $MarginContainer.position.y
	var posy: float = %Affinites.get_child(N + 1).global_position.y - decalage_y - 2
	soulignage = Rect2(8, posy, largeur, hauteur)
	queue_redraw()
	
func maj_soulignage(globaly: float) -> void: #Appelé "en dur" par les boutons
	var decalage_y: int = $MarginContainer.global_position.y - $MarginContainer.position.y
	soulignage.position.y = globaly - decalage_y - 2
	queue_redraw()

func _on_effacer_pressed() -> void:
	if N <= 1: Reactions.echec()
	else:
		Globals.section.effacer_toutes_affinites()
		ouverture()
