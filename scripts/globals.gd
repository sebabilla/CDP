extends Node

## La variable au coeur du programme
var section: Section = Section.new()

var taille_table: Vector2 = Vector2(128,96)

const CHEMIN_SAUVEGARDE = "user://sauvegarder"
var dossier_video: String = ""

## sauvegarde un fichier dont le nom devrait déjà avoir été vérifié	
func sauvegarder(nom: String) -> bool:
	var nom_sauvegarde: String = CHEMIN_SAUVEGARDE + "/" + nom + ".tres"
	var sauvegarde = ResourceSaver.save(section, nom_sauvegarde)
	if sauvegarde == OK: return true
	return false

## Ouvre une sauvegarde
func ouvrir(nom_fichier: String) -> bool:
	var nom_sauvegarde: String = CHEMIN_SAUVEGARDE + "/" + nom_fichier
	if ResourceLoader.exists(nom_sauvegarde):
		var nouveau: Resource = ResourceLoader.load(nom_sauvegarde, "", ResourceLoader.CACHE_MODE_IGNORE_DEEP)
		if nouveau is Section:
			section = nouveau
			Globals.section.set_titre_fenetre()
			return true
	return false
	

## Crée un dossier de sauvegarde s'il n'existe pas
func verifier_dossier_sauvegarder() -> bool:
	var dir: DirAccess = DirAccess.open("user://")
	if dir.dir_exists("sauvegarder"): return true
	elif dir.make_dir("sauvegarder") == OK: return true
	return false

## Importe le fichier d'exemple s'il n'existe pas
func verifier_exemple_sauvegarde() -> void:
	var dir: DirAccess = DirAccess.open(CHEMIN_SAUVEGARDE)
	if dir.file_exists("exemple.tres"): return
	var exemple: Section = ResourceLoader.load("res://exemples/exemple.tres")
	ResourceSaver.save(exemple, CHEMIN_SAUVEGARDE + "/exemple.tres")

## Identifie les fichiers en .tres présent dans le dossier de sauvegarde
func trouver_sauvegardes() -> PackedStringArray:
	var dir: DirAccess = DirAccess.open(CHEMIN_SAUVEGARDE)
	var fichiers: PackedStringArray = dir.get_files()
	var noms_sauvegardes: PackedStringArray = []
	for nom in fichiers:
		if nom.get_extension() == "tres":
			noms_sauvegardes.append(nom)
	if noms_sauvegardes.is_empty():
		noms_sauvegardes.append("M1_RIEN_A_OUVRIR")
	return noms_sauvegardes

## Ouvre le dossier des sauvegardes avec le gestionnaire de fichier du système d'exploitation	
func ouvrir_dossier_sauvegardes() -> bool:
	var dossier: String = ""
	match OS.get_name():
		"Linux": dossier = OS.get_data_dir() + "/Clan de place/sauvegarder"
		"Windows": dossier = OS.get_data_dir() + "\\Clan de place\\sauvegarder"
		_: return false
	OS.shell_open(dossier)
	return true

## Enregistre en .png une zone de l'image sous le nom donné
func capturer_image(nom: String, zone: Rect2) -> bool:
	if not DirAccess.open(CHEMIN_SAUVEGARDE): return false
	var plan: Image = get_viewport().get_texture().get_image().get_region(zone)
	var nom_sauvegarde: String = CHEMIN_SAUVEGARDE + "/" + nom + ".png"
	plan.save_png(nom_sauvegarde)
	return true

## Créer le dossier pour enregistrer toutes les images se succedant dans les paires
## tournantes s'il n'existe pas.
func verifier_dossier_video(nom_dossier: String) -> bool:
	var dir: DirAccess = DirAccess.open(CHEMIN_SAUVEGARDE)
	if dir.dir_exists(nom_dossier):
		dossier_video = CHEMIN_SAUVEGARDE + "/" + nom_dossier + "/"
		return true
	if dir.make_dir(nom_dossier) == OK:
		dossier_video = CHEMIN_SAUVEGARDE + "/" + nom_dossier + "/"
		return true
	return false

## Enregistre dans le dossier une image en .png de la zone fournie
func image_video(nom_dossier: String, nom_image: String, zone: Rect2) -> void:	
	var plan: Image = get_viewport().get_texture().get_image().get_region(zone)
	var nom_sauvegarde: String = CHEMIN_SAUVEGARDE + "/" + nom_dossier + "/" + nom_image + ".png"
	plan.save_png(nom_sauvegarde)
	
