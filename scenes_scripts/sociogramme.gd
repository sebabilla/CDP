extends Control

signal son_a_emettre(son: String)

const COUL_POSITIVES: Array[Color] = [Color("EFEBE9"), Color("CCFF90"), Color("B2FF59"), Color("76FF03")]
const COUL_NEGATIVES: Array[Color] = [Color("EFEBE9"), Color("FFD180"), Color("FF9100")]

var etiquette_en_mouvement: Label = null
var fleches: Array #[noeud de depart, noeud d'arrivee, affinite]
var affichage: int = 0 #-1 que les négatifs, 1 que les positifs
var en_cours_modif: bool = false

@onready var shader_ligne = preload("res://shaders/ligne.gdshader")

func _ready() -> void:
	Globals.nouveau_tableau_relations.connect(_nettoyer_l_onglet)


# gestion du mouvement des étiquettes d'élève par l'utilisateur	
func _process(_delta: float) -> void:
	if etiquette_en_mouvement:
		var decalage: Vector2 = etiquette_en_mouvement.size/2
		var nouveau: Vector2 = get_global_mouse_position() - decalage
		etiquette_en_mouvement.global_position = nouveau
		_maj_lignes()


func _bouger_etiquette(event: InputEvent, etiquette: Label) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				etiquette_en_mouvement = etiquette
			else:
				etiquette_en_mouvement = null
				_maj_lignes()


func ouverture():
	if Globals.nombre_eleves == 0 or Globals.eleves.plan.size() == 0 or en_cours_modif:
		return
	_nettoyer_l_onglet()
	en_cours_modif = true
	_placer_eleves(false)
	get_tree().process_frame.connect(_placer_relations, CONNECT_ONE_SHOT)
	

func _placer_eleves(tracer_nouveau: bool) -> void:
	for noeud in %PorteLabels.get_children():
		noeud.queue_free()
	var N : int = Globals.nombre_eleves
	var etiquettes_rangees: Array = _ordonner_popularite() if tracer_nouveau else [""]
	
	for i in range(N):
		var etiquette: Label = Label.new()
		var eleve: String = Globals.eleves.noms[i]
		etiquette.text = eleve
		etiquette.theme_type_variation = "LabelEtiquette"
		etiquette.mouse_filter = Control.MOUSE_FILTER_STOP
		etiquette.gui_input.connect(_bouger_etiquette.bind(etiquette))
		if tracer_nouveau:
			var coin: Vector2 = get_viewport_rect().size / 4
			var lignes: int = floor(sqrt(N))
			var indice: int =  etiquettes_rangees.find(eleve)
			etiquette.position = Vector2(indice / lignes * 128, indice % lignes * 80) + coin
		else:
			etiquette.position.x = Globals.eleves.plan[i].x
			etiquette.position.y = Globals.eleves.plan[i].y
		%PorteLabels.add_child(etiquette)
		
func _ordonner_popularite() -> Array:
	var N : int = Globals.nombre_eleves
	var eleves_ranges: Array
	eleves_ranges.resize(N)
	for i in range(N):
		eleves_ranges[i] = [Globals.eleves.noms[i], Globals.scores_individuels[i]]
	eleves_ranges.sort_custom((func(a, b): return a[1] > b[1]))
	var etiquettes_rangees : Array
	etiquettes_rangees.resize(N)
	for i in range(N):
		etiquettes_rangees[i] = eleves_ranges[i][0]
	return etiquettes_rangees
		
func _placer_relations() -> void:
	_remplir_fleches()
	_placer_lignes()
	
func _remplir_fleches() -> void:	
	fleches.clear()
	for i in range(Globals.nombre_eleves * Globals.nombre_eleves):
		var valeur: int = Globals.eleves.relations[i]
		if valeur != 0:
			fleches.append([i / Globals.nombre_eleves, i % Globals.nombre_eleves, valeur])

func _placer_lignes() -> void:
	var epaisseur_max : float = log(max(get_viewport_rect().size.x, get_viewport_rect().size.y))
	for noeud in %PorteLignes.get_children():
		noeud.queue_free()
	for fleche in fleches:
		var noeud: ColorRect = ColorRect.new()
		noeud.color = Color(Color.WHITE)
		noeud.material = ShaderMaterial.new()
		noeud.material.shader = shader_ligne
		%PorteLignes.add_child(noeud)
		reglage_ligne(noeud, fleche, epaisseur_max)
		
