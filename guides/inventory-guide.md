# Système d'inventaire dans Godot Engine 4.x

*Notes personnelles sur l'implémentation d'un système d'inventaire complet.*

## Table des matières

- [Gestionnaire global](#gestionnaire-global)
- [Interface utilisateur](#interface-utilisateur)
- [Slots d'inventaire](#slots-dinventaire)
- [Items ramassables](#items-ramassables)
- [Intégration](#intégration)
- [Astuces et solutions](#astuces-et-solutions)

## Gestionnaire global

### Structure de Global.gd

```gdscript
extends Node

# Signal émis quand l'inventaire est modifié
signal inventaire_modifie

# Dictionnaire des types d'items disponibles dans le jeu
var items = {
	"potion_sante": {
		"nom": "Potion de santé",
		"description": "Restaure 20 points de vie",
		"effet": "soigner",
		"valeur": 20,
		"icone": "res://assets/icons/potion_sante.png"
	},
	"epee": {
		"nom": "Épée courte",
		"description": "Une épée simple mais efficace",
		"effet": "attaque",
		"valeur": 5,
		"icone": "res://assets/icons/epee.png"
	},
	"cle": {
		"nom": "Clé rouillée",
		"description": "Ouvre une porte quelque part",
		"effet": "quete",
		"valeur": 0,
		"icone": "res://assets/icons/cle.png"
	}
}

# Inventaire avec quantités
var inventaire = {}

# Ajouter un item à l'inventaire
func ajouter_item(item_id, quantite = 1):
	if items.has(item_id):
		if inventaire.has(item_id):
			inventaire[item_id] += quantite
		else:
			inventaire[item_id] = quantite
		
		print("Item ajouté : " + items[item_id].nom + " (Total: " + str(inventaire[item_id]) + ")")
		emit_signal("inventaire_modifie")
	else:
		print("Item inconnu")

# Supprimer un item de l'inventaire
func supprimer_item(item_id, quantite = 1):
	if inventaire.has(item_id):
		inventaire[item_id] -= quantite
		
		if inventaire[item_id] <= 0:
			# Supprimer complètement l'entrée si quantité <= 0
			inventaire.erase(item_id)
		
		print("Item supprimé : " + items[item_id].nom)
		emit_signal("inventaire_modifie")

# Obtenir la quantité d'un item spécifique
func compter_item(item_id):
	return inventaire.get(item_id, 0)

# Vérifier si l'item existe dans l'inventaire
func possede_item(item_id, quantite = 1):
	return inventaire.has(item_id) and inventaire[item_id] >= quantite
```

## Interface utilisateur

### Mes notes sur la création de l'interface d'inventaire

1. **Créer la scène de base**
   - Inventory_UI → Control
   - En child : NinePatchRect
   - Pour la texture background de l'inventaire

2. **Explications sur NinePatchRect**
   - Si on l'agrandit c'est mode, il faut aller dans Patch Margin
   - Mettre des valeurs dans Left, Top, Right, Bottom
   - Dans mon exemple c'est 6px sur les 4 côtés

3. **Configuration du GridContainer**
   - Retourner dans Inventory_UI
   - Ajouter à NinePatchRect en child Grid Container
   - Inspector: 4 Columns, Layout Mode: Anchors
   - Anchors Preset: Center
   - On peut maintenant instancier 12 slots dans Grid Container

### Script Inventory_UI.gd

```gdscript
extends Control

@onready var grid_container = $NinePatchRect/GridContainer
var slot_scene = preload("res://inventory/ui/inventory_ui_slot.tscn")
@export var max_slots = 12

func _ready():
	# Connecter le signal d'inventaire
	Global.connect("inventaire_modifie", Callable(self, "_on_inventaire_modifie"))
	
	# Initialiser les slots
	initialiser_slots()
	
	# Mettre à jour l'affichage initial
	_on_inventaire_modifie()
	
	# Cacher l'inventaire au démarrage
	visible = false

# Input pour ouvrir/fermer l'inventaire
func _input(event):
	if event.is_action_pressed("ui_inventory"):  # Définir cette action dans Project Settings
		visible = !visible

# Initialiser les slots vides
func initialiser_slots():
	for child in grid_container.get_children():
		child.queue_free()
	
	for i in range(max_slots):
		var slot = slot_scene.instantiate()
		grid_container.add_child(slot)
		
		# Connecter les signaux
		slot.connect("slot_selectionne", Callable(self, "_on_slot_selectionne"))

# Mettre à jour l'affichage de l'inventaire
func _on_inventaire_modifie():
	# Réinitialiser tous les slots
	for slot in grid_container.get_children():
		slot.effacer_item()
	
	# Remplir les slots avec les items de l'inventaire
	var slot_index = 0
	for item_id in Global.inventaire:
		if slot_index < max_slots:
			var quantite = Global.inventaire[item_id]
			grid_container.get_child(slot_index).definir_item(item_id, quantite)
			slot_index += 1

# Gérer la sélection d'un slot
func _on_slot_selectionne(slot):
	var item_id = slot.item_id
	if item_id and Global.items.has(item_id):
		var item_info = Global.items[item_id]
		
		match item_info.effet:
			"soigner":
				print("Utilisation d'une potion de santé")
				# Ajouter la logique de soin
				Global.supprimer_item(item_id)
			"attaque":
				print("Équiper l'épée")
				# Ajouter la logique d'équipement
			"quete":
				print("Item de quête")
				# Ajouter la logique spécifique à la quête
```

## Slots d'inventaire

### Mes notes sur la création des slots

1. **Pour la scène des slots**
   - inventory_ui_slot de type Panel
   - En child ajouter un Sprite2D qui va être le background du slot
   - Trouver une asset qui correspond au slot
   - Ajouter une Texture

2. **Configuration des propriétés**
   - Aller dans Inspector offset, désactiver Centered
   - Cliquer sur le Node parent, on ne veut pas de la couleur de base du panel
   - Aller dans Visibility, Self Modulate et rendre complètement transparent
   - Puis aller dans Layout, copier/coller les valeurs de Transform Size et les coller dans Custom Minimum Size

3. **Finalisation de la structure**
   - Sauver la scène
   - Retourner dans la scène des slots
   - Ajouter au-dessus du root node un CenterContainer
   - Ajouter en enfant du CenterContainer un Panel
   - En enfant du Panel, ajouter un Sprite2D qui est le item_display
   - Mettre le CenterContainer à la même taille que les autres éléments
   - Aller dans Layout et copier/coller les valeurs de Transform Size dans Custom Min Size
   - Toujours sur le Node parent, copier/coller les valeurs de Transform dans Custom Min Size

### Script Inventory_UI_Slot.gd

```gdscript
extends Panel

@onready var icone = $CenterContainer/Panel/item_display
@onready var label_quantite = $CenterContainer/Panel/Label_Quantite

var item_id = null

signal slot_selectionne(slot)

func _ready():
	# Connecter le signal d'input
	connect("gui_input", Callable(self, "_on_gui_input"))

# Définir l'item dans ce slot
func definir_item(nouvel_item_id, quantite = 1):
	item_id = nouvel_item_id
	
	if Global.items.has(item_id):
		var item_info = Global.items[item_id]
		
		# Charger l'icône
		if ResourceLoader.exists(item_info.icone):
			icone.texture = load(item_info.icone)
		else:
			# Utiliser une icône par défaut si le fichier n'existe pas
			icone.texture = null
			print("ATTENTION: Icône manquante pour " + item_id)
		
		# Mettre à jour le compteur de quantité
		if label_quantite:
			label_quantite.text = str(quantite) if quantite > 1 else ""
	else:
		print("ERREUR: Item inconnu " + str(nouvel_item_id))
		effacer_item()

# Effacer l'item de ce slot
func effacer_item():
	item_id = null
	icone.texture = null
	if label_quantite:
		label_quantite.text = ""

# Traiter l'input utilisateur
func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if item_id:
			emit_signal("slot_selectionne", self)
			
			# Afficher les infos dans la console
			if Global.items.has(item_id):
				var item_info = Global.items[item_id]
				print("Item sélectionné : " + item_info.nom)
				print("Description : " + item_info.description)
```

## Items ramassables

### Script Item.gd

```gdscript
extends Area2D

@export var item_id = "potion_sante"

func _ready():
	# Configurer le sprite si possible
	if $Sprite2D and Global.items.has(item_id) and ResourceLoader.exists(Global.items[item_id].icone):
		$Sprite2D.texture = load(Global.items[item_id].icone)

func _on_body_entered(body):
	if body.is_in_group("player"):
		Global.ajouter_item(item_id)
		queue_free()
```

## Intégration

### Mes notes sur l'intégration

1. **Intégrer avec le joueur**
   - Sauver la scène
   - Aller dans la scène player, instancier l'inventaire
   - Le mettre au-dessus du player
   - Ajouter le joueur au groupe "player"
   ```gdscript
   # Dans le script du joueur
   func _ready():
       add_to_group("player")
   ```

2. **Pour la visibilité et l'activation**
   - Dans le script du joueur, ajouter:
   ```gdscript
   func _input(event):
       if event.is_action_pressed("ui_inventory"):  # "I" par exemple
           $Inventory_UI.visible = !$Inventory_UI.visible
   ```

## Astuces et solutions

### Problèmes courants que j'ai rencontrés

1. **Les items ne s'empilent pas correctement**
   - Vérifier que la fonction `_on_inventaire_modifie()` parcourt bien le dictionnaire `Global.inventaire`
   - S'assurer que la variable `label_quantite` est correctement référencée
   - Utiliser `label_quantite.text = str(quantite) if quantite > 1 else ""`

2. **L'interface ne s'affiche pas au bon endroit**
   - Vérifier les propriétés d'ancrage et de mode de mise en page
   - Assurer que le GridContainer a un Anchor Preset à "Center"
   - Copier/coller les valeurs de Transform Size dans Custom Min Size

3. **Les icônes ne se chargent pas**
   - Vérifier que les chemins d'accès aux icônes sont corrects
   - S'assurer que `ResourceLoader.exists(item_info.icone)` renvoie true
   - Ajouter des prints de débogage pour vérifier les chemins

4. **Le signal inventaire_modifie n'est pas émis**
   - Ne pas oublier de déclarer le signal en haut du script Global.gd:
   ```gdscript
   signal inventaire_modifie
   ```

5. **Les slots ne sont pas visibles quand ils sont vides**
   - Ne pas mettre `visible = false` dans la fonction `effacer_item()`
   - Garder les slots visibles, juste vider leur contenu

**Rappel**: N'oubliez pas de définir l'action "ui_inventory" dans Project Settings > Input Map pour permettre l'ouverture/fermeture de l'inventaire.
