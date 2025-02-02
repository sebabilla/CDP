# Ce script sert à cacher la simulation pour que les indélicats ne puissent pas la montrer aux élèves.
# Le charabia type Evangelion sert juste à occuper l'utilisateur.
extends ColorRect

func _ready() -> void:
	Noeuds.info_carto = self
	initialiser()
	hide()	

## Paramètres initiaux de l'écran de simulation
func initialiser() -> void:
	%EtatActuel.value = 100
	%EtatMeilleur.value = 100
	maj_etats(100, 100)
	%EtatActuel.indeterminate = true
	%EtatMeilleur.indeterminate = true
	%Recherche.text = tr("S3_INITIALISATION")

## Actualise l'écran de la simulation avec la vitesse moyenne (actuelle) et la 
## vitesse la plus basse (meilleur) trouvées
func maj_etats(actuel: float, meilleur: float) -> void:
	%EtatActuel.indeterminate = false
	%EtatMeilleur.indeterminate = false
	%EtatActuel.value = actuel
	%EtatMeilleur.value = meilleur
	%Recherche.text = tr("S3_EN_COURS") if meilleur >= 15 else tr("S3_PRESQUE")
	
