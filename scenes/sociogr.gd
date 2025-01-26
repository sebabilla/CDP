extends Control

@onready var etiquette: PackedScene = preload("res://scenes/etiquette.tscn")
@onready var fleche: PackedScene = preload("res://scenes/fleche.tscn")
enum {ORANGE, VERT}

var N: int = 0
var couleur: int = -1

## Affiche le sociogramme dans l'onglet de la classe en cours, si elle existe
func ouverture():
	nettoyer_l_onglet()
	%Orange.button_pressed = true
	%Vert.button_pressed = true
	N = Globals.section.get_nb_eleves()
	if N == 0: return
	if Globals.section.get_pos_eleve(0) == Vector2.ZERO:
		Globals.section.set_nouvelles_pos()
	get_tree().process_frame.connect(_ouverture_decalee, CONNECT_ONE_SHOT)
	
func _ouverture_decalee(): # prevenir un évenuel bug d'affichage
	_placer_etiquettes()
	_placer_fleches()

## Libère tous les noeuds du sociogramme de la mémoire	
func nettoyer_l_onglet() -> void:
	for noeud in $PorteEtiquette.get_children():
		noeud.queue_free()
	for noeud in $PorteFleches.get_children():
		noeud.queue_free()

func _placer_etiquettes() -> void:
	for i in N:
		var e: Control = etiquette.instantiate()
		e.mouvement.connect(_on_mouvement)
		$PorteEtiquette.add_child(e)
		e.initialiser(i)
		
func _placer_fleches() -> void:
	for i in N:
		for p in Globals.section.liste_positifs(i):
			var f: ColorRect = fleche.instantiate()
			$PorteFleches.add_child(f)
			f.initialiser(i, Globals.section.trouver_indice_eleve(p), VERT)
		for n in Globals.section.liste_negatifs(i):
			var f: ColorRect = fleche.instantiate()
			$PorteFleches.add_child(f)
			f.initialiser(i, Globals.section.trouver_indice_eleve(n), ORANGE)
		
func _on_reset_pressed() -> void:
	if N == 0:
		Reactions.echec()
		return
	Globals.section.set_nouvelles_pos()
	couleur = -1
	ouverture()

func _on_orange_toggled(_toggled_on: bool) -> void:
	for f in $PorteFleches.get_children():
		f.maj_col_arret(ORANGE)
		
func _on_vert_toggled(_toggled_on: bool) -> void:
	for f in $PorteFleches.get_children():
		f.maj_col_arret(VERT)
	
func _on_mouvement(indice: int) -> void:
	for f in $PorteFleches.get_children():
		f.maj_mvmt(indice)
