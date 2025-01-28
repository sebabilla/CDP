extends ColorRect

const FR: PackedStringArray = ["fr", "fr_FR", "fr_BE", "fr_CA", "fr_CH", "fr_LU"]

var noms_sauvegardes: PackedStringArray = ["rien"]

func _ready() -> void:
	%Ouvrir.get_popup().id_pressed.connect(_on_popup_ouvrir_pressed)
	%Langue.text = "M5_FRANCAIS" if TranslationServer.get_locale() in FR else "M5_ANGLAIS"

## Appelé si pas de dossier user trouvé, version demo web?	
func cacher_manip_sauveg() -> void:
	%Ouvrir.disabled = true
	%Dossier.disabled = true
	%Sauvegarder.disabled = true

# Ouvrir une sauvegarde
func _on_ouvrir_about_to_popup() -> void:
	%Ouvrir.get_popup().clear()
	noms_sauvegardes = Globals.trouver_sauvegardes()
	for i in noms_sauvegardes.size():
		%Ouvrir.get_popup().add_item(noms_sauvegardes[i], i)

func _on_popup_ouvrir_pressed(index: int) -> void:
	if Globals.ouvrir(noms_sauvegardes[index]):
		Noeuds.onglets.get_current_tab_control().ouverture()
		Noeuds.section_eleves.ouverture()
	else: Reactions.echec()

# Ouvrir le dossier des sauvegardes
func _on_dossier_pressed() -> void:
	if not Globals.ouvrir_dossier_sauvegardes():
		Reactions.echec()

func _on_sauvegarder_pressed() -> void:
	Noeuds.popup_sauvegarde.ouverture(".tres")

func _on_langue_pressed() -> void:
	if TranslationServer.get_locale() in FR:
		TranslationServer.set_locale("en")
		%Langue.text = tr("M5_ANGLAIS")
	else:
		TranslationServer.set_locale("fr")
		%Langue.text = tr("M5_FRANCAIS")
	
func _on_aide_pressed() -> void:
	Noeuds.info.ouverture_fermeture()
