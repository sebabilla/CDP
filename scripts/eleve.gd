## Sous ressource manipulée par gestion.gd. Coeur du programme.
## Voir section.gd pour voir son parent.
extends Resource
class_name Eleve

@export var nom: String
@export var pos: Vector2 = Vector2.ZERO
@export var positifs: Array[String] = []
@export var negatifs: Array[String] = []
