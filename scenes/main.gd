extends Control

func _ready() -> void:
	_nom_des_onglets()
	$PopUpSauvegarde.hide()
	%Menu.cacher_capturer()
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
	%TabContainer.set_tab_title(0, "O0_CLASSE_ELEVES")
	%TabContainer.set_tab_title(1, "O3_PLAN")
	%TabContainer.set_tab_title(2, "O1_AFFINITES")
	%TabContainer.set_tab_title(3, "O2_SOCIOGRAMME")

func _on_tab_container_tab_changed(tab: int) -> void:
	for noeud in %TabContainer.get_children():
		noeud.nettoyer_l_onglet() # prend normalement du temps seulement pour nettoyer le dernier onglet puisque les autres devraient déjà être clean?
	%TabContainer.get_child(tab).ouverture()
	if tab == 1: %Menu.montrer_capturer()
	else: %Menu.cacher_capturer()

# gestion des évènements du menu et des onglets
func _on_message(message: String) -> void:
	match message:
		"sauvegarde_ouverte": %TabContainer.get_current_tab_control().ouverture()
		"sauvegarder": $PopUpSauvegarde.ouverture(".tres")
		"capturer": $PopUpSauvegarde.ouverture(".png")
		"info": $Info.ouverture_fermeture()
		"echec": _trembler()
		_: return

func _trembler() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", Vector2(5, 5), 0.05).from(Vector2.ZERO)
	tween.tween_property(self, "position", Vector2(-5, -5), 0.1).from(Vector2(5,5))
	tween.tween_property(self, "position", Vector2.ZERO, 0.05).from(Vector2(-5,-5))
