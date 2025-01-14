extends Node

const CHEMIN_SAUVEGARDE = "user://sauvegarder"

var noeud_murs: NodePath

func verifier_dossier_sauvegarder() -> bool:
	var dir: DirAccess = DirAccess.open("user://")
	if dir.dir_exists("sauvegarder"): return true
	elif dir.make_dir("sauvegarder") == OK: return true
	return false
	
func verifier_exemple_sauvegarde() -> bool:
	var dirU: DirAccess = DirAccess.open("user://")
	var dirP: DirAccess = DirAccess.open("res://")
	if dirU.file_exists("sauvegarder/exemple.tres"): return true
	elif dirP.file_exists("exemples/exemple.tres"):
		if dirP.copy("exemples/exemple.tres", "user://sauvegarder/exemple.tres") == OK:
			return true
	return false		

func sauvegarder(nom: String) -> bool:
	var nom_sauvegarde: String = CHEMIN_SAUVEGARDE + "/" + nom + ".tres"
	var sauvegarde = ResourceSaver.save(Gestion.section, nom_sauvegarde)
	if sauvegarde == OK: return true
	return false
		
func ouvrir(nom_fichier: String) -> bool:
	var nom_sauvegarde: String = CHEMIN_SAUVEGARDE + "/" + nom_fichier
	if ResourceLoader.exists(nom_sauvegarde):
		var nouveau: Resource = ResourceLoader.load(nom_sauvegarde)
		if nouveau is Section:
			Gestion.nouvelle_section(nouveau)
			Gestion._set_titre_fenetre()
		else: return false
	return true
	
func trouver_sauvegardes() -> PackedStringArray:
	var noms_sauvegardes: PackedStringArray = []
	var dir: DirAccess = DirAccess.open(CHEMIN_SAUVEGARDE)
	var fichiers: PackedStringArray = dir.get_files()
	for nom in fichiers:
		if nom.get_extension() == "tres":
			noms_sauvegardes.append(nom)
	if noms_sauvegardes.is_empty():
		noms_sauvegardes.append("M1_RIEN_A_OUVRIR")
	return noms_sauvegardes
	
func trouver_chemin_dossier_sauvegarder() -> String:
	var dossier: String = ""
	if OS.get_name() == "Linux":
		dossier = OS.get_data_dir() + "/Clan de place/sauvegarder"
	elif OS.get_name() == "Windows":
		dossier = OS.get_data_dir() + "\\Clan de place\\sauvegarder"
	return dossier
	
func ouvrir_dossier(dossier: String) -> void:
	if OS.get_name() in ["Linux", "Windows"]:
		OS.shell_open(dossier)
	
func set_chemin_murs(murs: NodePath) -> void:
	noeud_murs = murs
	
func capturer(nom: String) -> bool:
	if noeud_murs.is_empty():
		return false
	var zone: Rect2 = _def_rect_murs()
	if zone == Rect2(Vector2.ZERO, Vector2.ZERO):
		return false
	get_node(noeud_murs).montrer(zone)
	get_tree().process_frame.connect(_capturer_suite.bind(nom, zone), CONNECT_ONE_SHOT)	
	return true
	
func _def_rect_murs() -> Rect2:
	var zone: Rect2 = Gestion.get_pos_min_max()
	if zone == Rect2(Vector2.ZERO, Vector2.ZERO):
		return Rect2(Vector2.ZERO, Vector2.ZERO)
	zone.position = zone.position - Gestion.TAILLE_TABLE
	zone.size = zone.size + 2 * Gestion.TAILLE_TABLE
	return zone

func _capturer_suite(nom: String, zone: Rect2) -> void:
	await RenderingServer.frame_post_draw
	var tout_l_ecran: Image = get_viewport().get_texture().get_image()
	var plan: Image = tout_l_ecran.get_region(zone)
	var nom_sauvegarde: String = CHEMIN_SAUVEGARDE + "/" + nom + ".png"
	plan.save_png(nom_sauvegarde)
