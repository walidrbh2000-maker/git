#!/bin/bash

clear

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
BOLD='\033[1m'
RESET='\033[0m'

CONFIG_FILE="$HOME/.github_config"
ACCOUNTS_FILE="$HOME/.github_accounts"

print_banner() {
    printf "\n"
    printf "${CYAN}${BOLD}╔══════════════════════════════════════════════════════════╗${RESET}\n"
    printf "${CYAN}${BOLD}║${RESET}${WHITE}${BOLD}   ██████╗ ██╗████████╗██╗  ██╗██╗   ██╗██████╗           ${RESET}${CYAN}${BOLD}║${RESET}\n"
    printf "${CYAN}${BOLD}║${RESET}${WHITE}${BOLD}  ██╔════╝ ██║╚══██╔══╝██║  ██║██║   ██║██╔══██╗          ${RESET}${CYAN}${BOLD}║${RESET}\n"
    printf "${CYAN}${BOLD}║${RESET}${WHITE}${BOLD}  ██║  ███╗██║   ██║   ███████║██║   ██║██████╔╝          ${RESET}${CYAN}${BOLD}║${RESET}\n"
    printf "${CYAN}${BOLD}║${RESET}${WHITE}${BOLD}  ██║   ██║██║   ██║   ██╔══██║██║   ██║██╔══██╗          ${RESET}${CYAN}${BOLD}║${RESET}\n"
    printf "${CYAN}${BOLD}║${RESET}${WHITE}${BOLD}  ╚██████╔╝██║   ██║   ██║  ██║╚██████╔╝██████╔╝          ${RESET}${CYAN}${BOLD}║${RESET}\n"
    printf "${CYAN}${BOLD}║${RESET}${WHITE}${BOLD}   ╚═════╝ ╚═╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═════╝           ${RESET}${CYAN}${BOLD}║${RESET}\n"
    printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
    printf "${CYAN}${BOLD}║${RESET}  ${GREEN}${BOLD}🚀  INSTALLATION DE L'ENVIRONNEMENT GITHUB  🚀${RESET}          ${CYAN}${BOLD}║${RESET}\n"
    printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}   Outils : gitup · gitget · gitlist · gitpush        ${RESET}  ${CYAN}${BOLD}║${RESET}\n"
    printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}      gitdel · cspace · gitswitch · gituninstall      ${RESET}  ${CYAN}${BOLD}║${RESET}\n"
    printf "${CYAN}${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}\n"
    printf "\n"
}

print_step()    { printf "${BLUE}${BOLD}[•]${RESET} ${WHITE}$1${RESET}\n"; }
print_success() { printf "${GREEN}${BOLD}[✓]${RESET} ${GREEN}$1${RESET}\n"; }
print_error()   { printf "${RED}${BOLD}[✗]${RESET} ${RED}$1${RESET}\n"; }

print_banner

# ══════════════════════════════════════════════════════════
#  ÉTAPE 1 — Saisie des informations utilisateur
# ══════════════════════════════════════════════════════════

printf "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
printf "${YELLOW}${BOLD}  📋  Informations de connexion GitHub${RESET}\n"
printf "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n\n"

read -p "$(printf "${CYAN}${BOLD}  👤  Nom d'utilisateur GitHub  : ${RESET}")" USERNAME
read -p "$(printf "${CYAN}${BOLD}  📧  Adresse e-mail GitHub     : ${RESET}")" EMAIL
read -p "$(printf "${CYAN}${BOLD}  🔑  Token d'accès (Classic)   : ${RESET}")" TOKEN
read -p "$(printf "${CYAN}${BOLD}  🏷️   Label du compte (ex: Perso, Pro) : ${RESET}")" LABEL
LABEL=${LABEL:-$USERNAME}
printf "\n"

# ══════════════════════════════════════════════════════════
#  ÉTAPE 2 — Sauvegarde de la configuration partagée
# ══════════════════════════════════════════════════════════

print_step "Sauvegarde des credentials dans ~/.github_config..."

cat > "$CONFIG_FILE" << CONFEOF
USERNAME="$USERNAME"
EMAIL="$EMAIL"
TOKEN="$TOKEN"
CONFEOF
chmod 600 "$CONFIG_FILE"

# Ajouter le compte dans ~/.github_accounts si pas déjà présent
touch "$ACCOUNTS_FILE"
if ! grep -q "^$USERNAME|" "$ACCOUNTS_FILE" 2>/dev/null; then
    echo "$USERNAME|$EMAIL|$TOKEN|$LABEL" >> "$ACCOUNTS_FILE"
fi
chmod 600 "$ACCOUNTS_FILE"
print_success "Configuration sauvegardée."
printf "\n"

