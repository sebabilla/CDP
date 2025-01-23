extends HBoxContainer

# Pour communication directe des noeuds statiques entre eux sans signaux
var noeud_popup_sauvegarde: Node
var noeud_info: Node
var noeud_onglet: Node

var sauvegarde_possible: bool = true #pr une démo web qui n'enregistre rien?
var noms_sauvegardes: PackedStringArray = ["rien"]
var fr: Array[String] = ["fr", "fr_FR", "fr_BE", "fr_CA", "fr_CH", "fr_LU"]

func _ready() -> void:
	$Ouvrir.get_popup().id_pressed.connect(_on_popup_ouvrir_pressed)
	$Langue.text = "M5_FRANCAIS" if TranslationServer.get_locale() in fr else "M5_ANGLAIS"
			
# Ouvrir une sauvegarde
func _on_ouvrir_about_to_popup() -> void:
	$Ouvrir.get_popup().clear()
	noms_sauvegardes = Enregistrer.trouver_sauvegardes()
	for i in range(noms_sauvegardes.size()):
		$Ouvrir.get_popup().add_item(noms_sauvegardes[i], i)

func _on_popup_ouvrir_pressed(index: int) -> void:
	if noms_sauvegardes[index].get_extension() == "tres":
		if Enregistrer.ouvrir(noms_sauvegardes[index]):
			noeud_onglet.get_current_tab_control().ouverture()
			return
	Reactions.echec()

# Ouvrir le dossier des sauvegardes
func _on_dossier_pressed() -> void:
	var dossier: String = Enregistrer.trouver_chemin_dossier_sauvegarder()
	if dossier != "": Enregistrer.ouvrir_dossier(dossier)
	Reactions.echec()

func _on_sauvegarder_pressed() -> void:
	noeud_popup_sauvegarde.ouverture(".tres")
	
func cacher_manip_sauveg() -> void:
	$Dossier.disabled = true
	$Sauvegarder.disabled = true

func _on_langue_pressed() -> void:
	if TranslationServer.get_locale() in fr:
		TranslationServer.set_locale("en")
		$Langue.text = tr("M5_ANGLAIS")
	else:
		TranslationServer.set_locale("fr")
		$Langue.text = tr("M5_FRANCAIS")
	
func _on_aide_pressed() -> void:
	noeud_info.ouverture_fermeture()
