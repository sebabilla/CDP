extends Control

var alphazeta: bool = true

func _ready() -> void:
	_afficher_liste()

## Affiche la liste d'élève dans l'onglet de la classe en cours, si elle existe
func ouverture() -> void:
	nettoyer_l_onglet()
	_afficher_liste()

## Ne fait rien mais important pour pouvoir looper dans main
func nettoyer_l_onglet() -> void:
	pass

# Changer section/classe
func _on_entree_classe_text_submitted(new_text: String) -> void:
	%EntreeClasse.clear()
	var texte_formate: String = new_text.strip_edges().strip_escapes().replace('"', '')
	if texte_formate == "": 
		Reactions.echec()
	elif Globals.section.set_nom_section(texte_formate): 
		_afficher_liste()
		return
	else: Reactions.echec()

# changer les eleves
func _on_entree_eleve_text_submitted(new_text: String) -> void:
	%EntreeEleve.clear()
	var texte_formate: String = new_text.strip_edges().strip_escapes().replace('"', '')
	if texte_formate == "":
		Reactions.echec()
	elif Globals.section.ajouter_eleve(texte_formate):
		_afficher_liste()
	else: Reactions.echec()
	
func _on_enlever_dernier_pressed() -> void:
	if Globals.section.enlever_dernier_eleve():
		_afficher_liste()
	else: Reactions.echec()
	
func _on_reset_liste_pressed() -> void:
	if Globals.section.get_nb_eleves() == 0: 
		Reactions.echec(); return
	Globals.section.enlever_tous_eleves()
	_afficher_liste()

func _afficher_liste() -> void:
	var nb: String = str(Globals.section.get_nb_eleves())
	var classe: String = Globals.section.get_nom_section() if not Globals.section.get_nom_section().is_empty() else "??"
	%Comptage.text = classe + " : " + nb
	var liste: String = ""
	for nom in Globals.section.liste_eleves():
		liste = liste + nom + "\n"
	%Liste.text = liste

func _on_alphabet_pressed() -> void:
	if Globals.section.tri_alphabet(alphazeta): 
		_afficher_liste()
		alphazeta = not alphazeta
		%Alphabet.text = tr("C32_AZ") if alphazeta else tr("C33_ZA")
	else:
		Reactions.echec()
