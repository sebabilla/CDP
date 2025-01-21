extends Control

signal message(message: String)

@onready var table: PackedScene = preload("res://scenes/bureau.tscn")
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
		message.emit("echec")
		return
	Gestion.ajouter_table_vierge()
	var t: Control = table.instantiate()
	$PorteTablesVierges.add_child(t)
	t.initialiser(-nombre - 1)

func _on_enlever_pressed() -> void:
	var nombre: int = $PorteTablesVierges.get_child_count()
	if nombre < 1:
		message.emit("echec")
		return
	Gestion.enlever_derniere_table_vierge()
	$PorteTablesVierges.get_child(nombre - 1).queue_free()

# Changer de sens
func _on_retourner_pressed() -> void:
	if $PorteTables.get_child_count() == 0 and $PorteTablesVierges.get_child_count() == 0:
		message.emit("echec")
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
		message.emit("echec")
		return
	message.emit("capturer")
	
func capturer() -> void:
	var zone: Rect2 = def_rect_murs()
	$Murs.montrer(zone)
	await get_tree().create_timer(0.2).timeout
	Enregistrer.capturer_image(zone)
	await get_tree().create_timer(0.1).timeout
	$Murs.cacher()
	
# Série de plans de classe en faisant tourner les élèves
func _on_ronde_pressed() -> void:
	if $PorteTables.get_child_count() == 0:
		message.emit("echec")
		return
	message.emit("paires_tournantes")

func paires_tournantes() -> void:
	var toutes_combinaisons: Array[Array] = Gestion.pos_paires_tournantes()
	if toutes_combinaisons.size() <= 2: return
	
	var zone: Rect2 = def_rect_murs()
	$Murs.montrer(zone)	
	for i in toutes_combinaisons.size():
		if Gestion.set_pos_tous_eleves(toutes_combinaisons[i]):
			_rafraichir()
			await get_tree().create_timer(0.2).timeout
			Enregistrer.image_video(str(i), zone)			
	await get_tree().create_timer(0.4).timeout
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
