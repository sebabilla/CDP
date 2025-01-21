extends Control

@onready var etiquette: PackedScene = preload("res://scenes/etiquette.tscn")
@onready var fleche: PackedScene = preload("res://scenes/fleche.tscn")
enum {ORANGE, VERT}

var N: int = 0
var couleur: int = -1

func ouverture():
	nettoyer_l_onglet()
	N = Gestion.get_nb_eleves()
	if N == 0: return
	%Orange.button_pressed = true
	%Vert.button_pressed = true
	if Gestion.get_pos_eleve(0) == Vector2.ZERO:
		if not Gestion.set_nouvelles_pos(): return
	get_tree().process_frame.connect(_ouverture_decalee, CONNECT_ONE_SHOT)
	
func _ouverture_decalee():
	_placer_etiquettes()
	_placer_fleches()

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
		for p in Gestion.liste_positifs(i):
			var f: ColorRect = fleche.instantiate()
			$PorteFleches.add_child(f)
			f.initialiser(i, Gestion.trouver_indice_eleve(p), VERT)
		for n in Gestion.liste_negatifs(i):
			var f: ColorRect = fleche.instantiate()
			$PorteFleches.add_child(f)
			f.initialiser(i, Gestion.trouver_indice_eleve(n), ORANGE)
		
func _on_reset_pressed() -> void:
	Gestion.set_nouvelles_pos()
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