# ══════════════════════════════════════════════════════════
#  ÉTAPE 3 — Installation des paquets
# ══════════════════════════════════════════════════════════

printf "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
printf "${YELLOW}${BOLD}  📦  Installation des dépendances${RESET}\n"
printf "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n\n"

print_step "Mise à jour des paquets Termux..."
pkg update -y && pkg upgrade -y > /dev/null 2>&1

print_step "Installation de git, gh, openssh, zip, python3..."
pkg install git gh openssh zip python3 -y > /dev/null 2>&1
print_success "Dépendances installées avec succès."
printf "\n"

# ══════════════════════════════════════════════════════════
#  ÉTAPE 4 — Authentification GitHub
# ══════════════════════════════════════════════════════════

print_step "Connexion à GitHub avec votre token..."
echo "$TOKEN" | gh auth login --with-token
print_success "Authentification réussie."
printf "\n"

# ══════════════════════════════════════════════════════════
#  ÉTAPE 5 — Création des outils personnalisés
# ══════════════════════════════════════════════════════════

printf "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
printf "${YELLOW}${BOLD}  🛠️   Création des outils personnalisés${RESET}\n"
printf "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n\n"

# ─────────────────────────────────────────────
#  gitup
# ─────────────────────────────────────────────
print_step "Création de la commande 'gitup'..."

cat << 'EOF' > $PREFIX/bin/gitup
#!/bin/bash

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; BOLD='\033[1m'; RESET='\033[0m'

source "$HOME/.github_config" || { printf "${RED}  ❌  Config introuvable. Lancez gitswitch ou réinstallez.${RESET}\n"; exit 1; }

BASE_DIR="/storage/emulated/0"

printf "\n${CYAN}${BOLD}╔══════════════════════════════════════════════╗${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}📤  GITHUB UPLOADER — Mode Intelligent${RESET}       ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╚══════════════════════════════════════════════╝${RESET}\n\n"
printf "${CYAN}  👤  Compte actif : ${BOLD}$USERNAME${RESET}\n\n"

while true; do
    read -p "$(printf "${CYAN}${BOLD}  📂  Dossier ou fichier à uploader : ${RESET}")" USER_PATH
    [ -z "$USER_PATH" ] && printf "${YELLOW}  ⚠️   Le nom ne peut pas être vide.${RESET}\n" && continue
    FULL_TARGET="$BASE_DIR/$USER_PATH"
    [ -e "$FULL_TARGET" ] && break
    printf "${RED}  ⚠️   Introuvable : '$FULL_TARGET' n'existe pas.${RESET}\n"
done

TARGET_NAME=$(basename "$FULL_TARGET")
TERMUX_PATH="$HOME/${TARGET_NAME}_github"

read -p "$(printf "${CYAN}${BOLD}  🏷️   Nom du dépôt (vide = '$TARGET_NAME') : ${RESET}")" REPO_NAME
REPO_NAME=${REPO_NAME:-$TARGET_NAME}

printf "\n${YELLOW}  🔍  Vérification du dépôt '$REPO_NAME' sur GitHub...${RESET}\n"
HTTP_CHECK=$(curl -s -o /dev/null -w "%{http_code}" \
    -H "Authorization: token $TOKEN" \
    "https://api.github.com/repos/$USERNAME/$REPO_NAME")

