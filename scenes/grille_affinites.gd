extends Control

signal message(message: String)

@onready var bouton_grille: PackedScene = preload("res://scenes/bouton_affinite.tscn")

var N: int = 0
var soulignage: Rect2 = Rect2(Vector2.ZERO, Vector2.ZERO)

func ouverture() -> void:
	if Gestion.get_question().is_empty() :
		%Question.placeholder_text = tr("O13_QUESTION")
	else: %Question.text = Gestion.get_question()  
	
	nettoyer_l_onglet()
	N = Gestion.get_nb_eleves()
	if N == 0: return
	%Affinites.columns = N + 1
	_ajouter_les_cases()
	get_tree().process_frame.connect(_def_rect_souslignage, CONNECT_ONE_SHOT)
	
func nettoyer_l_onglet() -> void:
	for noeud in %Affinites.get_children():
		noeud.queue_free()

# Affichage initial de la grille
func _ajouter_les_cases() -> void:
	var chemin: NodePath = get_path()
	var liste: Array[String] = Gestion.liste_eleves()
	_ajouter_label(%Affinites, "")
	for nom in liste:
		_ajouter_label(%Affinites, nom, HORIZONTAL_ALIGNMENT_CENTER)
	for i in N:
		_ajouter_label(%Affinites, liste[i], HORIZONTAL_ALIGNMENT_RIGHT)
		for j in (N):
			_ajouter_button_a_grille_relations(i, j, chemin)
	
func _ajouter_label(noeud: Control, texte: String, alignement := HORIZONTAL_ALIGNMENT_LEFT) -> void:
	var nouveau: Label = Label.new()
	nouveau.text = texte
	nouveau.horizontal_alignment = alignement
	noeud.add_child(nouveau)

func _ajouter_button_a_grille_relations(i: int, j: int, chemin: NodePath) -> void:
	var b: TextureRect = bouton_grille.instantiate()
	%Affinites.add_child(b)
	b.qui_suis_je(i, j, chemin)

# Rectangle de mise en évidence
func _draw() -> void:
	draw_rect(soulignage, Color("3e2723"))

func _def_rect_souslignage() -> void:
	var dernier: Label = %Affinites.get_child(N)
	var largeur: float = dernier.global_position.x + dernier.size.x + 2
	var hauteur: float =  %Affinites.get_child(1).size.y + 4
	var decalage_y: float = $MarginContainer.global_position.y - $MarginContainer.position.y
	var posy: float = %Affinites.get_child(N + 1).global_position.y - decalage_y - 2
	soulignage = Rect2(8, posy, largeur, hauteur)
	queue_redraw()
	
func maj_soulignage(globaly: float) -> void: #Appelé "en dur" par les boutons
	var decalage_y: int = $MarginContainer.global_position.y - $MarginContainer.position.y
	soulignage.position.y = globaly - decalage_y - 2
	queue_redraw()

# Entrees hors tableau
func _on_question_text_submitted(new_text: String) -> void:
	var texte_formate: String = new_text.strip_edges().strip_escapes().replace('"', '')
	if texte_formate == "": _mauvaise_question()
	elif Gestion.set_question(texte_formate): return
	else: _mauvaise_question()

func _mauvaise_question() -> void:
	%Question.clear()
	message.emit("echec")
	if Gestion.get_question().is_empty() :
		%Question.placeholder_text = tr("O13_QUESTION")  
	else: %Question.text = Gestion.get_question()

func _on_effacer_pressed() -> void:
	Gestion.effacer_toutes_affinites()
	ouverture()
