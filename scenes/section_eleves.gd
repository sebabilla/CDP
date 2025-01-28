extends Control

var alphazeta: bool = true

func _ready() -> void:
	_afficher_liste()

## Affiche la liste d'élève dans l'onglet de la classe en cours, si elle existe
func ouverture() -> void:
	nettoyer_l_onglet()
	%NomClasse.text = Globals.section.get_nom_section()
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
		%NomClasse.text = Globals.section.get_nom_section()
		return
	else: Reactions.echec()

# changer les eleves
func _on_entree_eleve_text_submitted(new_text: String) -> void:
	%EntreeEleve.clear()
	var texte_formate: String = new_text.strip_edges().strip_escapes().replace('"', '')
	if texte_formate == "":
		Reactions.echec()
	elif Globals.section.ajouter_eleve(texte_formate):
		_maj_affichage()
	else: Reactions.echec()
	
func _on_enlever_dernier_pressed() -> void:
	if Globals.section.enlever_dernier_eleve():
		_maj_affichage()
	else: Reactions.echec()
	
func _on_reset_liste_pressed() -> void:
	if Globals.section.get_nb_eleves() == 0: 
		Reactions.echec(); return
	Globals.section.enlever_tous_eleves()
	_maj_affichage()

func _maj_affichage() -> void:
	_afficher_liste()
	Noeuds.onglets.get_current_tab_control().ouverture()

func _afficher_liste() -> void:
	%Comptage.text = str(Globals.section.get_nb_eleves())
	var liste: String = ""
	for nom in Globals.section.liste_eleves():
		liste = liste + nom + "\n"
	%Liste.text = liste

func _on_alphabet_pressed() -> void:
	if Globals.section.tri_alphabet(alphazeta): 
		_maj_affichage()
		alphazeta = not alphazeta
		%Alphabet.text = tr("C32_AZ") if alphazeta else tr("C33_ZA")
	else:
		Reactions.echec()
