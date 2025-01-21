extends Control

signal message(message: String)

var alphazeta: bool = true

func _ready() -> void:
	_afficher_liste()
	
func ouverture() -> void:
	nettoyer_l_onglet()
	_afficher_liste()
	
func nettoyer_l_onglet() -> void:
	pass

# Changer section/classe
func _on_entree_classe_text_submitted(new_text: String) -> void:
	%EntreeClasse.clear()
	var texte_formate: String = new_text.strip_edges().strip_escapes().replace('"', '')
	if texte_formate == "": 
		message.emit("echec")
	elif Gestion.set_nom_section(texte_formate): return
	else: message.emit("echec")

# changer les eleves
func _on_entree_eleve_text_submitted(new_text: String) -> void:
	%EntreeEleve.clear()
	var texte_formate: String = new_text.strip_edges().strip_escapes().replace('"', '')
	if texte_formate == "":
		message.emit("echec")
	elif Gestion.ajouter_eleve(texte_formate):
		_afficher_liste()
	else:
		message.emit("echec")
	
func _on_enlever_dernier_pressed() -> void:
	if Gestion.enlever_dernier_eleve():
		_afficher_liste()
	else:
		message.emit("echec")
	
func _on_reset_liste_pressed() -> void:
	if Gestion.enlever_tous_eleves():
		_afficher_liste()
	else:
		message.emit("echec")

func _afficher_liste() -> void:
	%Comptage.text = str(Gestion.get_nb_eleves())
	var liste: String = ""
	for nom in Gestion.liste_eleves():
		liste = liste + nom + "\n"
	%Liste.text = liste

func _on_alphabet_pressed() -> void:
	if Gestion.tri_alphabet(alphazeta): 
		_afficher_liste()
		alphazeta = not alphazeta
		%Alphabet.text = tr("O04_AZ") if alphazeta else tr("O04_ZA")
	else:
		message.emit("echec")
		
