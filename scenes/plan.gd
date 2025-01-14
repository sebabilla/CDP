extends Control

@onready var table: PackedScene = preload("res://scenes/table.tscn")
var N: int = 0
var vue_prof: bool = true

func ouverture():
	_nettoyer_l_onglet()
	N = Gestion.get_nb_eleve()
	if N == 0:
		return
	if Gestion.get_pos_eleve(0) == Vector2.ZERO:
		Gestion.set_pos_selon_alpha()
	get_tree().process_frame.connect(_placer_tables, CONNECT_ONE_SHOT)
	
func _nettoyer_l_onglet() -> void:
	for noeud in $PorteTables.get_children():
		noeud.queue_free()
	for noeud in $PorteTablesVierges.get_children():
		noeud.queue_free()
		
func _placer_tables() -> void:
	for i in range(N):
		var t: Label = table.instantiate()
		$PorteTables.add_child(t)
		t.initialiser(i)
		
func _on_ajouter_pressed() -> void:
	var nombre: int = $PorteTablesVierges.get_child_count()
	if nombre >= 50:
		return 
	var t: Label = table.instantiate()
	$PorteTablesVierges.add_child(t)
	t.initialiser(-nombre - 1)

func _on_enlever_pressed() -> void:
	var nombre: int = $PorteTablesVierges.get_child_count()
	if nombre < 1:
		return
	$PorteTablesVierges.get_child(nombre - 1).queue_free()

func _on_retourner_pressed() -> void:
	if $PorteTables.get_child_count() == 0:
		return
	for noeud in $PorteTables.get_children():
		noeud.queue_free()
	vue_prof = not vue_prof
	%Retourner.text = tr("O33_VERS_VE") if vue_prof else tr("O33_VERS_VP")
	
	var centre: Vector2 = get_viewport_rect().size / 2
	Gestion.set_pos_eleves_sym_c(centre)
	_placer_tables()
	for noeud in $PorteTablesVierges.get_children():
		noeud.global_position = 2 * centre - noeud.global_position - Gestion.TAILLE_TABLE
	
