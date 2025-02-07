extends Node

func nouvelle_array_int(taille: int, valeur: int = 0) -> Array[int]:
	var nouvelle: Array[int]
	nouvelle.resize(taille)
	nouvelle.fill(valeur)
	return nouvelle

func nouvelle_array_float(taille: int, valeur: float = 0.0) -> Array[float]:
	var nouvelle: Array[float]
	nouvelle.resize(taille)
	nouvelle.fill(valeur)
	return nouvelle
	
func nouvelle_array_vector2(taille: int, valeur: Vector2 = Vector2.ZERO) -> Array[Vector2]:
	var nouvelle: Array[Vector2]
	nouvelle.resize(taille)
	nouvelle.fill(valeur)
	return nouvelle
	
		
