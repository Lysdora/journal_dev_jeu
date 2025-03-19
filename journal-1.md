# Journal de bord 1 - Système d'items dans Godot

## Objectif initial
Je voulais implémenter un système d'items dans mon jeu en pixel art, similaire aux scriptable objects de Unity. L'idée était d'avoir un système flexible pour gérer différents types d'objets : consommables, équipements et items de quête.

## Première approche : Avec Resources

J'ai d'abord essayé d'utiliser le système de Resources de Godot, qui semblait être l'équivalent des scriptable objects d'Unity.

### Structure de la Resource Item
```gdscript
class_name Item
extends Resource

# Type d'item (enum)
enum ItemType {
    CONSUMABLE,
    QUEST,
    EQUIPMENT
}

# Propriétés de base
@export var item_name: String
@export var item_description: String
@export var item_texture: Texture2D
@export var item_price: int
@export var item_weight: int
@export var item_type: ItemType

# Propriétés spécifiques selon le type
@export_group("Consumable Properties")
@export var health_restore: int = 0
@export var mana_restore: int = 0
@export var use_effect: String = ""

@export_group("Equipment Properties")
@export var defense_bonus: int = 0
@export var attack_bonus: int = 0
@export var equipment_slot: String = ""

@export_group("Quest Properties")
@export var quest_id: String = ""
@export var is_quest_objective: bool = false

@export_group("Item Rotation")
@export var item_rotation_angle: float = 0.0
@export_group("Direction Flip")
@export var flip_horizontally: bool = false
@export var flip_vertically: bool = false
```

### Gestionnaire d'inventaire (Global.gd)
```gdscript
extends Node

var inventory = []

func add_item(item_resource):
    inventory.append(item_resource)
    print("Item ajouté : " + item_resource.item_name)
    
func remove_item(item_index):
    if item_index >= 0 and item_index < inventory.size():
        var item = inventory[item_index]
        inventory.remove_at(item_index)
        print("Item supprimé : " + item.item_name)
        return item
    return null
    
func use_item(item_index):
    var item = inventory[item_index]
    
    match item.item_type:
        0: # CONSUMABLE
            print("Utilisation de " + item.item_name)
            # Appliquer les effets (health_restore, etc.)
            remove_item(item_index)
        1: # QUEST
            print("Ceci est un item de quête")
        2: # EQUIPMENT
            print("Équipement de " + item.item_name)
            # Logique d'équipement
```

### Script de collectible
```gdscript
extends Area2D

@export var item_resource: Resource

func _ready() -> void:
    if item_resource:
        $Sprite2D.texture = item_resource.item_texture

func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("player"):
        # Donne l'item au player
        if body.has_method("collect_item"):
            Global.add_item(item_resource)
        queue_free()
```

## Les difficultés rencontrées

J'ai rencontré plusieurs problèmes avec cette approche :

1. **Erreurs de référence** : "Invalid access to property or key 'item_name' on a base object of type 'nil'"
2. **Problèmes de typage** : Godot ne reconnaissait pas toujours mes Resources comme étant de type Item
3. **Configuration complexe** : Beaucoup d'étapes pour créer et configurer chaque item
4. **Difficultés à déboguer** : Messages d'erreur pas toujours clairs

Après plusieurs tentatives, j'ai réalisé que cette approche était peut-être trop complexe pour le stade où j'en suis dans mon apprentissage de Godot.

## Solution simplifiée : Dictionnaire d'items

J'ai finalement opté pour une méthode plus directe en utilisant un simple dictionnaire dans un script global :

### Global.gd simplifié
```gdscript
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
```

### Script de collectible simplifié
```gdscript
extends Area2D

# ID de l'item (correspondant à une clé dans le dictionnaire Global.items)
@export var item_id = "potion_sante"

func _ready():
    # Connecter le signal body_entered
    body_entered.connect(_on_body_entered)

func _on_body_entered(body):
    if body.is_in_group("player"):
        # Ajouter l'item à l'inventaire
        Global.ajouter_item(item_id)
        # Supprimer l'objet de la scène
        queue_free()
```

## Pourquoi j'ai changé d'approche

J'ai opté pour cette solution plus simple car :

1. **Plus facile à comprendre** : La structure est plus directe et intuitive
2. **Moins d'erreurs** : Moins de risques d'erreurs de typage ou de référence
3. **Rapidité de développement** : Je peux ajouter de nouveaux items très rapidement
4. **Débogage plus simple** : Les problèmes sont plus faciles à identifier et corriger

Cette approche me permet de me concentrer sur le gameplay et les mécaniques de mon jeu en pixel art plutôt que de me battre avec des concepts techniques avancés.

## Prochaines étapes

Maintenant que j'ai un système d'items fonctionnel, je vais pouvoir :
- Créer une interface d'inventaire
- Implémenter les effets des différents items
- Ajouter des mécaniques de quête liées aux items

Je reviendrai peut-être au système de Resources plus tard, quand je serai plus à l'aise avec Godot et ses fonctionnalités avancées.

## Enseignements

Cette expérience m'a appris qu'il est parfois préférable de commencer simple et d'itérer progressivement, plutôt que de vouloir implémenter directement un système complexe. Connaître les limites de ses connaissances actuelles et choisir des solutions adaptées à son niveau peut faire gagner beaucoup de temps et éviter des frustrations inutiles.
