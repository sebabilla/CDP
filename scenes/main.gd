extends Control

func _ready() -> void:
	_nom_des_onglets()
	$PopUpSauvegarde.hide()
	if not Globals.verifier_dossier_sauvegarder(): 
		%Menu.cacher_manip_sauveg() # si impossible d'avoir un dossier de sauvegarde, cacher les menus
		%Plan.cacher_manip_sauveg()
	else: Globals.verifier_exemple_sauvegarde() # Pour charger l'exemple
	_references_des_noeuds()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("Sauvegarder"): 
		get_viewport().set_input_as_handled() # évite la propagation de l'input dans les line_edit
		%PopUpSauvegarde.ouverture(".tres")

func _nom_des_onglets() -> void:
	%Onglets.set_tab_title(0, "P0_PLAN")
	%Onglets.set_tab_icon(0, load("res://images/homerun.svg"))
	%Onglets.set_tab_title(1, "T0_AFFINITES")
	%Onglets.set_tab_icon(1, load("res://images/view-grid.svg"))
	%Onglets.set_tab_title(2, "S0_SOCIOGRAMME")
	%Onglets.set_tab_icon(2, load("res://images/path-mode-polyline.svg"))

func _on_tab_container_tab_changed(tab: int) -> void:
	for noeud in %Onglets.get_children():
		noeud.nettoyer_l_onglet() # prend normalement du temps seulement pour nettoyer le dernier onglet puisque les autres devraient déjà être clean?
	%Onglets.get_child(tab).ouverture()

# Pour communication directe des noeuds statiques entre eux sans signaux
func _references_des_noeuds() -> void:
	Noeuds.main = self
	Noeuds.menu = %Menu
	Noeuds.onglets = %Onglets
	Noeuds.section_eleves = %SectionEleves
	Noeuds.plan = %Plan
	Noeuds.grille = %GrilleAffinites
	Noeuds.sociogramme = %Sociogr
	Noeuds.info = %Info
	Noeuds.popup_sauvegarde = %PopUpSauvegarde
	Noeuds.popup_message = %PopUpMessage
