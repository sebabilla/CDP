extends Control


func _ready() -> void:
	_afficher_liste()
	
func ouverture() -> void:
	_afficher_liste()

# Changer section/classe et question
func _on_entree_classe_text_submitted(new_text: String) -> void:
	%EntreeClasse.clear()
	var texte_formate: String = new_text.strip_edges().strip_escapes().replace('"', '')
	if texte_formate == "": 
		return
	if Gestion.set_nom_section(texte_formate):
		_set_titre_fenetre()

func _on_entree_question_text_submitted(new_text: String) -> void:
	%EntreeQuestion.clear()
	var texte_formate: String = new_text.strip_edges().strip_escapes().replace('"', '')
	if texte_formate == "": 
		return
	if Gestion.set_question(texte_formate):
		_set_titre_fenetre()

# changer les eleves
func _on_entree_eleve_text_submitted(new_text: String) -> void:
	%EntreeEleve.clear()
	var texte_formate: String = new_text.strip_edges().strip_escapes().replace('"', '')
	if texte_formate == "":
		return
	if Gestion.ajouter_eleve(texte_formate):
		_afficher_liste()
	
func _on_enlever_dernier_pressed() -> void:
	if Gestion.enlever_dernier_eleve():
		_afficher_liste()
	
func _on_reset_liste_pressed() -> void:
	if Gestion.enlever_tous_eleves():
		_afficher_liste()

func _afficher_liste() -> void:
	var liste: String = ""
	for nom in Gestion.liste_eleves():
		liste = liste + nom + "\n"
	%Liste.text = liste

func _set_titre_fenetre() -> void:
	var classe: String = "    " + Gestion.section.classe + " : "
	var question: String = Gestion.section.question
	var titre: String = tr("TITRE") + classe + question
	DisplayServer.window_set_title(titre)
