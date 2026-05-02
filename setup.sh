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

STATUS_INSTALLED=()
STATUS_UPDATED=()
STATUS_SKIPPED=()

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
    printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}   gitup · gitget · gitlist · gitpush · gitdel        ${RESET}  ${CYAN}${BOLD}║${RESET}\n"
    printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}         cspace · gitswitch · gituninstall            ${RESET}  ${CYAN}${BOLD}║${RESET}\n"
    printf "${CYAN}${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}\n\n"
}

print_step()    { printf "${BLUE}${BOLD}[•]${RESET} ${WHITE}$1${RESET}\n"; }
print_success() { printf "${GREEN}${BOLD}[✓]${RESET} ${GREEN}$1${RESET}\n"; }
print_skip()    { printf "${YELLOW}[~]${RESET} ${YELLOW}$1${RESET}\n"; }

# ─────────────────────────────────────────────
#  Installe, met à jour, ou ignore un outil
#  Usage: deploy_tool "nom" "/chemin/tmpfile"
# ─────────────────────────────────────────────
deploy_tool() {
    local name="$1"
    local tmpfile="$2"
    local target="$PREFIX/bin/$name"

    if [ ! -f "$target" ]; then
        cp "$tmpfile" "$target" && chmod +x "$target"
        STATUS_INSTALLED+=("$name")
    elif ! cmp -s "$tmpfile" "$target"; then
        cp "$tmpfile" "$target" && chmod +x "$target"
        STATUS_UPDATED+=("$name")
    else
        STATUS_SKIPPED+=("$name")
    fi
    rm -f "$tmpfile"
}

print_banner

# ══════════════════════════════════════════════════════════
#  ÉTAPE 1 — Paquets manquants uniquement (pas de update/upgrade)
# ══════════════════════════════════════════════════════════

printf "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
printf "${YELLOW}${BOLD}  📦  Vérification des dépendances${RESET}\n"
printf "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n\n"

for dep in git gh openssh zip python3; do
    if command -v "$dep" > /dev/null 2>&1; then
        print_skip "$dep déjà installé — ignoré."
    else
        print_step "Installation de $dep..."
        pkg install "$dep" -y > /dev/null 2>&1 && print_success "$dep installé."
    fi
done
printf "\n"

# ══════════════════════════════════════════════════════════
#  ÉTAPE 2 — Déploiement des outils (install / update / skip)
# ══════════════════════════════════════════════════════════

printf "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
printf "${YELLOW}${BOLD}  🛠️   Déploiement des outils${RESET}\n"
printf "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n\n"

# ── gitup ──────────────────────────────────────────────────
T=$(mktemp); cat << 'EOF' > "$T"
#!/bin/bash
GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; BOLD='\033[1m'; RESET='\033[0m'
CONFIG="$HOME/.github_config"
[ ! -f "$CONFIG" ] && printf "${RED}  ❌  Aucun compte configuré. Lancez : ${BOLD}gitswitch${RESET}\n\n" && exit 1
source "$CONFIG"
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
printf "\n${YELLOW}  🔍  Vérification du dépôt '$REPO_NAME'...${RESET}\n"
HTTP_CHECK=$(curl -s -o /dev/null -w "%{http_code}" \
    -H "Authorization: token $TOKEN" \
    "https://api.github.com/repos/$USERNAME/$REPO_NAME")
