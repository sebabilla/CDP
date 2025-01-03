extends Control

signal couper_son
var son: bool = true

func _ready() -> void:
	_maj_textes()
	
func _maj_textes() -> void:
	_a_propos()
	_aide()
	
func _aide() -> void:
	var important: String = "[p]" + tr("O41_JAMAIS_DEBUT") + "[i]" + tr("O2_BIN_SOCIO") + "[/i]" + tr("O41_JAMAIS_FIN") + "[i]" + tr("O3_PDC") + "[/i][/p]"
	var sauvegardes: String = "[p]" + tr("O41_SAUVEGARDES") + "[/p]"
	var classe: String = "[p][b]" + tr("O1_CLASSE_ELEVES") + "[/b][/p]"
	var classe_texte: String = "[p]" + tr("O41_O1_DESCRIPTION") + "[/p]"
	var aide_classe: String = classe + classe_texte
	var bs: String = "[p][b]" + tr("O2_BIN_SOCIO") + "[/b][/p]"
	var bs_texte: String = "[p]" + tr("O41_O2_DESCRIPTION") + "[/p]"
	var aide_bs: String = bs + bs_texte
	var pdc: String = "[p][b]" + tr("O3_PDC") + "[/b][/p]"
	var pdc_texte: String = "[p]" + tr("O41_O3_DESCRIPTION") + "[/p]"
	var aide_pdc: String = pdc + pdc_texte
	var texte_son: String = tr("O41_REWARD_COUPER") if son else tr("O41_REWARD_JOUER")
	var recompense: String = "[p]" + tr("O41_REWARD_DEBUT") + texte_son + tr("O41_REWARD_FIN")
	%Aide.text = important + "[p] [/p]" + sauvegardes + "[p] [/p]" + aide_classe + "[p] [/p]" + aide_bs + "[p] [/p]" + aide_pdc + "[p] [/p]" + recompense

func _a_propos() -> void:
	var presentation: String = "[p][b]" + tr("TITRE") + "[/b]" + tr("O42_PRESENTATION") + "[/p]"
	var auteur: String = "[p][b]" + tr("TITRE") + "[/b]" + tr("O42_AUTEUR") + "[/p]"
	var inspiration: String = "[p]" + tr("O43_INSPIRATION") + "[/p]"
	var licence: String = "[p] [/p][p]" + tr("O44_LICENCE") + "[/p]"
	var petit_texte: String = str(get_theme_font_size("StringName") - 4)
	%APropos.text = presentation + auteur + inspiration + "[font_size=" + petit_texte + "]" + licence + "[/font_size]"


func _on_a_propos_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))


func _on_aide_meta_clicked(meta: Variant) -> void:
	if str(meta).contains("~/.local/") and OS.get_name() == "Linux":
		OS.shell_open(OS.get_data_dir() + "/Clan de place")
	elif str(meta).contains("%APPDATA%") and OS.get_name() == "Windows":
		OS.shell_open(OS.get_data_dir() + "\\Clan de place")
	elif str(meta).contains("bruitages") or str(meta).contains("sound"):
		couper_son.emit()
		son = not son
		_aide()
		
		
func _on_francais_pressed() -> void:
	TranslationServer.set_locale("fr")
	_maj_textes()

func _on_english_pressed() -> void:
	TranslationServer.set_locale("en")
	_maj_textes()