func _maj_lignes() -> void:
	var epaisseur_max : float = log(max(get_viewport_rect().size.x, get_viewport_rect().size.y))
	for i in range(%PorteLignes.get_child_count()):
		var noeud = %PorteLignes.get_child(i)
		reglage_ligne(noeud, fleches[i], epaisseur_max)

func reglage_ligne(noeud: ColorRect, fleche: Array, epaisseur_max: float):
	var eti_depart: Label = %PorteLabels.get_child(fleche[0])
	var eti_arrivee: Label = %PorteLabels.get_child(fleche[1])
	var depart: Vector2 = eti_depart.position + eti_depart.size/2
	var arrivee : Vector2 = eti_arrivee.position + eti_arrivee.size/2
	var valeur: int = fleche[2]
	var couleur: Color = Color(0, 0, 0, 0)
	if affichage == 0 or (affichage == -1 and valeur < 0) or (affichage == 1 and valeur > 0):
		couleur = COUL_POSITIVES[valeur] if valeur >= 0 else COUL_NEGATIVES[-valeur]
	if etiquette_en_mouvement:
			if eti_depart != etiquette_en_mouvement and eti_arrivee != etiquette_en_mouvement:
				couleur = Color(0, 0, 0, 0)
	var epaisseur: float = (epaisseur_max - log(depart.distance_to(arrivee))) * 2
	noeud.position = depart
	noeud.size.y = epaisseur
	noeud.size.x = depart.distance_to(arrivee)
	noeud.rotation = depart.angle_to_point(arrivee)	
	if epaisseur == 0.0:
		epaisseur += 0.01
	noeud.material.set_shader_parameter("frequency", 300 / epaisseur)
	noeud.material.set_shader_parameter("speed", 5)
	noeud.material.set_shader_parameter("direction", -1)
	noeud.material.set_shader_parameter("color1", couleur)
	noeud.material.set_shader_parameter("color2", Color(0, 0, 0, 0))
				
# fonctions pour répondre à la demande de l'utilisateur d'afficher un nouveau sociogramme
# et exporter le résultat ver le plan de classe. 
func _on_tracer_pressed() -> void:
	if Globals.nombre_eleves == 0:
		return
	en_cours_modif = true
	_placer_eleves(true)
	# pour calculer la nouvelle matrice de flèches à l'image d'après, sinon,
	# la matrice se formait avec les coordonnés des noeuds effacés???	
	get_tree().process_frame.connect(_placer_relations, CONNECT_ONE_SHOT)
	son_a_emettre.emit("valider")

func _on_exporte_vers_plan_pressed() -> void:
	if %PorteLabels.get_child_count() == 0:
		son_a_emettre.emit("annuler")
		return
	var plan: PackedVector3Array
	for indice in %PorteLabels.get_child_count():
		var place: Vector2 = %PorteLabels.get_child(indice).global_position
		plan.append(Vector3(place.x, place.y, indice))
	Globals.plan_de_classe(plan)
	en_cours_modif = false
	son_a_emettre.emit("important")
	

# nettoie quand la liste des eleves a changé (et donc probablement le nombre 
# de noeuds à explorer par ou la mise à jour des étiquettes
func _nettoyer_l_onglet() -> void:
	en_cours_modif = false
	fleches.clear()
	for noeud in %PorteLabels.get_children():
		noeud.queue_free()
	for noeud in %PorteLignes.get_children():
		noeud.queue_free()
	%GroupesNegatifs.text = " "
	%GroupesPositifs.text = " "


func _on_listes_binomes_generer_presse() -> void:
	if %ListesBinomes.binomes_negatifs.size() > 0 or %ListesBinomes.binomes_positifs.size() > 0:
		son_a_emettre.emit("valider")
	else:
		son_a_emettre.emit("annuler")


func _on_afficher_couleurs_pressed() -> void:
	if %PorteLabels.get_child_count() == 0:
		son_a_emettre.emit("annuler")
		return
	if affichage == 0:
		affichage = 1
		%AfficherCouleurs.text = tr("O25_NEGATIF")
		_placer_lignes()
	elif affichage == 1:
		affichage = -1
		%AfficherCouleurs.text = tr("O25_TOUS")
		_placer_lignes()
	else:
		affichage = 0
		%AfficherCouleurs.text = tr("O25_POSITIF")
		_placer_lignes()
