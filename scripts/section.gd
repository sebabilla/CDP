## La ressource manipulée par gestion.gd. Coeur du programme.
## Voir eleve.gd pour le classe Eleve.
extends Resource
class_name  Section

@export var classe: String = ""
@export var question: String = ""
@export var eleves: Array[Eleve] = []
