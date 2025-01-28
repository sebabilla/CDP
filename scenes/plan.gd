extends Control

@onready var table: PackedScene = preload("res://scenes/bureau.tscn")
var N: int = 0

## Affiche le plan dans l'onglet de la classe en cours, si elle existe
func ouverture():
	nettoyer_l_onglet()
	N = Globals.section.get_nb_eleves()
	if N == 0: return
	get_tree().process_frame.connect(_placer_tables, CONNECT_ONE_SHOT)

## Libère tous les noeuds du plan de la mémoire	
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
	for i in Globals.section.get_nb_tables_vierges():
		var t: Control = table.instantiate()
		$PorteTablesVierges.add_child(t)
		t.initialiser(-i - 1)

# Ajouter des tables sans nom	
func _on_ajouter_pressed() -> void:
	var nombre: int = $PorteTablesVierges.get_child_count()
	if nombre >= 50: Reactions.echec() # nombre arbitraire, aucun pb d'en avoir plus
	else: 
		Globals.section.ajouter_table_vierge()
		var t: Control = table.instantiate()
		$PorteTablesVierges.add_child(t)
		t.initialiser(-nombre - 1)

func _on_enlever_pressed() -> void:
	var nombre: int = $PorteTablesVierges.get_child_count()
	if nombre < 1: Reactions.echec()
	else: 
		Globals.section.enlever_derniere_table_vierge()
		$PorteTablesVierges.get_child(nombre - 1).queue_free()

# Changer le plan de sens
func _on_retourner_pressed() -> void:
	if $PorteTables.get_child_count() == 0 and $PorteTablesVierges.get_child_count() == 0:
		Reactions.echec(); return
	nettoyer_l_onglet()
	
	var coins: Rect2 = Globals.section.get_pos_min_max()
	var centre: Vector2 = coins.position + coins.size / 2
	Globals.section.set_pos_eleves_sym_c(centre)
	Globals.section.set_pos_tables_sym_c(centre)
	_placer_tables()

# Prendre une seule capture
func _on_capturer_pressed() -> void:
	if $PorteTables.get_child_count() == 0: 
		Reactions.echec()
	else: Noeuds.popup_sauvegarde.ouverture(".png")

## Enregistre une image de plan avec un nom normalement déjà vérifié
func capturer(nom: String) -> void:
	var zone: Rect2 = $Murs.def_rect_murs()
	$Murs.montrer(zone)
	await RenderingServer.frame_post_draw
	if Globals.capturer_image(nom, zone):
		await get_tree().create_timer(0.2).timeout
		$Murs.cacher()
	else: Reactions.echec()
	
# Série de plans de classe en faisant tourner les élèves
func _on_ronde_pressed() -> void:
	if N == 0: Reactions.echec()
	elif N % 2 == 1: Reactions.echec(tr("A1_VIDEO_IMPAIRE"))
	else: Noeuds.popup_sauvegarde.ouverture("/")

## Enregistre une série d'image de plan  dans un dossier avec un nom normalement
## déjà vérifié 
func paires_tournantes(nom: String) -> void:
	if not Globals.verifier_dossier_video(nom):
		Reactions.echec(); return
	# Récupère toutes les combinaisons de paires possibles
	var toutes_combinaisons: Array[Array] = Globals.section.paires_tournantes()
	if toutes_combinaisons.is_empty(): 
		Reactions.echec(); return
	# Definit la zone de l'écran à capturer
	var zone: Rect2 = $Murs.def_rect_murs()
	$Murs.montrer(zone)
	# Affiche et enregistre dans une image tous les combinaisons une à une	
	for i in toutes_combinaisons.size():
		Globals.section.set_pos_angles_tous_eleves(toutes_combinaisons[i])
		_rafraichir()
		await get_tree().create_timer(0.2).timeout
		Globals.image_video(nom, str(i), zone)
	# Fin du processus
	await get_tree().create_timer(0.2).timeout
	$Murs.cacher()
	
func _rafraichir():
	for noeud in $PorteTables.get_children():
		noeud.queue_free()
	get_tree().process_frame.connect(_placer_tables, CONNECT_ONE_SHOT)

## Appelé si pas de dossier user trouvé, version demo web?
func cacher_manip_sauveg() -> void:
	%Capturer.disabled = true
	%Ronde.disabled = true
