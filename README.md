# 🚀 Termux GitHub Environment

Boîte à outils GitHub complète pour **Termux** — upload, téléchargement, clone, push, liste et suppression de dépôts directement depuis votre terminal Android.

---

## ⚡ Installation

Copiez et collez cette commande dans Termux :

```bash
bash <(curl -sL https://raw.githubusercontent.com/walidrbh2000-maker/git/main/setup.sh)
```

> **Pourquoi `bash <(...)` et non `curl ... | bash` ?**
> Le script pose des questions interactives (`read`). Avec le pipe `|`, le terminal ne peut pas lire vos réponses — d'où l'erreur. La syntaxe `bash <(...)` conserve l'accès au terminal.

---

## 🛠️ Commandes disponibles

| Commande | Description |
|---|---|
| `gitup` | Uploader un dossier ou fichier vers GitHub (Public 🌐 ou Privé 🔐) |
| `gitget` | Télécharger un dépôt en ZIP 📦 ou le cloner avec Git 🔄 |
| `gitlist` | Afficher tous vos dépôts avec filtre Public / Privé / Tous |
| `gitpush` | Pousser les modifications d'un dépôt cloné vers GitHub |
| `gitdel` | Supprimer un dépôt définitivement (double confirmation) |
| `cspace` | Créer ou rejoindre un GitHub Codespace ☁️ |
| `githelp` | Afficher le menu d'aide complet |

---

## 📋 Prérequis

- [Termux](https://f-droid.org/packages/com.termux/) installé
- Un compte GitHub
- Un **Token d'accès classique** GitHub avec les permissions : `repo`, `delete_repo`, `codespace`

> Pour créer un token : **GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)**

---

## 🔄 Cycle de travail typique

```bash
gitlist          # Voir tous vos dépôts
gitget           # Cloner un dépôt (mode 2)
# ... modifiez vos fichiers ...
gitpush          # Pousser les modifications
```

---

## 📌 Commandes GitHub utiles

```bash
gh codespace delete   # Supprimer un serveur Codespace
exit                  # Quitter un serveur Codespace
```
