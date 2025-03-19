# Mémo GitHub et Markdown

Ce guide rapide contient les commandes essentielles pour utiliser GitHub et la syntaxe Markdown.

## Sommaire
- [Commandes Git de base](#commandes-git-de-base)
- [Opérations GitHub via l'interface web](#opérations-github-via-linterface-web)
- [Syntaxe Markdown](#syntaxe-markdown)
- [Astuces avancées](#astuces-avancées)

## Commandes Git de base

### Initialisation et configuration
```bash
# Initialiser un nouveau dépôt
git init

# Configurer votre identité
git config --global user.name "Votre Nom"
git config --global user.email "votre.email@exemple.com"

# Cloner un dépôt existant
git clone https://github.com/utilisateur/nom-du-depot.git
```

### Commit et push
```bash
# Vérifier l'état des fichiers
git status

# Ajouter des fichiers à l'index
git add nom-du-fichier     # Ajouter un fichier spécifique
git add .                  # Ajouter tous les fichiers modifiés

# Créer un commit avec un message
git commit -m "Description des changements"

# Pousser les changements vers GitHub
git push origin main       # Remplacer 'main' par votre branche
```

### Branches
```bash
# Créer une nouvelle branche
git branch nom-de-la-branche

# Changer de branche
git checkout nom-de-la-branche

# Créer et passer sur une nouvelle branche (raccourci)
git checkout -b nom-de-la-branche

# Fusionner une branche dans la branche actuelle
git merge nom-de-la-branche

# Supprimer une branche locale
git branch -d nom-de-la-branche
```

### Mise à jour
```bash
# Récupérer les derniers changements sans fusionner
git fetch origin

# Récupérer et fusionner les derniers changements
git pull origin main       # Remplacer 'main' par votre branche
```

## Opérations GitHub via l'interface web

### Créer un nouveau dépôt
1. Cliquez sur "+" en haut à droite, puis "New repository"
2. Remplissez le nom et la description
3. Choisissez la visibilité (public/privé)
4. Cochez "Initialize this repository with a README" si vous partez de zéro
5. Cliquez sur "Create repository"

### Créer un dossier dans GitHub
L'interface GitHub ne permet pas de créer directement un dossier vide. Pour créer un dossier:

1. Cliquez sur "Add file" puis "Create new file"
2. Dans le champ du nom de fichier, tapez `nom-du-dossier/README.md`
3. Ajoutez du contenu au fichier README
4. Cliquez sur "Commit new file"

Le dossier sera créé automatiquement avec le fichier README.md à l'intérieur.

### Télécharger des fichiers
1. Naviguez vers le dossier souhaité dans votre dépôt
2. Cliquez sur "Add file" puis "Upload files"
3. Glissez-déposez vos fichiers ou utilisez le sélecteur de fichiers
4. Ajoutez un message de commit
5. Cliquez sur "Commit changes"

### Éditer un fichier
1. Naviguez vers le fichier que vous souhaitez modifier
2. Cliquez sur l'icône en forme de crayon (Edit)
3. Effectuez vos modifications
4. Ajoutez un message de commit
5. Cliquez sur "Commit changes"

### Supprimer un fichier ou dossier
1. Naviguez vers le fichier à supprimer
2. Cliquez sur l'icône en forme de corbeille (Delete)
3. Ajoutez un message de commit
4. Cliquez sur "Commit changes"

Pour supprimer un dossier entier, vous devrez soit utiliser Git en ligne de commande, soit supprimer chaque fichier individuellement via l'interface web.

## Syntaxe Markdown

### Titres
```markdown
# Titre de niveau 1
## Titre de niveau 2
### Titre de niveau 3
#### Titre de niveau 4
##### Titre de niveau 5
###### Titre de niveau 6
```

### Formatage de texte
```markdown
*Texte en italique* ou _Texte en italique_
**Texte en gras** ou __Texte en gras__
***Texte en gras et italique***
~~Texte barré~~
```

Résultat:
*Texte en italique* ou _Texte en italique_
**Texte en gras** ou __Texte en gras__
***Texte en gras et italique***
~~Texte barré~~

### Listes
```markdown
# Liste non ordonnée
- Élément 1
- Élément 2
  - Sous-élément 2.1
  - Sous-élément 2.2

# Liste ordonnée
1. Premier élément
2. Deuxième élément
   1. Sous-élément 2.1
   2. Sous-élément 2.2
```

### Liens
```markdown
[Texte du lien](https://www.exemple.com)
[Lien vers un fichier local](chemin/vers/fichier.md)
[Lien vers une section](#titre-de-la-section)

# Liens référencés
[Nom du lien][reference]
[reference]: https://www.exemple.com
```

### Images
```markdown
![Texte alternatif](url-de-l-image.jpg)
![Logo](images/logo.png "Titre de l'image au survol")

# Images avec référence
![Texte alternatif][id]
[id]: url-de-l-image.jpg "Titre optionnel"
```

### Blocs de code
```markdown
`Code inline`

# Bloc de code simple
```
Votre code ici
```

# Bloc de code avec coloration syntaxique
```python
def hello_world():
    print("Hello, world!")
```
```

### Citations
```markdown
> Ceci est une citation.
> 
> > Citation imbriquée.
```

Résultat:
> Ceci est une citation.
> 
> > Citation imbriquée.

### Tableaux
```markdown
| En-tête 1 | En-tête 2 | En-tête 3 |
|-----------|-----------|-----------|
| Cellule 1 | Cellule 2 | Cellule 3 |
| Cellule 4 | Cellule 5 | Cellule 6 |

# Alignement des colonnes
| Gauche | Centre | Droite |
|:-------|:------:|-------:|
| Texte  | Texte  | Texte  |
```

### Ligne horizontale
```markdown
---
***
___
```

### Vidéos

GitHub Markdown ne prend pas directement en charge l'intégration de vidéos, mais vous pouvez:

1. **Utiliser une image cliquable qui redirige vers la vidéo**:
```markdown
[![Texte alternatif](https://img.youtube.com/vi/ID_VIDEO/0.jpg)](https://www.youtube.com/watch?v=ID_VIDEO)
```

2. **Pour les pages GitHub Pages**, vous pouvez utiliser du HTML:
```html
<iframe width="560" height="315" src="https://www.youtube.com/embed/ID_VIDEO" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
```

## Astuces avancées

### Ancres pour les sections
Les titres en Markdown génèrent automatiquement des ancres que vous pouvez utiliser pour des liens internes.

Pour un titre comme `## Ma Section`, l'ancre sera `#ma-section` (tout en minuscules, espaces remplacés par des tirets).

```markdown
[Lien vers Ma Section](#ma-section)
```

### Listes de tâches
```markdown
- [x] Tâche complétée
- [ ] Tâche à faire
- [ ] Encore une tâche
```

Résultat:
- [x] Tâche complétée
- [ ] Tâche à faire
- [ ] Encore une tâche

### Notes de bas de page
```markdown
Voici un texte avec une note de bas de page[^1].

[^1]: Contenu de la note de bas de page.
```

### Tables des matières automatiques
GitHub génère automatiquement une table des matières pour les fichiers README.md et les wikis à partir des titres. Vous pouvez y accéder en cliquant sur l'icône de menu (trois lignes horizontales) en haut à gauche du contenu du fichier.

Pour les pages GitHub Pages, vous pouvez créer un sommaire manuellement avec des liens vers les différentes sections:

```markdown
## Sommaire
- [Introduction](#introduction)
- [Installation](#installation)
- [Utilisation](#utilisation)
```

### Utiliser des emoji
GitHub prend en charge les emoji dans Markdown:

```markdown
:smile: :heart: :rocket: :octocat:
```

Résultat: 😄 ❤️ 🚀 🐙

[Liste complète des emoji GitHub](https://github.com/ikatyang/emoji-cheat-sheet/blob/master/README.md)

---

J'espère que ce mémo vous sera utile! N'hésitez pas à le personnaliser selon vos besoins.
