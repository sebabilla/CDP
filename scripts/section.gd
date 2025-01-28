##Le coeur du programme
class_name Section extends Resource

@export var sec: String = ""
@export var question: String = ""
@export var eleves: Array[Eleve] = []
@export var tables_vierges: Array[Table] = []
@export var taille_table: Vector2 = Vector2(128, 80)

## définir le nom de la classe
func set_nom_section(nom: String) -> bool:
	if nom.is_empty() or nom == sec: 
		return false
	sec = nom
	set_titre_fenetre()
	return true

## mise à jour du titre de la fenetre selon le nom de la classe
func set_titre_fenetre() -> void:
	DisplayServer.window_set_title(tr("TITRE") + " : %s" % sec)

## récupérer le nom de la classe	
func get_nom_section() -> String:
	return sec

## définir la question posée aux élèves sur leurs affinités	
func set_question(phrase: String) -> bool:
	if question.is_empty() or question == phrase:
		return false
	question = phrase
	return true

## récupérer le nom de la question posée aux élèves
func get_question() -> String:
	return question

## Obtenir le nombre d'élèves
func get_nb_eleves() -> int:
	return eleves.size()

## Ajouter un élève (class Eleve) à la section	
func ajouter_eleve(nom: String) -> bool:
	for eleve in eleves:
		if eleve.nom == nom: return false
	var nouveau: Eleve = Eleve.new()
	nouveau.nom = nom
	nouveau.table.pos = taille_table
	eleves.append(nouveau)
	return true

## Enlève un élève et toute trace des affinités pour lui des autres élèves
func enlever_dernier_eleve() -> bool:
	if eleves.is_empty():
		return false
	var nom_dernier: String = eleves.back().nom
	for i in get_nb_eleves():
		if positif_existe(i, nom_dernier):
			enlever_positif(i, nom_dernier)
		if negatif_existe(i, nom_dernier):
			enlever_negatif(i, nom_dernier)
	eleves.pop_back()
	return true

## Enlève tous les élèves (class Eleve) de Section.eleves 
func enlever_tous_eleves() -> void:
	eleves.clear()

## Obtenir le nom d'un élève	
func get_nom_eleve(indice: int) -> String:
	if indice < 0 or indice >= get_nb_eleves():
		return ""
	return eleves[indice].nom

## Obtenir l'indice d'un élève
func trouver_indice_eleve(nom: String) -> int:
	for i in get_nb_eleves():
		if eleves[i].nom == nom:
			return i
	return -1

## obtenir la liste des eleves
func liste_eleves() -> Array[String]:
	var liste: Array[String] = []
	for i in get_nb_eleves():
		liste.append(eleves[i].nom)
	return liste

## tri selon l'alphabet des élèves (true) ou inversé (false)
func tri_alphabet(az: bool = true) -> bool:
	if get_nb_eleves() < 2: return false
	if az: 
		eleves.sort_custom(func(a,b): return a.nom < b.nom)
	else:
		eleves.sort_custom(func(a,b): return a.nom > b.nom)
	return true

## Nom est-il dans la liste des positifs de eleves[indice] ?
func positif_existe(indice: int, nom: String) -> bool:
	return eleves[indice].positifs.has(nom)

## Nom est ajouté à la liste des positifs de eleves[indice]
func ajouter_positif(indice: int, nom: String) -> void:
	eleves[indice].positifs.append(nom)

## Nom est enlevé de la liste des positifs de eleves[indice]
func enlever_positif(indice: int, nom: String) -> void:
	eleves[indice].positifs.erase(nom)

## Nom est-il dans la liste des negatifs de eleves[indice] ?
func negatif_existe(indice: int, nom: String) -> int:
	return eleves[indice].negatifs.has(nom)

## Nom est ajouté à la liste des negatifs de eleves[indice]
func ajouter_negatif(indice: int, nom: String) -> void:
	eleves[indice].negatifs.append(nom)

## Nom est enlevé de la liste des negatifs de eleves[indice]	
func enlever_negatif(indice: int, nom: String) -> void:
	eleves[indice].negatifs.erase(nom)

## Efface toutes les listes d'affinités de chaque élève
func effacer_toutes_affinites() -> void:
	for eleve in eleves:
		eleve.positifs.clear()
		eleve.negatifs.clear()

## Retourne la liste des élèves appréciés par l'élève dont l'indice est donné
func liste_positifs(indice: int) -> Array[String]:
	if indice < 0 or indice >= get_nb_eleves(): return []
	return eleves[indice].positifs.duplicate()

## Retourne la liste des élèves peu appréciés par l'élève dont l'indice est donné
func liste_negatifs(indice: int) -> Array[String]:
	if indice < 0 or indice >= get_nb_eleves(): return []
	return eleves[indice].negatifs.duplicate()

## Retourne la différence entre le nombre d'élèves appréciant "nom" et ceux ne l'appréciant pas
func popularite_eleve(nom: String) -> int:
	var popu: int = 0
	for eleve in eleves:
		popu += int(eleve.positifs.has(nom))
		popu -= int(eleve.negatifs.has(nom))
	return popu

