extends Node

const CHEMIN_SAUVEGARDE = "user://sauvegarder"

var dossier_video: String = ""
var chemin_capture: String = ""

func verifier_dossier_sauvegarder() -> bool:
	var dir: DirAccess = DirAccess.open("user://")
	if dir.dir_exists("sauvegarder"): return true
	elif dir.make_dir("sauvegarder") == OK: return true
	return false
	
func verifier_exemple_sauvegarde() -> void:
	var dirU: DirAccess = DirAccess.open("user://")
	if dirU.file_exists("sauvegarder/exemple.tres"): return
	var exemple: Section = ResourceLoader.load("res://exemples/exemple.tres")
	ResourceSaver.save(exemple, CHEMIN_SAUVEGARDE + "/exemple.tres")
	
func sauvegarder(nom: String) -> bool:
	var nom_sauvegarde: String = CHEMIN_SAUVEGARDE + "/" + nom + ".tres"
	var sauvegarde = ResourceSaver.save(Gestion.section, nom_sauvegarde)
	if sauvegarde == OK: return true
	return false
		
func ouvrir(nom_fichier: String) -> bool:
	var nom_sauvegarde: String = CHEMIN_SAUVEGARDE + "/" + nom_fichier
	if ResourceLoader.exists(nom_sauvegarde):
		var nouveau: Resource = ResourceLoader.load(nom_sauvegarde, "", ResourceLoader.CACHE_MODE_IGNORE)
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

# Capture d'une image de plan
func verifier_capturer(nom: String) -> bool:
	if DirAccess.open(CHEMIN_SAUVEGARDE): 
		chemin_capture = CHEMIN_SAUVEGARDE + "/" + nom + ".png"
		return true
	else: return false

func capturer_image(zone: Rect2) -> void:
	print("OK")
	await RenderingServer.frame_post_draw
	var tout_l_ecran: Image = get_viewport().get_texture().get_image()
	var plan: Image = tout_l_ecran.get_region(zone)
	plan.save_png(chemin_capture)

# Capture d'une série d'images de plan
func verifier_dossier_video(nom: String) -> bool:
	var dir: DirAccess = DirAccess.open(CHEMIN_SAUVEGARDE)
	if dir.dir_exists(nom): 
		dossier_video = CHEMIN_SAUVEGARDE + "/" + nom + "/"
		return true
	elif dir.make_dir(nom) == OK:
		dossier_video = CHEMIN_SAUVEGARDE + "/" + nom + "/"
		return true
	return false
	
func image_video(nom: String, zone: Rect2) -> void:
	await RenderingServer.frame_post_draw
	var tout_l_ecran: Image = get_viewport().get_texture().get_image()
	var plan: Image = tout_l_ecran.get_region(zone)
	var nom_sauvegarde: String = dossier_video + nom + ".png"
	plan.save_png(nom_sauvegarde)
	
	