if [ "$HTTP_CHECK" != "200" ]; then
    printf "${YELLOW}  ⚠️   Le dépôt n'existe pas encore.${RESET}\n"
    read -p "$(printf "${CYAN}${BOLD}  ❓  Créer le dépôt maintenant ? (o/n) : ${RESET}")" CREATE_REPO
    [[ "$CREATE_REPO" != "o" && "$CREATE_REPO" != "O" ]] && printf "${RED}  🛑  Annulé.${RESET}\n\n" && exit 1
    printf "\n${YELLOW}${BOLD}  🔒  Visibilité :${RESET}\n"
    printf "      ${GREEN}1)  🌐  Public${RESET}\n      ${YELLOW}2)  🔐  Privé${RESET}\n"
    read -p "$(printf "${CYAN}${BOLD}  👉  Votre choix (1 ou 2) : ${RESET}")" VIS
    if [ "$VIS" == "2" ]; then
        JSON="{\"name\":\"$REPO_NAME\",\"private\":true}"; VIS_TEXT="Privé 🔐"
    else
        JSON="{\"name\":\"$REPO_NAME\",\"private\":false}"; VIS_TEXT="Public 🌐"
    fi
    HTTP_CREATE=$(curl -s -o /dev/null -w "%{http_code}" \
        -H "Authorization: token $TOKEN" -d "$JSON" https://api.github.com/user/repos)
    [ "$HTTP_CREATE" != "201" ] && printf "${RED}  ❌  Impossible de créer. Code : $HTTP_CREATE${RESET}\n\n" && exit 1
    printf "${GREEN}  ✅  Dépôt $VIS_TEXT créé.${RESET}\n"
else
    printf "${GREEN}  ✅  Dépôt trouvé — upload direct.${RESET}\n"
fi
printf "\n${YELLOW}  ⏳  Préparation des fichiers...${RESET}\n"
rm -rf "$TERMUX_PATH"
if [ -d "$FULL_TARGET" ]; then cp -r "$FULL_TARGET" "$TERMUX_PATH"
else mkdir -p "$TERMUX_PATH"; cp "$FULL_TARGET" "$TERMUX_PATH/"; fi
cd "$TERMUX_PATH" || exit
git init > /dev/null 2>&1
git config user.name "$USERNAME"; git config user.email "$EMAIL"
git add .
git commit -m "Upload automatique via gitup" > /dev/null 2>&1
git branch -M main
git remote add origin "https://${TOKEN}@github.com/${USERNAME}/${REPO_NAME}.git"
printf "${YELLOW}  🚀  Upload vers GitHub...${RESET}\n"
if git push -u origin main -f 2>/dev/null; then
    printf "\n${GREEN}${BOLD}  ✅  Succès ! '$TARGET_NAME' → '$REPO_NAME'.${RESET}\n"
    rm -rf "$TERMUX_PATH"; printf "${GREEN}  🧹  Fichiers temporaires supprimés.${RESET}\n\n"
else
    printf "\n${RED}${BOLD}  ❌  Échec de l'upload.${RESET}\n"
    printf "${YELLOW}  💾  Fichiers conservés : $TERMUX_PATH${RESET}\n\n"
fi
EOF
deploy_tool "gitup" "$T"

# ── gitget ─────────────────────────────────────────────────
T=$(mktemp); cat << 'EOF' > "$T"
#!/bin/bash
GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; BOLD='\033[1m'; RESET='\033[0m'
CONFIG="$HOME/.github_config"
[ ! -f "$CONFIG" ] && printf "${RED}  ❌  Aucun compte configuré. Lancez : ${BOLD}gitswitch${RESET}\n\n" && exit 1
source "$CONFIG"
DOWNLOAD_DIR="/storage/emulated/0/Download"
GITHUB_DIR="/storage/emulated/0/github"
printf "\n${CYAN}${BOLD}╔══════════════════════════════════════════════╗${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}📥  GITHUB GET — Téléchargement de dépôt${RESET}     ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╚══════════════════════════════════════════════╝${RESET}\n\n"
printf "${CYAN}  👤  Compte actif : ${BOLD}$USERNAME${RESET}\n\n"
read -p "$(printf "${CYAN}${BOLD}  🏷️   Nom du dépôt : ${RESET}")" REPO_NAME
[ -z "$REPO_NAME" ] && printf "${RED}  ⚠️   Nom obligatoire.${RESET}\n\n" && exit 1
printf "\n${YELLOW}${BOLD}  📦  Mode :${RESET}\n"
printf "      ${GREEN}1)  📦  ZIP    — Rapide, sans Git${RESET}\n"
printf "      ${CYAN}2)  🔄  Clone  — Complet avec Git${RESET}\n"
read -p "$(printf "${CYAN}${BOLD}  👉  Votre choix (1 ou 2) : ${RESET}")" MODE
printf "\n"
[[ "$MODE" != "1" && "$MODE" != "2" ]] && printf "${RED}  ⚠️   Choix invalide.${RESET}\n\n" && exit 1
if [ "$MODE" == "2" ]; then
    mkdir -p "$GITHUB_DIR"; TARGET_PATH="$GITHUB_DIR/$REPO_NAME"
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
    printf "${YELLOW}  ⏳  Téléchargement ZIP de '$REPO_NAME'...${RESET}\n"
    if gh repo archive "$USERNAME/$REPO_NAME" --format zip --output "$TARGET_FILE" > /dev/null 2>&1; then
        printf "\n${GREEN}${BOLD}  ✅  Téléchargement réussi !${RESET}\n"
        printf "${GREEN}  📂  Emplacement : $TARGET_FILE${RESET}\n\n"
    else
        printf "\n${RED}${BOLD}  ❌  Échec. Dépôt introuvable ou accès refusé.${RESET}\n\n"
    fi
fi
EOF
deploy_tool "gitget" "$T"

# ── gitlist ────────────────────────────────────────────────
T=$(mktemp); cat << 'EOF' > "$T"
#!/bin/bash
GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; MAGENTA='\033[0;35m'; BOLD='\033[1m'; RESET='\033[0m'
CONFIG="$HOME/.github_config"
[ ! -f "$CONFIG" ] && printf "${RED}  ❌  Aucun compte configuré. Lancez : ${BOLD}gitswitch${RESET}\n\n" && exit 1
source "$CONFIG"
printf "\n${CYAN}${BOLD}╔══════════════════════════════════════════════╗${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}📋  GITHUB LIST — Vos dépôts${RESET}                 ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╚══════════════════════════════════════════════╝${RESET}\n\n"
printf "${CYAN}  👤  Compte actif : ${BOLD}$USERNAME${RESET}\n\n"
printf "${YELLOW}${BOLD}  🔒  Filtre :${RESET}\n"
printf "      ${GREEN}1)  🌐  Tous${RESET}\n      ${CYAN}2)  🌐  Publics${RESET}\n      ${YELLOW}3)  🔐  Privés${RESET}\n"
read -p "$(printf "${CYAN}${BOLD}  👉  Votre choix (vide = tous) : ${RESET}")" F
printf "\n"
case "$F" in 2) FILTER="public";; 3) FILTER="private";; *) FILTER="all";; esac
printf "${YELLOW}  ⏳  Récupération...${RESET}\n\n"
REPOS=$(curl -s -H "Authorization: token $TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/user/repos?per_page=100&type=$FILTER&sort=updated")
COUNT=$(echo "$REPOS" | grep -o '"full_name"' | wc -l)
[ "$COUNT" -eq 0 ] && printf "${RED}  ❌  Aucun dépôt trouvé.${RESET}\n\n" && exit 0
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
printf "${GREEN}${BOLD}  📊  Total : $COUNT dépôt(s).${RESET}\n\n"
EOF
deploy_tool "gitlist" "$T"

