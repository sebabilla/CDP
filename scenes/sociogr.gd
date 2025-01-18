extends Control

@onready var etiquette: PackedScene = preload("res://scenes/etiquette.tscn")
@onready var fleche: PackedScene = preload("res://scenes/fleche.tscn")
var N: int = 0
enum {ORANGE, BLANC, VERT}
var couleur: int = BLANC

func ouverture():
	nettoyer_l_onglet()
	N = Gestion.get_nb_eleve()
	if N == 0: return
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
	Gestion.set_pos_selon_popu()
	%CouleurSociogr.text = tr("O25_POSITIF")
	couleur = 0
	ouverture()

func _on_couleur_pressed() -> void:
	if $PorteEtiquette.get_child_count() == 0:
		return
	if couleur == BLANC:
		couleur = VERT
		%CouleurSociogr.text = tr("O22_NEGATIF")
	elif couleur == VERT:
		couleur = ORANGE
		%CouleurSociogr.text = tr("O22_TOUS")
	else:
		couleur = BLANC
		%CouleurSociogr.text = tr("O22_POSITIF")
	_maj_fleches()
		
func _maj_fleches() -> void:
	for f in $PorteFleches.get_children():
		f.maj_col_arret(couleur)
		
func _on_mouvement(indice: int) -> void:
	for f in $PorteFleches.get_children():
		f.maj_mvmt(indice, couleur)
