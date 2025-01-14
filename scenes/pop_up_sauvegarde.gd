extends ColorRect

func _ready() -> void:
	hide()

func ouverture(extension: String) -> void:
	%NomSauveg.grab_focus()
	_set_sauvegarde_conseillee()
	_set_extension(extension)
	show()

func _set_sauvegarde_conseillee() -> void:
	%NomSauveg.text = Gestion.get_nom_section()

func _set_extension(texte: String) -> void:
	%Extension.text = texte
	
func _on_nom_sauveg_text_submitted(new_text: String) -> void:
	%NomSauveg.clear()
	var texte_formate: String = new_text.strip_edges().dedent().strip_escapes().replace(" ", "_").replace('"', '').validate_filename()
	if texte_formate == "":
		return
	match %Extension.text:
		".tres":
			if Enregistrer.sauvegarder(texte_formate):
				hide()
				return
		".png":
			if Enregistrer.capturer(texte_formate):
				hide()
				return
	
func _on_oui_pressed() -> void:
	_on_nom_sauveg_text_submitted(%NomSauveg.text)

func _on_non_pressed() -> void:
	hide()