if [ "$HTTP_CHECK" != "200" ]; then
    printf "${YELLOW}  ⚠️   Le dépôt '$REPO_NAME' n'existe pas encore.${RESET}\n"
    read -p "$(printf "${CYAN}${BOLD}  ❓  Créer le dépôt maintenant ? (o/n) : ${RESET}")" CREATE_REPO
    [[ "$CREATE_REPO" != "o" && "$CREATE_REPO" != "O" ]] && printf "${RED}  🛑  Opération annulée.${RESET}\n\n" && exit 1

    printf "\n${YELLOW}${BOLD}  🔒  Visibilité du dépôt :${RESET}\n"
    printf "      ${GREEN}1)  🌐  Public  — Visible par tous${RESET}\n"
    printf "      ${YELLOW}2)  🔐  Privé   — Visible par vous uniquement${RESET}\n"
    read -p "$(printf "${CYAN}${BOLD}  👉  Votre choix (1 ou 2) : ${RESET}")" VISIBILITY_CHOICE

    if [ "$VISIBILITY_CHOICE" == "2" ]; then
        JSON_PAYLOAD="{\"name\":\"$REPO_NAME\", \"private\":true}"; VIS_TEXT="Privé 🔐"
    else
        JSON_PAYLOAD="{\"name\":\"$REPO_NAME\", \"private\":false}"; VIS_TEXT="Public 🌐"
    fi

    printf "${YELLOW}  ⏳  Création du dépôt $VIS_TEXT...${RESET}\n"
    HTTP_CREATE=$(curl -s -o /dev/null -w "%{http_code}" \
        -H "Authorization: token $TOKEN" -d "$JSON_PAYLOAD" \
        https://api.github.com/user/repos)

    [ "$HTTP_CREATE" != "201" ] && printf "${RED}${BOLD}  ❌  Impossible de créer le dépôt. Code : $HTTP_CREATE${RESET}\n\n" && exit 1
    printf "${GREEN}  ✅  Dépôt $VIS_TEXT créé avec succès.${RESET}\n"
else
    printf "${GREEN}  ✅  Dépôt trouvé — upload direct.${RESET}\n"
fi

printf "\n${YELLOW}  ⏳  Préparation des fichiers...${RESET}\n"
rm -rf "$TERMUX_PATH"

if [ -d "$FULL_TARGET" ]; then cp -r "$FULL_TARGET" "$TERMUX_PATH"
else mkdir -p "$TERMUX_PATH"; cp "$FULL_TARGET" "$TERMUX_PATH/"; fi

printf "${YELLOW}  ⚙️   Initialisation de Git...${RESET}\n"
cd "$TERMUX_PATH" || exit
git init > /dev/null 2>&1
git config user.name "$USERNAME"
git config user.email "$EMAIL"
git add .
git commit -m "Upload automatique via gitup" > /dev/null 2>&1
git branch -M main
git remote add origin "https://${TOKEN}@github.com/${USERNAME}/${REPO_NAME}.git"

printf "${YELLOW}  🚀  Upload de '$TARGET_NAME' vers GitHub...${RESET}\n"
if git push -u origin main -f 2>/dev/null; then
    printf "\n${GREEN}${BOLD}  ✅  Succès ! '$TARGET_NAME' → dépôt '$REPO_NAME'.${RESET}\n"
    rm -rf "$TERMUX_PATH"
    printf "${GREEN}  🧹  Fichiers temporaires supprimés.${RESET}\n\n"
else
    printf "\n${RED}${BOLD}  ❌  Échec de l'upload.${RESET}\n"
    printf "${YELLOW}  💾  Fichiers temporaires conservés : $TERMUX_PATH${RESET}\n\n"
fi
EOF

# ─────────────────────────────────────────────
#  gitget
# ─────────────────────────────────────────────
print_step "Création de la commande 'gitget'..."

cat << 'EOF' > $PREFIX/bin/gitget
#!/bin/bash

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; BOLD='\033[1m'; RESET='\033[0m'

source "$HOME/.github_config" || { printf "${RED}  ❌  Config introuvable.${RESET}\n"; exit 1; }

DOWNLOAD_DIR="/storage/emulated/0/Download"
GITHUB_DIR="/storage/emulated/0/github"

printf "\n${CYAN}${BOLD}╔══════════════════════════════════════════════╗${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}📥  GITHUB GET — Téléchargement de dépôt${RESET}     ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╚══════════════════════════════════════════════╝${RESET}\n\n"
printf "${CYAN}  👤  Compte actif : ${BOLD}$USERNAME${RESET}\n\n"

read -p "$(printf "${CYAN}${BOLD}  🏷️   Nom du dépôt à télécharger : ${RESET}")" REPO_NAME
[ -z "$REPO_NAME" ] && printf "${RED}  ⚠️   Le nom ne peut pas être vide.${RESET}\n\n" && exit 1

printf "\n${YELLOW}${BOLD}  📦  Mode de téléchargement :${RESET}\n"
printf "      ${GREEN}1)  📦  ZIP    — Rapide, sans historique Git${RESET}\n"
printf "      ${CYAN}2)  🔄  Clone  — Complet avec mémoire Git${RESET}\n"
read -p "$(printf "${CYAN}${BOLD}  👉  Votre choix (1 ou 2) : ${RESET}")" MODE_CHOICE
printf "\n"

[[ "$MODE_CHOICE" != "1" && "$MODE_CHOICE" != "2" ]] && printf "${RED}  ⚠️   Choix invalide.${RESET}\n\n" && exit 1

if [ "$MODE_CHOICE" == "2" ]; then
    mkdir -p "$GITHUB_DIR"
    TARGET_PATH="$GITHUB_DIR/$REPO_NAME"
    [ -d "$TARGET_PATH" ] && printf "${YELLOW}  ⚠️   Le dossier '$REPO_NAME' existe déjà.${RESET}\n\n" && exit 1
    printf "${YELLOW}  ⏳  Clonage de '$REPO_NAME'...${RESET}\n"
    if gh repo clone "$USERNAME/$REPO_NAME" "$TARGET_PATH" > /dev/null 2>&1; then
        printf "\n${GREEN}${BOLD}  ✅  Clonage réussi !${RESET}\n"
        printf "${GREEN}  📂  Emplacement : $TARGET_PATH${RESET}\n\n"
    else
        printf "\n${RED}${BOLD}  ❌  Échec du clonage.${RESET}\n\n"
    fi
else
    TARGET_FILE="$DOWNLOAD_DIR/$REPO_NAME.zip"
    printf "${YELLOW}  ⏳  Téléchargement de '$REPO_NAME' en ZIP...${RESET}\n"
    if gh repo archive "$USERNAME/$REPO_NAME" --format zip --output "$TARGET_FILE" > /dev/null 2>&1; then
        printf "\n${GREEN}${BOLD}  ✅  Téléchargement réussi !${RESET}\n"
        printf "${GREEN}  📂  Emplacement : $TARGET_FILE${RESET}\n\n"
    else
        printf "\n${RED}${BOLD}  ❌  Échec. Dépôt introuvable ou accès refusé.${RESET}\n\n"
    fi
fi
EOF

# ─────────────────────────────────────────────
#  gitlist
# ─────────────────────────────────────────────
print_step "Création de la commande 'gitlist'..."

cat << 'EOF' > $PREFIX/bin/gitlist
#!/bin/bash

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; MAGENTA='\033[0;35m'; BOLD='\033[1m'; RESET='\033[0m'

source "$HOME/.github_config" || { printf "${RED}  ❌  Config introuvable.${RESET}\n"; exit 1; }

printf "\n${CYAN}${BOLD}╔══════════════════════════════════════════════╗${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}📋  GITHUB LIST — Vos dépôts${RESET}                 ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╚══════════════════════════════════════════════╝${RESET}\n\n"
printf "${CYAN}  👤  Compte actif : ${BOLD}$USERNAME${RESET}\n\n"

printf "${YELLOW}${BOLD}  🔒  Filtre :${RESET}\n"
printf "      ${GREEN}1)  🌐  Tous les dépôts${RESET}\n"
printf "      ${CYAN}2)  🌐  Publics uniquement${RESET}\n"
printf "      ${YELLOW}3)  🔐  Privés uniquement${RESET}\n"
read -p "$(printf "${CYAN}${BOLD}  👉  Votre choix (1/2/3, vide = tous) : ${RESET}")" FILTER_CHOICE
printf "\n"

case "$FILTER_CHOICE" in
    2) FILTER="public"  ;;
    3) FILTER="private" ;;
    *) FILTER="all"     ;;
