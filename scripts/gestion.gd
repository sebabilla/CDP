## Fichier global pour gérer le contenu de la ressource section : classe, question
## les élèves et leurs affinites et leurs positions sur le plan.
## Une ressource section ouverte ne devrait pas être modifiée sans passer par
## une fonction de ce fichier.
## Toutes les fonctions devraient retourner une valeur interpretable.
extends Node

const TAILLE_TABLE: Vector2 = Vector2(128, 80)

var section: Section = Section.new()

func nouvelle_section(sec: Section):
	section = sec

# fonctions pour gerer la classe et la question
func set_nom_section(nom: String) -> bool:
	if nom.length() > 0 and nom != section.classe:
		section.classe = nom
		return true
	return false
	
func get_nom_section() -> String:
	return section.classe
		
func set_question(question: String) -> bool:
	if question.length() > 0 and question != section.question:
		section.question = question
		return true
	return false
	
func _set_titre_fenetre() -> void:
	var classe: String = "    " + section.classe + " : "
	var question: String = section.question
	var titre: String = tr("TITRE") + classe + question
	DisplayServer.window_set_title(titre)
	
# functions pour gerer les eleves	
func get_nb_eleve() -> int:
	return section.eleves.size()
	
func ajouter_eleve(nom: String) -> bool:
	for eleve in section.eleves:
		if eleve.nom == nom:
			return false
	var nouveau: Eleve = Eleve.new()
	nouveau.nom = nom
	section.eleves.append(nouveau)
	return true
	
func enlever_dernier_eleve() -> bool:
	if section.eleves.size() == 0:
		return false
	section.eleves.pop_back()
	return true
	
func enlever_tous_eleves() -> bool:
	if section.eleves.size() == 0:
		return false
	section.eleves.clear()
	return true
	
func get_nom_eleve(indice: int) -> String:
	return section.eleves[indice].nom

func trouver_indice_eleve(nom: String) -> int:
	for i in section.eleves.size():
		if section.eleves[i].nom == nom:
			return i
	return -1

# obtenir la liste des eleves de trois facons
func liste_eleves() -> Array[String]:
	var liste: Array[String] = []
	for i in section.eleves.size():
		liste.append(section.eleves[i].nom)
	return liste
	
func classement_popularite() -> Array[String]:
	var liste_double: Array[Array] = []
	for eleve in liste_eleves():
		liste_double.append([eleve, popularite_eleve(eleve)])
	liste_double.sort_custom(func(a, b): return a[1] > b[1])
	var liste_simple: Array[String] = []
	for eleve in liste_double:
		liste_simple.append(eleve[0])
	return liste_simple
	
func classement_alphabet() -> Array[String]:
	var liste: Array[String] = liste_eleves()
	liste.sort()
	return liste

# Fonctions pour gérér les affinites des eleves
func positif_existe(indice: int, nom: String) -> int:
	if nom in section.eleves[indice].positifs:
		return true
	return false		
	
func ajouter_positif(indice: int, nom: String) -> bool:
	section.eleves[indice].positifs.append(nom)
	return true
	
func enlever_positif(indice: int, nom: String) -> bool:
	var id: int = section.eleves[indice].positifs.find(nom)
	if id < 0: 
		return false
	section.eleves[indice].positifs.pop_at(id)
	return true
	
func negatif_existe(indice: int, nom: String) -> int:
	if nom in section.eleves[indice].negatifs:
		return true
	return false

func ajouter_negatif(indice: int, nom: String) -> bool:
	section.eleves[indice].negatifs.append(nom)
	return true
	
func enlever_negatif(indice: int, nom: String) -> bool:
	var id: int = section.eleves[indice].negatifs.find(nom)
	if id < 0: 
		return false
	section.eleves[indice].negatifs.pop_at(id)
	return true
	
func effacer_toutes_affinites() -> bool:
	for eleve in section.eleves:
		eleve.positifs.clear()
		eleve.negatifs.clear()
	return true
	
func liste_positifs(indice: int) -> Array[String]:
	return section.eleves[indice].positifs.duplicate()
	
func liste_negatifs(indice: int) -> Array[String]:
	return section.eleves[indice].negatifs.duplicate()

func popularite_eleve(nom: String) -> int:
	var popu: int = 0
	for eleve in section.eleves:
		popu += int(nom in eleve.positifs)
		popu -= int(nom in eleve.negatifs)
	return popu

# fonctions pour definir ou lire les positions des eleves dans le viewport	
func set_pos_eleve(indice: int, pos: Vector2) -> void:
	var ecran: Vector2 = get_viewport().get_visible_rect().size
	if pos.x < 0: pos.x = 0
	if pos.x > ecran.x: pos.x = ecran.x
	if pos.y < 0: pos.y = 0
	if pos.y > ecran.y: pos.y = ecran.y
	section.eleves[indice].pos = pos

func get_pos_eleve(indice: int) -> Vector2:
	return section.eleves[indice].pos
	
func get_pos_min_max() -> Rect2:
	if section.eleves.size() == 0:
		return Rect2(Vector2.ZERO, Vector2.ZERO)
	var x: Array[float]
	var y: Array[float]
	for eleve in section.eleves:
		x.append(eleve.pos.x)
		y.append(eleve.pos.y)
	return Rect2(x.min(), y.min(), x.max() - x.min(), y.max() - y.min())
	
func set_pos_eleves_sym_c(centre: Vector2) -> void:
	for eleve in section.eleves:
		eleve.pos = 2 * centre - eleve.pos
	
func set_pos_selon_popu() -> bool:
	var lignes: int = floor(sqrt(get_nb_eleve()))
	if lignes == 0:
		return false
	var r: int = 0
	for eleve in classement_popularite():
		var i: int = trouver_indice_eleve(eleve)
		var nv_pos: Vector2 = Vector2(r / lignes * TAILLE_TABLE.x, r % lignes * TAILLE_TABLE.y) + 2*TAILLE_TABLE
		set_pos_eleve(i, nv_pos)
		r += 1
	return true
	
func set_pos_selon_alpha() -> bool:
	var lignes: int = floor(sqrt(get_nb_eleve()))
	if lignes == 0:
		return false
	for eleve in classement_alphabet():
		var i: int = trouver_indice_eleve(eleve)
		var nv_pos: Vector2 = Vector2(i / lignes * TAILLE_TABLE.x, i % lignes * TAILLE_TABLE.y) + 2*TAILLE_TABLE
		set_pos_eleve(i, nv_pos)
	return true
	
