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
	if nom.is_empty() or nom == section.classe:
		return false
	section.classe = nom
	return true
	
func get_nom_section() -> String:
	return section.classe
		
func set_question(question: String) -> bool:
	if question.is_empty() or question == section.question:
		return false
	section.question = question
	return true
	
func get_question() -> String:
	return section.question
	
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
		if eleve.nom == nom: return false
	var nouveau: Eleve = Eleve.new()
	nouveau.nom = nom
	section.eleves.append(nouveau)
	return true
	
func enlever_dernier_eleve() -> bool:
	if section.eleves.is_empty():
		return false
	var nom_dernier: String = section.eleves.back().nom
	for i in get_nb_eleve():
		if positif_existe(i, nom_dernier):
			enlever_positif(i, nom_dernier)
		if negatif_existe(i, nom_dernier):
			enlever_negatif(i, nom_dernier)
	section.eleves.pop_back()
	return true
	
func enlever_tous_eleves() -> bool:
	if section.eleves.is_empty():
		return false
	section.eleves.clear()
	return true
	
func get_nom_eleve(indice: int) -> String:
	if indice < 0 or indice >= get_nb_eleve():
		return ""
	return section.eleves[indice].nom

func trouver_indice_eleve(nom: String) -> int:
	for i in get_nb_eleve():
		if section.eleves[i].nom == nom:
			return i
	return -1

# obtenir la liste des eleves de trois facons
func liste_eleves() -> Array[String]:
	var liste: Array[String] = []
	for i in get_nb_eleve():
		liste.append(section.eleves[i].nom)
	return liste
	
func tri_alphabet(az: bool = true) -> bool:
	if section.eleves.is_empty(): return false
	if az: 
		section.eleves.sort_custom(func(a,b): return a.nom < b.nom)
	else:
		section.eleves.sort_custom(func(a,b): return a.nom > b.nom)
	return true
	
# Fonctions pour gérér les affinites des eleves
func positif_existe(indice: int, nom: String) -> int:
	if nom in section.eleves[indice].positifs:
		return true
	return false		
	
func ajouter_positif(indice: int, nom: String) -> bool:
	if nom == "": return false
	section.eleves[indice].positifs.append(nom)
	return true
	
func enlever_positif(indice: int, nom: String) -> bool:
	var id: int = section.eleves[indice].positifs.find(nom)
	if id < 0 or id >= get_nb_eleve(): 
		return false
	section.eleves[indice].positifs.pop_at(id)
	return true
	
func negatif_existe(indice: int, nom: String) -> int:
	if nom in section.eleves[indice].negatifs:
		return true
	return false

func ajouter_negatif(indice: int, nom: String) -> bool:
	if nom == "": return false
	section.eleves[indice].negatifs.append(nom)
	return true
	
func enlever_negatif(indice: int, nom: String) -> bool:
	var id: int = section.eleves[indice].negatifs.find(nom)
	if id < 0 or id >= get_nb_eleve(): 
		return false
	section.eleves[indice].negatifs.pop_at(id)
	return true
	
func effacer_toutes_affinites() -> bool:
	if section.eleves.is_empty(): return false
	for eleve in section.eleves:
		eleve.positifs.clear()
		eleve.negatifs.clear()
	return true
	
func liste_positifs(indice: int) -> Array[String]:
	if indice < 0 or indice >= get_nb_eleve(): return []
	return section.eleves[indice].positifs.duplicate()
	
func liste_negatifs(indice: int) -> Array[String]:
	if indice < 0 or indice >= get_nb_eleve(): return []
	return section.eleves[indice].negatifs.duplicate()

func popularite_eleve(nom: String) -> int:
	var popu: int = 0
	for eleve in section.eleves:
		popu += int(nom in eleve.positifs)
		popu -= int(nom in eleve.negatifs)
	return popu

# fonctions pour definir ou lire les positions des eleves dans le viewport	
# set_pos_eleve et get_pos_eleve sont appelée plein de fois à chaque frame alors pas de test??
func set_pos_eleve(indice: int, pos: Vector2) -> void:
	section.eleves[indice].pos = pos

func get_pos_eleve(indice: int) -> Vector2:
	return section.eleves[indice].pos
	
func get_pos_min_max() -> Rect2:
	if section.eleves.is_empty():
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
	
func set_nouvelles_pos() -> bool:
	var lignes: int = floor(sqrt(get_nb_eleve()))
	if lignes == 0: return false
	for i in range(get_nb_eleve()):
		var nv_pos: Vector2 = Vector2(i / lignes * TAILLE_TABLE.x, i % lignes * TAILLE_TABLE.y) + 2*TAILLE_TABLE
		set_pos_eleve(i, nv_pos)
	return true
	
