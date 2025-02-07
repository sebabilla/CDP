extends ColorRect

func _ready() -> void:
	hide()
	process_mode = PROCESS_MODE_DISABLED

## Lance l'ouverture du popup de sauvegarde, réagit différement selon l'extension
## passée, actuellement possible : .tres, .png, / 
func ouverture(extension: String) -> void:
	process_mode = PROCESS_MODE_INHERIT
	%NomSauveg.grab_focus()
	if extension == "pswd": %NomSauveg.secret = true
	else: _set_sauvegarde_conseillee()
	_set_extension(extension)
	show()

func _set_sauvegarde_conseillee() -> void:
	%NomSauveg.text = Globals.section.get_nom_section()

func _set_extension(texte: String) -> void:
	%Extension.text = texte
	
func _on_nom_sauveg_text_submitted(new_text: String) -> void:
	%NomSauveg.clear()
	var texte_formate: String = new_text.strip_edges().dedent().strip_escapes().replace(" ", "_").replace('"', '').validate_filename()
	if texte_formate == "":
		Reactions.echec(); return
	match %Extension.text:
		".tres":
			if Globals.sauvegarder(texte_formate):
				_on_non_pressed()
		".png":
			Noeuds.plan.capturer(texte_formate)
			_on_non_pressed()
		"/":
			Noeuds.plan.paires_tournantes(texte_formate)
			_on_non_pressed()
		"pswd":
			_check_mdp_sociogramme(texte_formate)
		_: Reactions.echec()	
	
func _on_oui_pressed() -> void:
	_on_nom_sauveg_text_submitted(%NomSauveg.text)

func _on_non_pressed() -> void:
	%NomSauveg.clear()
	hide()
	process_mode = PROCESS_MODE_DISABLED
	
func _check_mdp_sociogramme(texte_formate) -> void:
	if texte_formate == "pswd":
		Noeuds.onglets.set_tab_disabled(1, false)
		Noeuds.onglets.set_tab_hidden(1, false)
		Noeuds.onglets.set_tab_disabled(2, false)
		Noeuds.onglets.set_tab_hidden(2, false)
	else:
		Reactions.echec()
	%NomSauveg.secret = false
	_on_non_pressed()