# ── gitpush ────────────────────────────────────────────────
T=$(mktemp); cat << 'EOF' > "$T"
#!/bin/bash
GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; BOLD='\033[1m'; RESET='\033[0m'
CONFIG="$HOME/.github_config"
[ ! -f "$CONFIG" ] && printf "${RED}  ❌  Aucun compte configuré. Lancez : ${BOLD}gitswitch${RESET}\n\n" && exit 1
source "$CONFIG"
GITHUB_DIR="/storage/emulated/0/github"
printf "\n${CYAN}${BOLD}╔══════════════════════════════════════════════╗${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}🚀  GITHUB PUSH — Envoi des modifications${RESET}     ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╚══════════════════════════════════════════════╝${RESET}\n\n"
printf "${CYAN}  👤  Compte actif : ${BOLD}$USERNAME${RESET}\n\n"
if [ ! -d "$GITHUB_DIR" ] || [ -z "$(ls -A "$GITHUB_DIR" 2>/dev/null)" ]; then
    printf "${RED}  ❌  Aucun dépôt cloné dans '$GITHUB_DIR'.${RESET}\n"
    printf "${YELLOW}  💡  Utilisez 'gitget' mode 2 pour cloner.${RESET}\n\n"; exit 1
fi
printf "${YELLOW}${BOLD}  📂  Dépôts disponibles :${RESET}\n"
INDEX=1; REPOS_LIST=()
for DIR in "$GITHUB_DIR"/*/; do
    REPO_NAME=$(basename "$DIR"); REPOS_LIST+=("$REPO_NAME")
    printf "      ${GREEN}$INDEX)  $REPO_NAME${RESET}\n"; ((INDEX++))
done
printf "\n"
read -p "$(printf "${CYAN}${BOLD}  👉  Numéro du dépôt : ${RESET}")" CHOICE
if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || [ "$CHOICE" -lt 1 ] || [ "$CHOICE" -gt "${#REPOS_LIST[@]}" ]; then
    printf "${RED}  ⚠️   Choix invalide.${RESET}\n\n"; exit 1
fi
SELECTED="${REPOS_LIST[$((CHOICE-1))]}"
TARGET_PATH="$GITHUB_DIR/$SELECTED"
read -p "$(printf "${CYAN}${BOLD}  📝  Message de commit (vide = automatique) : ${RESET}")" COMMIT_MSG
COMMIT_MSG=${COMMIT_MSG:-"Mise à jour automatique via gitpush"}
printf "\n${YELLOW}  ⚙️   Préparation du commit...${RESET}\n"
cd "$TARGET_PATH" || exit
git config user.name "$USERNAME"; git config user.email "$EMAIL"
git remote set-url origin "https://${TOKEN}@github.com/${USERNAME}/${SELECTED}.git" > /dev/null 2>&1
git add .
[ -z "$(git status --porcelain)" ] && printf "${YELLOW}  ℹ️   Aucune modification — déjà à jour.${RESET}\n\n" && exit 0
git commit -m "$COMMIT_MSG" > /dev/null 2>&1
printf "${YELLOW}  🚀  Envoi vers GitHub...${RESET}\n"
if git push origin main 2>/dev/null || git push origin master 2>/dev/null; then
    printf "\n${GREEN}${BOLD}  ✅  Succès !${RESET}\n"
    printf "${GREEN}  📦  Dépôt : '$SELECTED'  💬  '$COMMIT_MSG'${RESET}\n\n"
else
    printf "\n${RED}${BOLD}  ❌  Échec du push.${RESET}\n\n"
fi
EOF
deploy_tool "gitpush" "$T"

# ── gitdel ─────────────────────────────────────────────────
T=$(mktemp); cat << 'EOF' > "$T"
#!/bin/bash
GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; BOLD='\033[1m'; RESET='\033[0m'
CONFIG="$HOME/.github_config"
[ ! -f "$CONFIG" ] && printf "${RED}  ❌  Aucun compte configuré. Lancez : ${BOLD}gitswitch${RESET}\n\n" && exit 1
source "$CONFIG"
printf "\n${CYAN}${BOLD}╔══════════════════════════════════════════════╗${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${RED}${BOLD}🗑️   GITHUB DELETE — Suppression de dépôt${RESET}    ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╚══════════════════════════════════════════════╝${RESET}\n\n"
printf "${CYAN}  👤  Compte actif : ${BOLD}$USERNAME${RESET}\n\n"
printf "${YELLOW}  💡  Tapez 'gitlist' pour voir vos dépôts.${RESET}\n\n"
read -p "$(printf "${CYAN}${BOLD}  🏷️   Nom du dépôt à supprimer : ${RESET}")" REPO_NAME
[ -z "$REPO_NAME" ] && exit 1
printf "\n${RED}${BOLD}  ⚠️   ATTENTION : Action IRRÉVERSIBLE !${RESET}\n"
read -p "$(printf "${YELLOW}${BOLD}  ❓  Retapez '$REPO_NAME' pour confirmer : ${RESET}")" CONFIRM
[ "$CONFIRM" != "$REPO_NAME" ] && printf "${GREEN}  🛑  Suppression annulée.${RESET}\n\n" && exit 1
printf "${YELLOW}  ⏳  Suppression...${RESET}\n"
HTTP=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE \
    -H "Authorization: token $TOKEN" \
    "https://api.github.com/repos/$USERNAME/$REPO_NAME")
if [ "$HTTP" -eq 204 ]; then
    printf "\n${GREEN}${BOLD}  ✅  Dépôt '$REPO_NAME' supprimé.${RESET}\n\n"
else
    printf "\n${RED}${BOLD}  ❌  Échec. Code HTTP : $HTTP${RESET}\n\n"
fi
EOF
deploy_tool "gitdel" "$T"

# ── cspace ─────────────────────────────────────────────────
T=$(mktemp); cat << 'EOF' > "$T"
#!/bin/bash
GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; BOLD='\033[1m'; RESET='\033[0m'
CONFIG="$HOME/.github_config"
[ ! -f "$CONFIG" ] && printf "${RED}  ❌  Aucun compte configuré. Lancez : ${BOLD}gitswitch${RESET}\n\n" && exit 1
source "$CONFIG"
printf "\n${CYAN}${BOLD}╔══════════════════════════════════════════════╗${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}☁️   GITHUB CODESPACES — Serveur Cloud${RESET}       ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╚══════════════════════════════════════════════╝${RESET}\n\n"
printf "${CYAN}  👤  Compte actif : ${BOLD}$USERNAME${RESET}\n\n"
read -p "$(printf "${CYAN}${BOLD}  🏷️   Dépôt (vide = connexion existante) : ${RESET}")" REPO_NAME
if [ -z "$REPO_NAME" ]; then
    printf "${YELLOW}  🔗  Connexion au Codespace...${RESET}\n"; gh codespace ssh
else
    printf "${YELLOW}  ⏳  Création d'un Codespace pour '$REPO_NAME'...${RESET}\n"
    if gh codespace create -R "$USERNAME/$REPO_NAME"; then
        printf "\n${GREEN}${BOLD}  ✅  Créé ! Tapez 'cspace' pour vous connecter.${RESET}\n\n"
    else
        printf "\n${RED}${BOLD}  ❌  Échec.${RESET}\n\n"
    fi
fi
EOF
deploy_tool "cspace" "$T"

# ── gitswitch ──────────────────────────────────────────────
T=$(mktemp); cat << 'EOF' > "$T"
#!/bin/bash
GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; MAGENTA='\033[0;35m'; BOLD='\033[1m'; RESET='\033[0m'
CONFIG_FILE="$HOME/.github_config"
ACCOUNTS_FILE="$HOME/.github_accounts"
touch "$ACCOUNTS_FILE" 2>/dev/null
source "$CONFIG_FILE" 2>/dev/null
CURRENT_USER="${USERNAME:-}"
printf "\n${CYAN}${BOLD}╔══════════════════════════════════════════════╗${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}🔀  GITHUB SWITCH — Changer de compte${RESET}       ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╚══════════════════════════════════════════════╝${RESET}\n\n"
[ -n "$CURRENT_USER" ] && printf "${CYAN}  👤  Compte actif : ${BOLD}$CURRENT_USER${RESET}\n\n"
USERNAMES=(); EMAILS=(); TOKENS=(); LABELS=()
while IFS='|' read -r u e t l; do
    [ -z "$u" ] && continue
    USERNAMES+=("$u"); EMAILS+=("$e"); TOKENS+=("$t"); LABELS+=("$l")
done < "$ACCOUNTS_FILE"
TOTAL=${#USERNAMES[@]}
if [ "$TOTAL" -gt 0 ]; then
    printf "${YELLOW}${BOLD}  📋  Comptes enregistrés :${RESET}\n\n"
    for i in "${!USERNAMES[@]}"; do
        NUM=$((i+1))
        MARKER=""
        [ "${USERNAMES[$i]}" == "$CURRENT_USER" ] && MARKER="  ${GREEN}← actif${RESET}"
        printf "  ${CYAN}${BOLD}$NUM)${RESET}  ${BOLD}${LABELS[$i]:-${USERNAMES[$i]}}${RESET}  ${CYAN}(@${USERNAMES[$i]})${RESET}$MARKER\n"
    done
    printf "\n"
fi
printf "  ${MAGENTA}${BOLD}+)${RESET}  Ajouter un nouveau compte\n\n"
read -p "$(printf "${CYAN}${BOLD}  👉  Votre choix : ${RESET}")" CHOICE
if [[ "$CHOICE" == "+" ]]; then
    printf "\n${YELLOW}${BOLD}  ➕  Nouveau compte GitHub${RESET}\n\n"
    read -p "$(printf "${CYAN}${BOLD}  👤  Nom d'utilisateur : ${RESET}")" NEW_USER
    read -p "$(printf "${CYAN}${BOLD}  📧  Adresse e-mail    : ${RESET}")" NEW_EMAIL
    read -p "$(printf "${CYAN}${BOLD}  🔑  Token d'accès     : ${RESET}")" NEW_TOKEN
    read -p "$(printf "${CYAN}${BOLD}  🏷️   Label du compte   : ${RESET}")" NEW_LABEL
    NEW_LABEL=${NEW_LABEL:-$NEW_USER}
    [ -z "$NEW_USER" ] || [ -z "$NEW_TOKEN" ] && printf "${RED}  ⚠️   Utilisateur et token obligatoires.${RESET}\n\n" && exit 1
    printf "${YELLOW}  🔍  Vérification du token...${RESET}\n"
    HTTP=$(curl -s -o /dev/null -w "%{http_code}" \
        -H "Authorization: token $NEW_TOKEN" "https://api.github.com/user")
    [ "$HTTP" != "200" ] && printf "${RED}${BOLD}  ❌  Token invalide. Code : $HTTP${RESET}\n\n" && exit 1
    printf "${GREEN}  ✅  Token valide.${RESET}\n"
    if grep -q "^$NEW_USER|" "$ACCOUNTS_FILE" 2>/dev/null; then
        sed -i "/^$NEW_USER|/d" "$ACCOUNTS_FILE"
    fi
    echo "$NEW_USER|$NEW_EMAIL|$NEW_TOKEN|$NEW_LABEL" >> "$ACCOUNTS_FILE"
    SEL_USER="$NEW_USER"; SEL_EMAIL="$NEW_EMAIL"; SEL_TOKEN="$NEW_TOKEN"
elif [[ "$CHOICE" =~ ^[0-9]+$ ]] && [ "$CHOICE" -ge 1 ] && [ "$CHOICE" -le "$TOTAL" ]; then
    IDX=$((CHOICE-1))
    SEL_USER="${USERNAMES[$IDX]}"; SEL_EMAIL="${EMAILS[$IDX]}"; SEL_TOKEN="${TOKENS[$IDX]}"
    if [ "$SEL_USER" == "$CURRENT_USER" ]; then
        printf "\n${YELLOW}  ℹ️   Vous utilisez déjà ce compte.${RESET}\n\n"; exit 0
    fi
else
    printf "${RED}  ⚠️   Choix invalide.${RESET}\n\n"; exit 1
fi
printf "\n${YELLOW}  ⏳  Activation du compte '$SEL_USER'...${RESET}\n"
printf 'USERNAME="%s"\nEMAIL="%s"\nTOKEN="%s"\n' "$SEL_USER" "$SEL_EMAIL" "$SEL_TOKEN" > "$CONFIG_FILE"
chmod 600 "$CONFIG_FILE"
echo "$SEL_TOKEN" | gh auth login --with-token 2>/dev/null
git config --global user.name "$SEL_USER"
git config --global user.email "$SEL_EMAIL"
printf "\n${GREEN}${BOLD}  ✅  Connecté en tant que : ${BOLD}$SEL_USER${RESET}\n\n"
EOF
deploy_tool "gitswitch" "$T"

# ── gituninstall ───────────────────────────────────────────
T=$(mktemp); cat << 'EOF' > "$T"
#!/bin/bash
GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; BOLD='\033[1m'; RESET='\033[0m'
TOOLS=(gitup gitget gitlist gitpush gitdel cspace gitswitch githelp gituninstall)
printf "\n${CYAN}${BOLD}╔══════════════════════════════════════════════╗${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${RED}${BOLD}💣  GITHUB TOOLS — Désinstallation complète${RESET}  ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╚══════════════════════════════════════════════╝${RESET}\n\n"
printf "${YELLOW}  Éléments à supprimer :${RESET}\n\n"
for t in "${TOOLS[@]}"; do printf "    ${RED}✗  $t${RESET}\n"; done
printf "    ${RED}✗  ~/.github_config${RESET}\n"
printf "    ${RED}✗  ~/.github_accounts${RESET}\n\n"
printf "${RED}${BOLD}  ⚠️   Action IRRÉVERSIBLE.${RESET}\n"
read -p "$(printf "${YELLOW}${BOLD}  ❓  Tapez 'OUI' pour confirmer : ${RESET}")" CONFIRM
[ "$CONFIRM" != "OUI" ] && printf "\n${GREEN}  🛑  Annulé.${RESET}\n\n" && exit 0
printf "\n${YELLOW}  ⏳  Suppression...${RESET}\n\n"
for t in "${TOOLS[@]}"; do
    rm -f "$PREFIX/bin/$t" && printf "  ${GREEN}✓${RESET}  $t\n"
done
rm -f "$HOME/.github_config"   && printf "  ${GREEN}✓${RESET}  ~/.github_config\n"
rm -f "$HOME/.github_accounts" && printf "  ${GREEN}✓${RESET}  ~/.github_accounts\n"
printf "\n${GREEN}${BOLD}  ✅  Désinstallation terminée. À bientôt !${RESET}\n\n"
EOF
deploy_tool "gituninstall" "$T"

# ── githelp ────────────────────────────────────────────────
T=$(mktemp); cat << 'EOF' > "$T"
#!/bin/bash
GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; MAGENTA='\033[0;35m'; BOLD='\033[1m'; RESET='\033[0m'
source "$HOME/.github_config" 2>/dev/null
CURRENT_USER="${USERNAME:-non connecté}"
printf "\n"
printf "${CYAN}${BOLD}╔══════════════════════════════════════════════════════════╗${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}🛠️   BOÎTE À OUTILS GITHUB — Termux Edition${RESET}             ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${CYAN}  👤  Compte actif : ${BOLD}$CURRENT_USER${RESET}\n"
printf "${CYAN}${BOLD}╠══════════════════════════════════════════════════════════╣${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${GREEN}${BOLD}📤  gitup${RESET}        Uploader un dossier/fichier.           ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}📥  gitget${RESET}       Télécharger (ZIP ou Clone).            ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${CYAN}${BOLD}📋  gitlist${RESET}      Lister vos dépôts GitHub.               ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${GREEN}${BOLD}🚀  gitpush${RESET}      Pousser les modifications d'un clone.  ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${RED}${BOLD}🗑️   gitdel${RESET}       Supprimer un dépôt définitivement.     ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${MAGENTA}${BOLD}☁️   cspace${RESET}       Créer/rejoindre un Codespace.         ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}🔀  gitswitch${RESET}    Changer de compte / Ajouter un compte. ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${RED}${BOLD}💣  gituninstall${RESET} Supprimer tous les outils.              ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${GREEN}${BOLD}ℹ️   githelp${RESET}      Afficher ce menu.                       ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╠══════════════════════════════════════════════════════════╣${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}📌  gh codespace delete${RESET}  Supprimer un Codespace.        ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}🚪  exit${RESET}                 Quitter un Codespace.          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}\n\n"
EOF
deploy_tool "githelp" "$T"

# ══════════════════════════════════════════════════════════
#  ÉTAPE 3 — Stockage (seulement si nécessaire)
# ══════════════════════════════════════════════════════════

printf "\n"
if [ ! -d "/storage/emulated/0" ]; then
    print_step "Configuration de l'accès au stockage..."
    termux-setup-storage
    print_success "Stockage configuré."
else
    print_skip "Accès au stockage déjà disponible — ignoré."
fi
printf "\n"

# ══════════════════════════════════════════════════════════
#  RÉSUMÉ FINAL
# ══════════════════════════════════════════════════════════

printf "${CYAN}${BOLD}╔══════════════════════════════════════════════════════════╗${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${GREEN}${BOLD}📊  RÉSUMÉ DE L'INSTALLATION${RESET}                             ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╠══════════════════════════════════════════════════════════╣${RESET}\n"

if [ ${#STATUS_INSTALLED[@]} -gt 0 ]; then
    printf "${CYAN}${BOLD}║${RESET}  ${GREEN}${BOLD}✅  Installés    :${RESET} ${STATUS_INSTALLED[*]}\n"
fi
if [ ${#STATUS_UPDATED[@]} -gt 0 ]; then
    printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}🔄  Mis à jour   :${RESET} ${STATUS_UPDATED[*]}\n"
fi
if [ ${#STATUS_SKIPPED[@]} -gt 0 ]; then
    printf "${CYAN}${BOLD}║${RESET}  ${BLUE}[~] Déjà à jour :${RESET} ${STATUS_SKIPPED[*]}\n"
fi

printf "${CYAN}${BOLD}╠══════════════════════════════════════════════════════════╣${RESET}\n"

if [ ! -f "$HOME/.github_config" ]; then
    printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}👉  Aucun compte configuré.${RESET}                               ${CYAN}${BOLD}║${RESET}\n"
    printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}    Lancez ${BOLD}gitswitch${RESET}${YELLOW} pour ajouter votre compte GitHub.${RESET}  ${CYAN}${BOLD}║${RESET}\n"
else
    source "$HOME/.github_config" 2>/dev/null
    printf "${CYAN}${BOLD}║${RESET}  ${GREEN}${BOLD}👤  Compte actif : $USERNAME${RESET}\n"
    printf "${CYAN}${BOLD}║${RESET}  ${WHITE}${BOLD}👉  Tapez ${YELLOW}githelp${RESET}${WHITE}${BOLD} pour voir toutes vos commandes.${RESET}\n"
fi

printf "${CYAN}${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}\n\n"