esac

printf "${YELLOW}  ⏳  Récupération de vos dépôts...${RESET}\n\n"

REPOS=$(curl -s \
    -H "Authorization: token $TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/user/repos?per_page=100&type=$FILTER&sort=updated")

COUNT=$(echo "$REPOS" | grep -o '"full_name"' | wc -l)

if [ "$COUNT" -eq 0 ]; then
    printf "${RED}  ❌  Aucun dépôt trouvé.${RESET}\n\n"; exit 0
fi

printf "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"

echo "$REPOS" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for r in data:
    name    = r.get('name','')
    private = r.get('private', False)
    updated = r.get('updated_at','')[:10]
    badge   = '\033[1;33m🔐 Privé \033[0m' if private else '\033[0;32m🌐 Public\033[0m'
    print(f'  {badge}  \033[1m{name:<30}\033[0m  \033[0;36mmis à jour : {updated}\033[0m')
"

printf "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
printf "${GREEN}${BOLD}  📊  Total : $COUNT dépôt(s) trouvé(s).${RESET}\n\n"
EOF

# ─────────────────────────────────────────────
#  gitpush
# ─────────────────────────────────────────────
print_step "Création de la commande 'gitpush'..."

cat << 'EOF' > $PREFIX/bin/gitpush
#!/bin/bash

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; BOLD='\033[1m'; RESET='\033[0m'

source "$HOME/.github_config" || { printf "${RED}  ❌  Config introuvable.${RESET}\n"; exit 1; }

GITHUB_DIR="/storage/emulated/0/github"

printf "\n${CYAN}${BOLD}╔══════════════════════════════════════════════╗${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}🚀  GITHUB PUSH — Envoi des modifications${RESET}     ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╚══════════════════════════════════════════════╝${RESET}\n\n"
printf "${CYAN}  👤  Compte actif : ${BOLD}$USERNAME${RESET}\n\n"

if [ ! -d "$GITHUB_DIR" ] || [ -z "$(ls -A "$GITHUB_DIR" 2>/dev/null)" ]; then
    printf "${RED}  ❌  Aucun dépôt cloné trouvé dans '$GITHUB_DIR'.${RESET}\n"
    printf "${YELLOW}  💡  Conseil : utilisez 'gitget' mode 2 pour cloner un dépôt.${RESET}\n\n"
    exit 1
