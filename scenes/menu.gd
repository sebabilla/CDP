extends HBoxContainer

signal message(message: String) #sauvegarde_ouverte, sauvegarder, capturer, langue_changee, aide, echec

var sauvegarde_possible: bool = true
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
			message.emit("sauvegarde_ouverte")
			return
	message.emit("echec")

# Ouvrir le dossier des sauvegardes
func _on_dossier_pressed() -> void:
	var dossier: String = Enregistrer.trouver_chemin_dossier_sauvegarder()
	if dossier != "": Enregistrer.ouvrir_dossier(dossier)
	else: message.emit("echec")

func _on_sauvegarder_pressed() -> void:
	message.emit("sauvegarder")
	
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
	message.emit("langue_changee")
	
func _on_aide_pressed() -> void:
	message.emit("info")