## Définit une nouvelle position de la table de l'élève
func set_pos_eleve(indice: int, pos: Vector2) -> void:
	eleves[indice].table.pos = pos

## Retourne la position de la table de l'élève
func get_pos_eleve(indice: int) -> Vector2:
	return eleves[indice].table.pos

## Définit un nouvel angle de la table de l'élève
func set_angle_eleve(indice: int, angle_degres: float) -> void:
	eleves[indice].table.angle = angle_degres

## Retourne l'angle de la table de l'élève	
func get_angle_eleve(indice: int) -> float:
	return eleves[indice].table.angle

## Applique une symétrie centrale à la position de tous les élèves tout en conservant
## l'orientation du texte 
func set_pos_eleves_sym_c(centre: Vector2) -> void:
	for eleve in eleves:
		eleve.table.pos = 2 * centre - eleve.table.pos

## Range les élèves dans l'ordre de la liste
func set_nouvelles_pos() -> void:
	var lignes: int = floor(sqrt(get_nb_eleves()))
	for i in get_nb_eleves():
		var nv_pos: Vector2 = Vector2(i / lignes * taille_table.x, i % lignes * taille_table.y) + 2*taille_table
		set_pos_eleve(i, nv_pos)

## Retourne toutes les combinaisons de tables d'élèves tirées en round-robin
## (une Array par séance), nécessite un nombre d'élèves paire pour bien fonctionner
func paires_tournantes() -> Array[Array]:
	if get_nb_eleves() <= 2: return []
	# Determiner les élèves en binome / evite des fonctions pour le faire faire explictement au prof
	var copie_eleves_entree: Array[Eleve] = eleves.duplicate()
	var copie_eleves_sortie: Array[Eleve] = []
	var securite = 0
	while copie_eleves_entree.size() > 1:
		securite += 1; if securite > 50: return []
		var distances: Array = []
		for eleve in copie_eleves_entree:
			distances.append([eleve, eleve.table.pos.distance_to(copie_eleves_entree[0].table.pos)])
		distances.pop_front()
		var distance_min = distances.reduce(func(minimum, eleve):
			return eleve if minimum[1] > eleve[1] else minimum)
		copie_eleves_sortie.append(copie_eleves_entree[0])
		copie_eleves_entree.pop_front()
		copie_eleves_sortie.append(distance_min[0])
		copie_eleves_entree.erase(distance_min[0])
	copie_eleves_sortie.append_array(copie_eleves_entree)
	eleves = copie_eleves_sortie
	## https://fr.wikipedia.org/wiki/Tournoi_toutes_rondes
	var tables: Array = []
	for eleve in eleves:
		tables.append(eleve.table)
	var tables_tournantes: Array[Array] = []
	for  i in (get_nb_eleves() - 1):
		tables_tournantes.append(tables)
		tables = [tables[0]] + [tables[-1]] + tables.slice(1, -1)
	return tables_tournantes

## Donne une position et un angle à tous les élèves de la liste	
func set_pos_angles_tous_eleves(tables: Array) -> void:
	for i in get_nb_eleves():
		eleves[i].table = tables[i]

## Obtenir le nombre de table vierges
func get_nb_tables_vierges() -> int:
	return tables_vierges.size()

## Créer une nouvelle table vierge, ajoutée à la fin de la liste des tables
func ajouter_table_vierge() -> void:
	var decalage: int = get_nb_tables_vierges()
	var nouveau: Table = Table.new()
	nouveau.pos = 2 * taille_table + Vector2(1,3) * decalage
	tables_vierges.append(nouveau)

## Enlève la dernière table de la liste des tables
func enlever_derniere_table_vierge() -> void:
	tables_vierges.pop_back()

## Definis une nouvelle position pour la table vierge
func set_pos_table_vierge(indice: int, pos: Vector2) -> void:
	tables_vierges[indice].pos = pos

## Retourne la position de la table vierge	
func get_pos_table_vierge(indice: int) -> Vector2:
	return tables_vierges[indice].pos

## Definis un nouvel angle pour la table vierge		
func set_angle_table_vierge(indice: int, angle_degres: float) -> void:
	tables_vierges[indice].angle = angle_degres

## Retourne l'angle de la table vierge	
func get_angle_table_vierge(indice: int) -> float:
	return tables_vierges[indice].angle
	
## Applique une symétrie centrale à toutes les tables de la liste	
func set_pos_tables_sym_c(centre: Vector2) -> void:
	for i in get_nb_tables_vierges():
		tables_vierges[i].pos = 2 * centre - tables_vierges[i].pos

## Retourne les x min y min et x max y max des centres de toutes les tables,
## avec ou sans élèves
func get_pos_min_max() -> Rect2:
	if eleves.is_empty() and tables_vierges.is_empty():
		return Rect2(Vector2.ZERO, Vector2.ZERO)
	var x: Array[float]
	var y: Array[float]
	for eleve in eleves:
		x.append(eleve.table.pos.x)
		y.append(eleve.table.pos.y)
	for table in tables_vierges:
		x.append(table.pos.x)
		y.append(table.pos.y)
	return Rect2(x.min(), y.min(), x.max() - x.min(), y.max() - y.min())
	
