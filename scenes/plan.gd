extends Control

@onready var table: PackedScene = preload("res://scenes/bureau.tscn")
var noeud_popup_sauvegarde: Node
var N: int = 0
var vue_prof: bool = true

func ouverture():
	nettoyer_l_onglet()
	N = Gestion.get_nb_eleves()
	if N == 0:
		return
	if Gestion.get_pos_eleve(0) == Vector2.ZERO:
		if not Gestion.set_nouvelles_pos(): return
	get_tree().process_frame.connect(_placer_tables, CONNECT_ONE_SHOT)
	
func nettoyer_l_onglet() -> void:
	for noeud in $PorteTables.get_children():
		noeud.queue_free()
	for noeud in $PorteTablesVierges.get_children():
		noeud.queue_free()
		
func _placer_tables() -> void:
	for i in N:
		var t: Control = table.instantiate()
		$PorteTables.add_child(t)
		t.initialiser(i)
	for i in Gestion.get_nb_tables_vierges():
		var t: Control = table.instantiate()
		$PorteTablesVierges.add_child(t)
		t.initialiser(-i - 1)

# Tables vierges	
func _on_ajouter_pressed() -> void:
	var nombre: int = $PorteTablesVierges.get_child_count()
	if nombre >= 50:
		Reactions.echec()
		return
	Gestion.ajouter_table_vierge()
	var t: Control = table.instantiate()
	$PorteTablesVierges.add_child(t)
	t.initialiser(-nombre - 1)

func _on_enlever_pressed() -> void:
	var nombre: int = $PorteTablesVierges.get_child_count()
	if nombre < 1:
		Reactions.echec()
		return
	Gestion.enlever_derniere_table_vierge()
	$PorteTablesVierges.get_child(nombre - 1).queue_free()

# Changer de sens
func _on_retourner_pressed() -> void:
	if $PorteTables.get_child_count() == 0 and $PorteTablesVierges.get_child_count() == 0:
		Reactions.echec()
		return
	nettoyer_l_onglet()
	vue_prof = not vue_prof
	
	var coins: Rect2 = Gestion.get_pos_min_max()
	var centre: Vector2 = coins.position + coins.size / 2
	Gestion.set_pos_eleves_sym_c(centre)
	Gestion.set_pos_tables_sym_c(centre)
	_placer_tables()

# Prendre une seule capture
func _on_capturer_pressed() -> void:
	if $PorteTables.get_child_count() == 0:
		Reactions.echec()
		return
	noeud_popup_sauvegarde.ouverture(".png")
	
func capturer(nom: String) -> void:
	var zone: Rect2 = def_rect_murs()
	$Murs.montrer(zone)
	await RenderingServer.frame_post_draw
	if Enregistrer.capturer_image(nom, zone):
		await get_tree().create_timer(0.2).timeout
		$Murs.cacher()
	else: Reactions.echec()
	
	
# Série de plans de classe en faisant tourner les élèves
func _on_ronde_pressed() -> void:
	if $PorteTables.get_child_count() == 0:
		Reactions.echec()
		return
	noeud_popup_sauvegarde.ouverture("/")

func paires_tournantes(nom: String) -> void:
	if not Enregistrer.verifier_dossier_video(nom):
		Reactions.echec()
		return
	
	var toutes_combinaisons: Dictionary = Gestion.pos_angle_paires_tournantes()
	if toutes_combinaisons.is_empty(): return
	var positions: Array = toutes_combinaisons["pos"]
	var angles: Array = toutes_combinaisons["ang"]
	
	var zone: Rect2 = def_rect_murs()
	$Murs.montrer(zone)	
	for i in positions.size():
		Gestion.set_pos_angles_tous_eleves(positions[i], angles[i])
		_rafraichir()
		await get_tree().create_timer(0.2).timeout
		Enregistrer.image_video(nom, str(i), zone)
	await get_tree().create_timer(0.2).timeout
	$Murs.cacher()
	
func _rafraichir():
	for noeud in $PorteTables.get_children():
		noeud.queue_free()
	get_tree().process_frame.connect(_placer_tables, CONNECT_ONE_SHOT)
	
func def_rect_murs() -> Rect2:
	var zone: Rect2 = Gestion.get_pos_min_max()
	if zone == Rect2(Vector2.ZERO, Vector2.ZERO):
		return Rect2(Vector2.ZERO, Vector2.ZERO)
	zone.position = zone.position - Gestion.TAILLE_TABLE
	zone.size = zone.size + 2 * Gestion.TAILLE_TABLE
	return zone
