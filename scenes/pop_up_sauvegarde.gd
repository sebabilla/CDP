extends ColorRect

func _ready() -> void:
	hide()
	process_mode = PROCESS_MODE_DISABLED

## Lance l'ouverture du popup de sauvegarde, réagit différement selon l'extension
## passée, actuellement possible : .tres, .png, / 
func ouverture(extension: String) -> void:
	process_mode = PROCESS_MODE_INHERIT
	%NomSauveg.grab_focus()
	_set_sauvegarde_conseillee()
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
		_: Reactions.echec()	
	
func _on_oui_pressed() -> void:
	_on_nom_sauveg_text_submitted(%NomSauveg.text)

func _on_non_pressed() -> void:
	hide()
	process_mode = PROCESS_MODE_DISABLED
