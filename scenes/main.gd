extends Control

func _ready() -> void:
	_nom_des_onglets()
	$PopUpSauvegarde.hide()
	# Pour communication directe des noeuds statiques entre eux sans signaux
	%Plan.noeud_popup_sauvegarde = %PopUpSauvegarde
	%Menu.noeud_popup_sauvegarde = %PopUpSauvegarde
	%PopUpSauvegarde.noeud_plan = %Plan
	%Menu.noeud_info = %Info
	%Menu.noeud_onglet = %Onglets
	
	if not Enregistrer.verifier_dossier_sauvegarder():
		%Menu.cacher_manip_sauveg()
	else: Enregistrer.verifier_exemple_sauvegarde()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("Sauvegarder"): # bug : comment empecher l'écriture d'un "s" si on est focus sur un lineedit?
		if Gestion.get_nom_section().is_empty(): return
		Enregistrer.sauvegarder(Gestion.get_nom_section())

func _nom_des_onglets() -> void:
	%Onglets.set_tab_title(0, "O0_CLASSE_ELEVES")
	%Onglets.set_tab_icon(0, load("res://images/user-group-new.svg"))
	%Onglets.set_tab_title(1, "O3_PLAN")
	%Onglets.set_tab_icon(1, load("res://images/homerun.svg"))
	%Onglets.set_tab_title(2, "O1_AFFINITES")
	%Onglets.set_tab_icon(2, load("res://images/view-grid.svg"))
	%Onglets.set_tab_title(3, "O2_SOCIOGRAMME")
	%Onglets.set_tab_icon(3, load("res://images/path-mode-polyline.svg"))

func _on_tab_container_tab_changed(tab: int) -> void:
	for noeud in %Onglets.get_children():
		noeud.nettoyer_l_onglet() # prend normalement du temps seulement pour nettoyer le dernier onglet puisque les autres devraient déjà être clean?
	%Onglets.get_child(tab).ouverture()