fi

printf "${YELLOW}${BOLD}  📂  Dépôts disponibles :${RESET}\n"
INDEX=1; REPOS_LIST=()
for DIR in "$GITHUB_DIR"/*/; do
    REPO_NAME=$(basename "$DIR")
    REPOS_LIST+=("$REPO_NAME")
    printf "      ${GREEN}$INDEX)  $REPO_NAME${RESET}\n"
    ((INDEX++))
done
printf "\n"

read -p "$(printf "${CYAN}${BOLD}  👉  Numéro du dépôt à pousser : ${RESET}")" CHOICE

if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || [ "$CHOICE" -lt 1 ] || [ "$CHOICE" -gt "${#REPOS_LIST[@]}" ]; then
    printf "${RED}  ⚠️   Choix invalide.${RESET}\n\n"; exit 1
fi

SELECTED_REPO="${REPOS_LIST[$((CHOICE-1))]}"
TARGET_PATH="$GITHUB_DIR/$SELECTED_REPO"

read -p "$(printf "${CYAN}${BOLD}  📝  Message de commit (vide = 'Mise à jour automatique') : ${RESET}")" COMMIT_MSG
COMMIT_MSG=${COMMIT_MSG:-"Mise à jour automatique via gitpush"}

printf "\n${YELLOW}  ⚙️   Préparation du commit...${RESET}\n"
cd "$TARGET_PATH" || exit
git config user.name "$USERNAME"
git config user.email "$EMAIL"
git remote set-url origin "https://${TOKEN}@github.com/${USERNAME}/${SELECTED_REPO}.git" > /dev/null 2>&1
git add .

[ -z "$(git status --porcelain)" ] && printf "${YELLOW}  ℹ️   Aucune modification — dépôt déjà à jour.${RESET}\n\n" && exit 0

git commit -m "$COMMIT_MSG" > /dev/null 2>&1
printf "${YELLOW}  🚀  Envoi vers GitHub...${RESET}\n"

if git push origin main 2>/dev/null || git push origin master 2>/dev/null; then
    printf "\n${GREEN}${BOLD}  ✅  Modifications envoyées avec succès !${RESET}\n"
    printf "${GREEN}  📦  Dépôt : '$SELECTED_REPO'${RESET}\n"
    printf "${GREEN}  💬  Commit : '$COMMIT_MSG'${RESET}\n\n"
else
    printf "\n${RED}${BOLD}  ❌  Échec du push.${RESET}\n\n"
fi
EOF

# ─────────────────────────────────────────────
#  gitdel
# ─────────────────────────────────────────────
print_step "Création de la commande 'gitdel'..."

cat << 'EOF' > $PREFIX/bin/gitdel
#!/bin/bash

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; BOLD='\033[1m'; RESET='\033[0m'

source "$HOME/.github_config" || { printf "${RED}  ❌  Config introuvable.${RESET}\n"; exit 1; }

printf "\n${CYAN}${BOLD}╔══════════════════════════════════════════════╗${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${RED}${BOLD}🗑️   GITHUB DELETE — Suppression de dépôt${RESET}    ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╚══════════════════════════════════════════════╝${RESET}\n\n"
printf "${CYAN}  👤  Compte actif : ${BOLD}$USERNAME${RESET}\n\n"
printf "${YELLOW}  💡  Conseil : tapez 'gitlist' pour voir vos dépôts.${RESET}\n\n"

read -p "$(printf "${CYAN}${BOLD}  🏷️   Nom du dépôt à supprimer : ${RESET}")" REPO_NAME
[ -z "$REPO_NAME" ] && exit 1

printf "\n${RED}${BOLD}  ⚠️   ATTENTION : Cette action est IRRÉVERSIBLE !${RESET}\n"
read -p "$(printf "${YELLOW}${BOLD}  ❓  Retapez '$REPO_NAME' pour confirmer : ${RESET}")" CONFIRM_NAME

if [ "$CONFIRM_NAME" != "$REPO_NAME" ]; then
    printf "${GREEN}  🛑  Suppression annulée.${RESET}\n\n"; exit 1
fi

printf "${YELLOW}  ⏳  Suppression en cours...${RESET}\n"
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE \
    -H "Authorization: token $TOKEN" \
    "https://api.github.com/repos/$USERNAME/$REPO_NAME")

if [ "$HTTP_STATUS" -eq 204 ]; then
    printf "\n${GREEN}${BOLD}  ✅  Dépôt '$REPO_NAME' supprimé avec succès.${RESET}\n\n"
else
    printf "\n${RED}${BOLD}  ❌  Échec. Code HTTP : $HTTP_STATUS${RESET}\n\n"
fi
EOF

# ─────────────────────────────────────────────
#  cspace
# ─────────────────────────────────────────────
print_step "Création de la commande 'cspace'..."

cat << 'EOF' > $PREFIX/bin/cspace
#!/bin/bash

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; BOLD='\033[1m'; RESET='\033[0m'

source "$HOME/.github_config" || { printf "${RED}  ❌  Config introuvable.${RESET}\n"; exit 1; }

printf "\n${CYAN}${BOLD}╔══════════════════════════════════════════════╗${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}☁️   GITHUB CODESPACES — Serveur Cloud${RESET}       ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╚══════════════════════════════════════════════╝${RESET}\n\n"
printf "${CYAN}  👤  Compte actif : ${BOLD}$USERNAME${RESET}\n\n"

read -p "$(printf "${CYAN}${BOLD}  🏷️   Dépôt pour créer un espace (vide = connexion) : ${RESET}")" REPO_NAME

if [ -z "$REPO_NAME" ]; then
    printf "${YELLOW}  🔗  Connexion à votre Codespace existant...${RESET}\n"
    gh codespace ssh
else
    printf "${YELLOW}  ⏳  Création d'un serveur Cloud pour '$REPO_NAME'...${RESET}\n"
    if gh codespace create -R "$USERNAME/$REPO_NAME"; then
        printf "\n${GREEN}${BOLD}  ✅  Serveur créé ! Tapez 'cspace' pour vous y connecter.${RESET}\n\n"
    else
        printf "\n${RED}${BOLD}  ❌  Échec de création du Codespace.${RESET}\n\n"
    fi
fi
EOF

# ─────────────────────────────────────────────
#  gitswitch — Changer de compte GitHub
# ─────────────────────────────────────────────
print_step "Création de la commande 'gitswitch'..."

cat << 'EOF' > $PREFIX/bin/gitswitch
#!/bin/bash

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; MAGENTA='\033[0;35m'; BOLD='\033[1m'; RESET='\033[0m'

CONFIG_FILE="$HOME/.github_config"
ACCOUNTS_FILE="$HOME/.github_accounts"

# Charger le compte actif pour affichage
source "$CONFIG_FILE" 2>/dev/null
CURRENT_USER="${USERNAME:-inconnu}"

printf "\n${CYAN}${BOLD}╔══════════════════════════════════════════════╗${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}🔀  GITHUB SWITCH — Changer de compte${RESET}       ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╚══════════════════════════════════════════════╝${RESET}\n\n"
printf "${CYAN}  👤  Compte actif : ${BOLD}$CURRENT_USER${RESET}\n\n"

# ── Lire les comptes sauvegardés ──
USERNAMES=(); EMAILS=(); TOKENS=(); LABELS=()
while IFS='|' read -r u e t l; do
    [ -z "$u" ] && continue
    USERNAMES+=("$u"); EMAILS+=("$e"); TOKENS+=("$t"); LABELS+=("$l")
done < "$ACCOUNTS_FILE" 2>/dev/null

TOTAL=${#USERNAMES[@]}

printf "${YELLOW}${BOLD}  📋  Comptes enregistrés :${RESET}\n\n"

if [ "$TOTAL" -eq 0 ]; then
    printf "${YELLOW}  ℹ️   Aucun compte enregistré.${RESET}\n\n"
else
    for i in "${!USERNAMES[@]}"; do
        NUM=$((i+1))
        MARKER=""
        [ "${USERNAMES[$i]}" == "$CURRENT_USER" ] && MARKER=" ${GREEN}← actif${RESET}"
        printf "  ${CYAN}${BOLD}$NUM)${RESET}  ${BOLD}${LABELS[$i]}${RESET}  ${CYAN}(@${USERNAMES[$i]})${RESET}$MARKER\n"
    done
fi

printf "\n  ${MAGENTA}${BOLD}+)${RESET}  Ajouter un nouveau compte\n\n"

read -p "$(printf "${CYAN}${BOLD}  👉  Votre choix : ${RESET}")" CHOICE

# ── Ajout d'un nouveau compte ──
if [[ "$CHOICE" == "+" ]]; then
    printf "\n${YELLOW}${BOLD}  ➕  Nouveau compte GitHub${RESET}\n\n"
    read -p "$(printf "${CYAN}${BOLD}  👤  Nom d'utilisateur : ${RESET}")" NEW_USER
    read -p "$(printf "${CYAN}${BOLD}  📧  Adresse e-mail    : ${RESET}")" NEW_EMAIL
    read -p "$(printf "${CYAN}${BOLD}  🔑  Token d'accès     : ${RESET}")" NEW_TOKEN
    read -p "$(printf "${CYAN}${BOLD}  🏷️   Label du compte   : ${RESET}")" NEW_LABEL
    NEW_LABEL=${NEW_LABEL:-$NEW_USER}

    [ -z "$NEW_USER" ] || [ -z "$NEW_TOKEN" ] && printf "${RED}  ⚠️   Utilisateur et token obligatoires.${RESET}\n\n" && exit 1

    # Vérification du token
    printf "${YELLOW}  🔍  Vérification du token...${RESET}\n"
    HTTP_CHECK=$(curl -s -o /dev/null -w "%{http_code}" \
        -H "Authorization: token $NEW_TOKEN" \
        "https://api.github.com/user")

    if [ "$HTTP_CHECK" != "200" ]; then
        printf "${RED}${BOLD}  ❌  Token invalide ou accès refusé. Code : $HTTP_CHECK${RESET}\n\n"
        exit 1
    fi
    printf "${GREEN}  ✅  Token valide.${RESET}\n\n"

    # Sauvegarder dans le fichier des comptes
    if grep -q "^$NEW_USER|" "$ACCOUNTS_FILE" 2>/dev/null; then
        # Mettre à jour l'entrée existante
        sed -i "s|^$NEW_USER|.*|$NEW_USER|$NEW_EMAIL|$NEW_TOKEN|$NEW_LABEL|" "$ACCOUNTS_FILE"
    else
        echo "$NEW_USER|$NEW_EMAIL|$NEW_TOKEN|$NEW_LABEL" >> "$ACCOUNTS_FILE"
    fi

    CHOICE="new"
    SEL_USER="$NEW_USER"; SEL_EMAIL="$NEW_EMAIL"; SEL_TOKEN="$NEW_TOKEN"

# ── Sélection d'un compte existant ──
elif [[ "$CHOICE" =~ ^[0-9]+$ ]] && [ "$CHOICE" -ge 1 ] && [ "$CHOICE" -le "$TOTAL" ]; then
    IDX=$((CHOICE-1))
    SEL_USER="${USERNAMES[$IDX]}"
    SEL_EMAIL="${EMAILS[$IDX]}"
    SEL_TOKEN="${TOKENS[$IDX]}"

    if [ "$SEL_USER" == "$CURRENT_USER" ]; then
        printf "\n${YELLOW}  ℹ️   Vous utilisez déjà ce compte.${RESET}\n\n"
        exit 0
    fi
else
    printf "${RED}  ⚠️   Choix invalide.${RESET}\n\n"; exit 1
fi

# ── Appliquer le compte sélectionné ──
printf "${YELLOW}  ⏳  Activation du compte '$SEL_USER'...${RESET}\n"

cat > "$CONFIG_FILE" << CONFEOF
USERNAME="$SEL_USER"
EMAIL="$SEL_EMAIL"
TOKEN="$SEL_TOKEN"
CONFEOF
chmod 600 "$CONFIG_FILE"

# Re-authentifier gh CLI
echo "$SEL_TOKEN" | gh auth login --with-token 2>/dev/null
git config --global user.name "$SEL_USER"
git config --global user.email "$SEL_EMAIL"

printf "\n${GREEN}${BOLD}  ✅  Compte activé avec succès !${RESET}\n"
printf "${GREEN}  👤  Désormais connecté en tant que : ${BOLD}$SEL_USER${RESET}\n\n"
EOF

# ─────────────────────────────────────────────
#  gituninstall — Désinstallation complète
# ─────────────────────────────────────────────
print_step "Création de la commande 'gituninstall'..."

cat << 'EOF' > $PREFIX/bin/gituninstall
#!/bin/bash

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; BOLD='\033[1m'; RESET='\033[0m'

TOOLS=(gitup gitget gitlist gitpush gitdel cspace gitswitch githelp gituninstall)

printf "\n${CYAN}${BOLD}╔══════════════════════════════════════════════╗${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${RED}${BOLD}🗑️   GITHUB TOOLS — Désinstallation complète${RESET} ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╚══════════════════════════════════════════════╝${RESET}\n\n"

printf "${YELLOW}  Les éléments suivants seront supprimés :${RESET}\n\n"
for t in "${TOOLS[@]}"; do
    printf "    ${RED}✗  $t${RESET}\n"
done
printf "    ${RED}✗  ~/.github_config${RESET}\n"
printf "    ${RED}✗  ~/.github_accounts${RESET}\n\n"

printf "${RED}${BOLD}  ⚠️   Cette action est IRRÉVERSIBLE.${RESET}\n"
read -p "$(printf "${YELLOW}${BOLD}  ❓  Tapez 'OUI' pour confirmer : ${RESET}")" CONFIRM

if [ "$CONFIRM" != "OUI" ]; then
    printf "\n${GREEN}  🛑  Désinstallation annulée.${RESET}\n\n"; exit 0
fi

printf "\n${YELLOW}  ⏳  Suppression en cours...${RESET}\n\n"

for t in "${TOOLS[@]}"; do
    if [ -f "$PREFIX/bin/$t" ]; then
        rm -f "$PREFIX/bin/$t"
        printf "  ${GREEN}✓${RESET}  $t supprimé\n"
    fi
done

rm -f "$HOME/.github_config"  && printf "  ${GREEN}✓${RESET}  ~/.github_config supprimé\n"
rm -f "$HOME/.github_accounts" && printf "  ${GREEN}✓${RESET}  ~/.github_accounts supprimé\n"

printf "\n${GREEN}${BOLD}  ✅  Désinstallation terminée. À bientôt !${RESET}\n\n"
EOF

# ─────────────────────────────────────────────
#  githelp — Menu d'aide mis à jour
# ─────────────────────────────────────────────
print_step "Création de la commande 'githelp'..."

cat << 'EOF' > $PREFIX/bin/githelp
#!/bin/bash

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; MAGENTA='\033[0;35m'; BOLD='\033[1m'; RESET='\033[0m'

source "$HOME/.github_config" 2>/dev/null
CURRENT_USER="${USERNAME:-non connecté}"

printf "\n"
printf "${CYAN}${BOLD}╔══════════════════════════════════════════════════════════╗${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}🛠️   BOÎTE À OUTILS GITHUB — Termux Edition${RESET}             ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${CYAN}  👤  Compte actif : ${BOLD}$CURRENT_USER${RESET}                              ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╠══════════════════════════════════════════════════════════╣${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${GREEN}${BOLD}📤  gitup${RESET}        Uploader un dossier/fichier vers GitHub. ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}📥  gitget${RESET}       Télécharger un dépôt (ZIP ou Clone).    ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${CYAN}${BOLD}📋  gitlist${RESET}      Afficher tous vos dépôts GitHub.          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${GREEN}${BOLD}🚀  gitpush${RESET}      Pousser les modifications d'un clone.    ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${RED}${BOLD}🗑️   gitdel${RESET}       Supprimer un dépôt DÉFINITIVEMENT.       ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${MAGENTA}${BOLD}☁️   cspace${RESET}       Créer ou rejoindre un GitHub Codespace. ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}🔀  gitswitch${RESET}    Changer de compte GitHub.               ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}            Lister les comptes / Ajouter un nouveau.     ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${RED}${BOLD}💣  gituninstall${RESET} Supprimer tous les outils d'un coup.     ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${GREEN}${BOLD}ℹ️   githelp${RESET}      Afficher ce menu d'aide.                ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╠══════════════════════════════════════════════════════════╣${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}📌  COMMANDES GITHUB UTILES${RESET}                             ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╠══════════════════════════════════════════════════════════╣${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${RED}${BOLD}🗑️   gh codespace delete${RESET}  Supprimer un serveur Cloud.    ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}🚪  exit${RESET}                 Quitter un serveur Codespace.  ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}\n"
printf "\n"
EOF

# ══════════════════════════════════════════════════════════
#  ÉTAPE 6 — Permissions
# ══════════════════════════════════════════════════════════

print_step "Attribution des permissions d'exécution..."
chmod +x $PREFIX/bin/gitup
chmod +x $PREFIX/bin/gitget
chmod +x $PREFIX/bin/gitlist
chmod +x $PREFIX/bin/gitpush
chmod +x $PREFIX/bin/gitdel
chmod +x $PREFIX/bin/cspace
chmod +x $PREFIX/bin/gitswitch
chmod +x $PREFIX/bin/gituninstall
chmod +x $PREFIX/bin/githelp
print_success "Permissions accordées à toutes les commandes."
printf "\n"

# ══════════════════════════════════════════════════════════
#  ÉTAPE 7 — Stockage
# ══════════════════════════════════════════════════════════

print_step "Configuration de l'accès au stockage Termux..."
termux-setup-storage
print_success "Stockage configuré."
printf "\n"

# ══════════════════════════════════════════════════════════
#  FIN
# ══════════════════════════════════════════════════════════

printf "${CYAN}${BOLD}╔══════════════════════════════════════════════════════════╗${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${GREEN}${BOLD}🎉  INSTALLATION TERMINÉE AVEC SUCCÈS !${RESET}               ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${WHITE}${BOLD}👉  Tapez  ${YELLOW}githelp${RESET}${WHITE}${BOLD}  pour voir toutes vos commandes.${RESET}  ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}\n"
printf "\n"
