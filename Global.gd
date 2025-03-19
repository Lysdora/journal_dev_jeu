# Global.gd
extends Node

# Dictionnaire simple d'items
var items = {
	"potion_sante": {
		"nom": "Potion de santé",
		"description": "Restaure 20 points de vie",
		"effet": "soigner",
		"valeur": 20
	},
	"epee": {
		"nom": "Épée courte",
		"description": "Une épée simple mais efficace",
		"effet": "attaque",
		"valeur": 5
	},
	"cle": {
		"nom": "Clé rouillée",
		"description": "Ouvre une porte quelque part",
		"effet": "quete",
		"valeur": 0
	}
}

# Inventaire du joueur (simple tableau)
var inventaire = []

# Fonction pour ajouter un item à l'inventaire
func ajouter_item(item_id):
	if items.has(item_id):
		inventaire.append(item_id)
		print("Item ajouté : " + items[item_id].nom)
	else:
		print("Item inconnu")
