extends Control


const COULEURS = [Color("FF9100"), Color("EFEBE9"), Color("76FF03")]
var N: int = 0
var soulignage: Rect2 = Rect2(Vector2.ZERO, Vector2.ZERO)

func _draw() -> void:
	draw_rect(soulignage, Color("424242"))
	print(soulignage)

func ouverture() -> void:
	_tout_nettoyer()
	N = Gestion.get_nb_eleve()
	if N == 0: return
	
	%NomsH.columns = N
	%NomsV.columns = 1
	%Affinites.columns = N
	_ajouter_les_cases()
	_ajuster_les_tailles()
	get_tree().process_frame.connect(_ouverture_decalee, CONNECT_ONE_SHOT)
	
func _ouverture_decalee() -> void:
	_def_rect_souslignage()
	_afficher_score_initiaux()
	_desactiver_diagonale()
	

func _tout_nettoyer() -> void:
	for portenoeuds in [%NomsH, %NomsV, %Affinites]:
		for noeud in portenoeuds.get_children():
			noeud.queue_free()

func _ajouter_les_cases() -> void:
	# titres des lignes et des colonnes
	var noms: Array[String] = Gestion.liste_eleves()
	for nom in noms:
		_ajouter_label(%NomsH, nom, HORIZONTAL_ALIGNMENT_CENTER)
		_ajouter_label(%NomsV, nom, HORIZONTAL_ALIGNMENT_RIGHT)
	# boutons pour donner les affinites
	for i in range(N * N):
		_ajouter_button_a_grille_relations()
	
func _desactiver_diagonale() -> void:
	for i in range(0, N * N, N + 1):
		var noeud: Button = %Affinites.get_child(i)
		noeud.disabled = true
		noeud.modulate.a = 0
			
func _ajouter_label(noeud: Control, texte: String, alignement := HORIZONTAL_ALIGNMENT_LEFT) -> void:
	var nouveau: Label = Label.new()
	nouveau.text = texte
	nouveau.horizontal_alignment = alignement
	noeud.add_child(nouveau)

func _ajouter_button_a_grille_relations() -> void:
	var nouveau: Button = Button.new()
	nouveau.text =  "0"
	nouveau.pressed.connect(_on_button_grille_affinite_pressed.bind(nouveau))  #.tooltip_text))
	%Affinites.add_child(nouveau)
	
func _ajuster_les_tailles() -> void:
	var hauteur: int = %Affinites.get_child(0).size.y
	var largeur: int = 0
	for nom in %NomsH.get_children():
		largeur = nom.size.x if nom.size.x > largeur else largeur
	for portenoeuds in [%NomsH, %NomsV, %Affinites]:
		for noeud in portenoeuds.get_children():
			noeud.custom_minimum_size = Vector2(largeur, hauteur)
			
func _def_rect_souslignage() -> void:
	var largeur: float = get_viewport_rect().size.x
	var hauteur: int = %Affinites.get_child(0).size.y + 4
	var decalagey: int = $MarginContainer.global_position.y - $MarginContainer.position.y
	var posy: float = %Affinites.get_child(0).global_position.y - decalagey - 2
	soulignage = Rect2(0, posy, largeur, hauteur)
	queue_redraw()
	
func _maj_soulignage(noeud: Button) -> void:
	var decalagey: int = $MarginContainer.global_position.y - $MarginContainer.position.y
	var posy: float = noeud.global_position.y - decalagey - 2
	soulignage.position.y = posy
	queue_redraw()
			
func _on_button_grille_affinite_pressed(noeud: Button) -> void:
	_maj_soulignage(noeud)
	var indice: int = noeud.get_index()
	var donneur: int = indice / N
	var receveur: int = indice % N
	var r_nom: String = Gestion.liste_eleves()[receveur]
	if Gestion.positif_existe(donneur, r_nom):
		Gestion.enlever_positif(donneur, r_nom)
		Gestion.ajouter_negatif(donneur, r_nom)
		_maj_prefs(donneur)
		return
	if Gestion.negatif_existe(donneur, r_nom):
		Gestion.enlever_negatif(donneur, r_nom)
		_maj_prefs(donneur)
		return
	Gestion.ajouter_positif(donneur, r_nom)
	_maj_prefs(donneur)
	
func _maj_prefs(donneur: int) -> void:
	for receveur in range(N):
		var r_nom: String = Gestion.liste_eleves()[receveur]
		if receveur == donneur:
			pass
		elif Gestion.positif_existe(donneur, r_nom):
			_maj_case(donneur * N + receveur, 1)
		elif Gestion.negatif_existe(donneur, r_nom):
			_maj_case(donneur * N + receveur, -1)
		else:
			_maj_case(donneur * N + receveur, 0)
			
func _maj_case(indice: int, lien: int) -> void:
	var couleur: Color = COULEURS[lien + 1]
	var noeud: Button = %Affinites.get_child(indice)		
	noeud.text = str(lien)
	noeud.add_theme_color_override("font_color", couleur)
	noeud.add_theme_color_override("font_hover_color", couleur)
	noeud.add_theme_color_override("font_focus_color", couleur)	
	
func _afficher_score_initiaux() -> void:
	for n in range(N):
		_maj_prefs(n)

func _on_effacer_pressed() -> void:
	Gestion.effacer_toutes_affinites()
	ouverture()
