extends Control

func _ready() -> void:
	_nom_des_onglets()
	$PopUpSauvegarde.hide()
	%Menu.cacher_capturer()
	if not Enregistrer.verifier_dossier_sauvegarder():
		%Menu.cacher_manip_sauveg()
	else: Enregistrer.verifier_exemple_sauvegarde()

# quitter!!
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _nom_des_onglets() -> void:
	%TabContainer.set_tab_title(0, "O0_CLASSE_ELEVES")
	%TabContainer.set_tab_title(1, "O1_AFFINITES")
	%TabContainer.set_tab_title(2, "O2_SOCIOGRAMME")
	%TabContainer.set_tab_title(3, "O3_PLAN")

func _on_tab_container_tab_changed(tab: int) -> void:
	%Menu.cacher_capturer()
	match tab:
		0: %SectionEleves.ouverture()
		1: %GrilleAffinites.ouverture()
		2: %Sociogr.ouverture()
		3: 
			%Plan.ouverture()
			%Menu.montrer_capturer()
		_: pass

# gestion des évènements du menu et des onglets
func _on_message(message: String) -> void:
	match message:
		"sauvegarde_ouverte": %TabContainer.get_current_tab_control().ouverture()
		"sauvegarder": $PopUpSauvegarde.ouverture(".tres")
		"capturer": $PopUpSauvegarde.ouverture(".png")
		"info": $Info.ouverture_fermeture()
		_: return
