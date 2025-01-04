extends Control

func _ready() -> void:
	Globals.maj_classe_question.connect(_afficher_question)
	Globals.maj_classe_question.connect(_texte_tooltip_sauvegarde)
	_afficher_question()
	_texte_tooltip_sauvegarde()

func _afficher_question() -> void:
	var classe: String = "[b]" + Globals.eleves.classe + "[/b]" + " : "
	var question: String = Globals.eleves.question
	%Question.text = classe + question


# fonctions des entrees textes et boutons de la colonne de gauche du tableau
# envoient les entrees à Globals qui modifient ou non les valeurs
# ne doivent rien modifier aucune infos par elles-mêmes
func _on_entree_question_text_submitted(new_text: String) -> void:
	%EntreeQuestion.clear()
	var texte_formate: String = new_text.strip_edges().strip_escapes().replace('"', '')
	if texte_formate == "":
		return
	Globals.changer_question(texte_formate)

func _on_entree_classe_text_submitted(new_text: String) -> void:
	%EntreeClasse.clear()
	var texte_formate_sauvegarde: String = new_text.strip_edges().dedent().strip_escapes().replace(" ", "_").replace('"', '').validate_filename()
	if texte_formate_sauvegarde == "":
		return
	Globals.changer_nom_classe(texte_formate_sauvegarde)
	
func _on_entree_eleve_text_submitted(new_text: String) -> void:
	%EntreeQuestion.clear()
	var texte_formate: String = new_text.strip_edges().strip_escapes().replace('"', '')
	if texte_formate == "":
		return
	Globals.ajouter_nom_eleve(texte_formate)
	
func _on_enlever_dernier_pressed() -> void:
	Globals.enlever_dernier_eleve()
	
func _on_reset_liste_pressed() -> void:
	Globals.enlever_tous_eleves()

func _on_effacer_contenu_pressed() -> void:
	Globals.vider_les_cases()

# fonctions des boutons/menu en bas au centre, envoient à Globals l'intention
# de l'utilisateur de sauvegarder ou charger un fichier
func _on_sauver_pressed() -> void:
	Globals.sauvegarder_tableau()
	
func _texte_tooltip_sauvegarde() -> void:
	var nom_fichier: String = Globals.eleves.classe
	var intro: String = tr("O15_TOOLTIP")
	var texte: String = intro + "[b]" + nom_fichier + ".tres[/b]."
	%Sauver/PopUpAide.text = texte
