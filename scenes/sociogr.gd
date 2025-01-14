extends Control

@onready var etiquette: PackedScene = preload("res://scenes/etiquette.tscn")
@onready var fleche: PackedScene = preload("res://scenes/fleche.tscn")
var N: int = 0
var couleur: int = 0 #-1, 0, 1

func ouverture():
	_nettoyer_l_onglet()
	N = Gestion.get_nb_eleve()
	if N == 0:
		return
	if Gestion.get_pos_eleve(0) == Vector2.ZERO:
		Gestion.set_pos_selon_popu()
	get_tree().process_frame.connect(_placer_etiquettes, CONNECT_ONE_SHOT)
	get_tree().process_frame.connect(_placer_fleches, CONNECT_ONE_SHOT)

func _nettoyer_l_onglet() -> void:
	for noeud in $PorteEtiquette.get_children():
		noeud.queue_free()
	for noeud in $PorteFleches.get_children():
		noeud.queue_free()

func _placer_etiquettes() -> void:
	for i in range(N):
		var e: Label = etiquette.instantiate()
		e.mouvement.connect(_on_mouvement)
		$PorteEtiquette.add_child(e)
		e.initialiser(i)
		
func _placer_fleches() -> void:
	for i in range(N):
		for p in Gestion.liste_positifs(i):
			var f: ColorRect = fleche.instantiate()
			$PorteFleches.add_child(f)
			f.initialiser(i, Gestion.trouver_indice_eleve(p), 1)
		for n in Gestion.liste_negatifs(i):
			var f: ColorRect = fleche.instantiate()
			$PorteFleches.add_child(f)
			f.initialiser(i, Gestion.trouver_indice_eleve(n), -1)
		
func _on_reset_pressed() -> void:
	Gestion.set_pos_selon_popu()
	%CouleurSociogr.text = tr("O25_POSITIF")
	couleur = 0
	ouverture()

func _on_couleur_pressed() -> void:
	if $PorteEtiquette.get_child_count() == 0:
		return
	if couleur == 0:
		couleur = 1
		%CouleurSociogr.text = tr("O22_NEGATIF")
	elif couleur == 1:
		couleur = -1
		%CouleurSociogr.text = tr("O22_TOUS")
	else:
		couleur = 0
		%CouleurSociogr.text = tr("O22_POSITIF")
	_maj_fleches()
		
func _maj_fleches() -> void:
	for f in $PorteFleches.get_children():
		f.maj_col_arret(couleur)
		
func _on_mouvement(indice: int) -> void:
	for f in $PorteFleches.get_children():
		f.maj_mvmt(indice, couleur)
