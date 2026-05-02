#!/bin/bash

clear

# ═══════════════════════════════════════════════════════════
#  COLORS
# ═══════════════════════════════════════════════════════════
GREEN='\033[0;32m';   CYAN='\033[0;36m';    YELLOW='\033[1;33m'
RED='\033[0;31m';     BLUE='\033[0;34m';    MAGENTA='\033[0;35m'
WHITE='\033[1;37m';   BOLD='\033[1m';       RESET='\033[0m'

# ═══════════════════════════════════════════════════════════
#  PATHS
# ═══════════════════════════════════════════════════════════
CONFIG_FILE="$HOME/.github_config"
ACCOUNTS_FILE="$HOME/.github_accounts"

# ═══════════════════════════════════════════════════════════
#  COUNTERS
# ═══════════════════════════════════════════════════════════
TOOLS_INSTALLED=0
TOOLS_UPDATED=0
TOOLS_SKIPPED=0

# ═══════════════════════════════════════════════════════════
#  HELPERS
# ═══════════════════════════════════════════════════════════
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
    printf "${CYAN}${BOLD}║${RESET}  ${GREEN}${BOLD}🚀  MISE À JOUR INTELLIGENTE — GITHUB TOOLS  🚀${RESET}        ${CYAN}${BOLD}║${RESET}\n"
    printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}   gitup · gitget · gitlist · gitpush · gitdel        ${RESET}  ${CYAN}${BOLD}║${RESET}\n"
    printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}      cspace · gitswitch · gituninstall              ${RESET}    ${CYAN}${BOLD}║${RESET}\n"
    printf "${CYAN}${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}\n"
    printf "\n"
}

print_step()    { printf "${BLUE}${BOLD}  [•]${RESET} ${WHITE}$1${RESET}\n"; }
print_success() { printf "${GREEN}${BOLD}  [✓]${RESET} ${GREEN}$1${RESET}\n"; }
print_update()  { printf "${CYAN}${BOLD}  [↑]${RESET} ${CYAN}$1${RESET}\n"; }
print_skip()    { printf "${YELLOW}${BOLD}  [~]${RESET} ${YELLOW}$1${RESET}\n"; }
print_error()   { printf "${RED}${BOLD}  [✗]${RESET} ${RED}$1${RESET}\n"; }
print_info()    { printf "${MAGENTA}${BOLD}  [i]${RESET} ${MAGENTA}$1${RESET}\n"; }

# ── Compares a temp file with the installed version; installs or updates only if needed ──
install_or_update() {
    local name="$1"
    local src="$2"
    local target="$PREFIX/bin/$name"

    if [ ! -f "$target" ]; then
        cp "$src" "$target" && chmod +x "$target"
        print_success "'$name' installé."
        TOOLS_INSTALLED=$((TOOLS_INSTALLED + 1))
    elif ! cmp -s "$src" "$target"; then
        cp "$src" "$target" && chmod +x "$target"
        print_update "'$name' mis à jour."
        TOOLS_UPDATED=$((TOOLS_UPDATED + 1))
    else
        print_skip "'$name' déjà à jour — ignoré."
        TOOLS_SKIPPED=$((TOOLS_SKIPPED + 1))
    fi
}

# ── Returns 0 if at least one account exists in the accounts file ──
has_accounts() {
    [ -f "$ACCOUNTS_FILE" ] && grep -qv '^[[:space:]]*$' "$ACCOUNTS_FILE" 2>/dev/null
}

# ═══════════════════════════════════════════════════════════
print_banner

# ═══════════════════════════════════════════════════════════
#  STEP 1 — DEPENDENCIES (no update / no upgrade)
# ═══════════════════════════════════════════════════════════
printf "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
printf "${YELLOW}${BOLD}  📦  Vérification des dépendances${RESET}\n"
printf "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n\n"

MISSING_PKGS=()
command -v git     &>/dev/null || MISSING_PKGS+=("git")
command -v gh      &>/dev/null || MISSING_PKGS+=("gh")
command -v ssh     &>/dev/null || MISSING_PKGS+=("openssh")
command -v zip     &>/dev/null || MISSING_PKGS+=("zip")
command -v python3 &>/dev/null || MISSING_PKGS+=("python3")

if [ ${#MISSING_PKGS[@]} -eq 0 ]; then
    print_skip "Toutes les dépendances sont déjà installées."
else
    print_step "Installation des paquets manquants : ${MISSING_PKGS[*]}..."
    pkg install "${MISSING_PKGS[@]}" -y > /dev/null 2>&1 \
        && print_success "Paquets installés avec succès." \
        || { print_error "Échec d'installation de certains paquets."; }
fi
printf "\n"

# ═══════════════════════════════════════════════════════════
#  STEP 2 — ACCOUNT MANAGEMENT
# ═══════════════════════════════════════════════════════════
printf "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
printf "${YELLOW}${BOLD}  👤  Gestion du compte GitHub${RESET}\n"
printf "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n\n"

if has_accounts; then
    # ── Accounts already exist — keep everything ──
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
        print_skip "Comptes existants conservés. Compte actif : ${BOLD}${USERNAME}${RESET}"
    else
        # Accounts file exists but no active config — activate the first account
        IFS='|' read -r _U _E _T _L <<< "$(grep -v '^[[:space:]]*$' "$ACCOUNTS_FILE" | head -1)"
        {
            printf 'USERNAME="%s"\n' "$_U"
            printf 'EMAIL="%s"\n'    "$_E"
            printf 'TOKEN="%s"\n'    "$_T"
        } > "$CONFIG_FILE"
        chmod 600 "$CONFIG_FILE"
        print_info "Config absente — compte '${_U}' défini comme actif."
    fi
else
    # ── No accounts found — prompt the user once ──
    printf "${YELLOW}  Aucun compte GitHub trouvé. Veuillez en configurer un.${RESET}\n\n"

    while true; do
        read -p "$(printf "${CYAN}${BOLD}  👤  Nom d'utilisateur GitHub        : ${RESET}")" USERNAME
        [ -n "$USERNAME" ] && break
        printf "${YELLOW}  ⚠️   Le nom d'utilisateur est obligatoire.${RESET}\n"
    done

    read -p "$(printf "${CYAN}${BOLD}  📧  Adresse e-mail GitHub           : ${RESET}")" EMAIL

    while true; do
        read -p "$(printf "${CYAN}${BOLD}  🔑  Token d'accès (Classic)         : ${RESET}")" TOKEN
        [ -n "$TOKEN" ] && break
        printf "${YELLOW}  ⚠️   Le token est obligatoire.${RESET}\n"
    done

    read -p "$(printf "${CYAN}${BOLD}  🏷️   Label du compte (ex: Perso, Pro) : ${RESET}")" LABEL
    LABEL="${LABEL:-$USERNAME}"
    printf "\n"

    # Validate token before saving anything
    print_step "Vérification du token GitHub..."
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
        -H "Authorization: token $TOKEN" \
        "https://api.github.com/user")

    if [ "$HTTP_CODE" != "200" ]; then
        print_error "Token invalide ou refusé (code HTTP : $HTTP_CODE). Abandon."
        exit 1
    fi
    print_success "Token valide."
    printf "\n"

    # Save active config
    {
        printf 'USERNAME="%s"\n' "$USERNAME"
        printf 'EMAIL="%s"\n'    "$EMAIL"
        printf 'TOKEN="%s"\n'    "$TOKEN"
    } > "$CONFIG_FILE"
    chmod 600 "$CONFIG_FILE"

    # Save to accounts registry
    touch "$ACCOUNTS_FILE"
    chmod 600 "$ACCOUNTS_FILE"
    echo "${USERNAME}|${EMAIL}|${TOKEN}|${LABEL}" >> "$ACCOUNTS_FILE"

    # Authenticate gh CLI
    echo "$TOKEN" | gh auth login --with-token 2>/dev/null \
        && print_success "Authentification gh CLI réussie." \
        || print_error "Authentification gh CLI échouée (non bloquant)."

    print_success "Compte '${USERNAME}' enregistré et activé."
fi
printf "\n"

# ═══════════════════════════════════════════════════════════
#  STEP 3 — INSTALL / UPDATE TOOLS
# ═══════════════════════════════════════════════════════════
printf "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
printf "${YELLOW}${BOLD}  🛠️   Installation / Mise à jour des outils${RESET}\n"
printf "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n\n"

# ─────────────────────────────────────────────
#  gitup
# ─────────────────────────────────────────────
_T=$(mktemp); cat << 'TOOLEOF' > "$_T"
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

if [ -d "$FULL_TARGET" ]; then
    cp -r "$FULL_TARGET" "$TERMUX_PATH"
else
    mkdir -p "$TERMUX_PATH"
    cp "$FULL_TARGET" "$TERMUX_PATH/"
fi

printf "${YELLOW}  ⚙️   Initialisation de Git...${RESET}\n"
cd "$TERMUX_PATH" || exit
git init > /dev/null 2>&1
git config user.name  "$USERNAME"
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
TOOLEOF
install_or_update "gitup" "$_T"; rm -f "$_T"

# ─────────────────────────────────────────────
#  gitget
# ─────────────────────────────────────────────
_T=$(mktemp); cat << 'TOOLEOF' > "$_T"
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
TOOLEOF
install_or_update "gitget" "$_T"; rm -f "$_T"

# ─────────────────────────────────────────────
#  gitlist
# ─────────────────────────────────────────────
_T=$(mktemp); cat << 'TOOLEOF' > "$_T"
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
TOOLEOF
install_or_update "gitlist" "$_T"; rm -f "$_T"

# ─────────────────────────────────────────────
#  gitpush
# ─────────────────────────────────────────────
_T=$(mktemp); cat << 'TOOLEOF' > "$_T"
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
COMMIT_MSG="${COMMIT_MSG:-Mise à jour automatique via gitpush}"

printf "\n${YELLOW}  ⚙️   Préparation du commit...${RESET}\n"
cd "$TARGET_PATH" || exit
git config user.name  "$USERNAME"
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
TOOLEOF
install_or_update "gitpush" "$_T"; rm -f "$_T"

# ─────────────────────────────────────────────
#  gitdel
# ─────────────────────────────────────────────
_T=$(mktemp); cat << 'TOOLEOF' > "$_T"
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
TOOLEOF
install_or_update "gitdel" "$_T"; rm -f "$_T"

# ─────────────────────────────────────────────
#  cspace
# ─────────────────────────────────────────────
_T=$(mktemp); cat << 'TOOLEOF' > "$_T"
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
TOOLEOF
install_or_update "cspace" "$_T"; rm -f "$_T"

# ─────────────────────────────────────────────
#  gitswitch
# ─────────────────────────────────────────────
_T=$(mktemp); cat << 'TOOLEOF' > "$_T"
#!/bin/bash

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; MAGENTA='\033[0;35m'; BOLD='\033[1m'; RESET='\033[0m'

CONFIG_FILE="$HOME/.github_config"
ACCOUNTS_FILE="$HOME/.github_accounts"

source "$CONFIG_FILE" 2>/dev/null
CURRENT_USER="${USERNAME:-inconnu}"

printf "\n${CYAN}${BOLD}╔══════════════════════════════════════════════╗${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}🔀  GITHUB SWITCH — Changer de compte${RESET}       ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╚══════════════════════════════════════════════╝${RESET}\n\n"
printf "${CYAN}  👤  Compte actif : ${BOLD}$CURRENT_USER${RESET}\n\n"

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

# ── Add new account ──
if [[ "$CHOICE" == "+" ]]; then
    printf "\n${YELLOW}${BOLD}  ➕  Nouveau compte GitHub${RESET}\n\n"

    while true; do
        read -p "$(printf "${CYAN}${BOLD}  👤  Nom d'utilisateur : ${RESET}")" NEW_USER
        [ -n "$NEW_USER" ] && break
        printf "${YELLOW}  ⚠️   Obligatoire.${RESET}\n"
    done
    read -p "$(printf "${CYAN}${BOLD}  📧  Adresse e-mail    : ${RESET}")" NEW_EMAIL
    while true; do
        read -p "$(printf "${CYAN}${BOLD}  🔑  Token d'accès     : ${RESET}")" NEW_TOKEN
        [ -n "$NEW_TOKEN" ] && break
        printf "${YELLOW}  ⚠️   Obligatoire.${RESET}\n"
    done
    read -p "$(printf "${CYAN}${BOLD}  🏷️   Label du compte   : ${RESET}")" NEW_LABEL
    NEW_LABEL="${NEW_LABEL:-$NEW_USER}"

    printf "${YELLOW}  🔍  Vérification du token...${RESET}\n"
    HTTP_CHECK=$(curl -s -o /dev/null -w "%{http_code}" \
        -H "Authorization: token $NEW_TOKEN" \
        "https://api.github.com/user")

    if [ "$HTTP_CHECK" != "200" ]; then
        printf "${RED}${BOLD}  ❌  Token invalide (code $HTTP_CHECK). Abandon.${RESET}\n\n"
        exit 1
    fi
    printf "${GREEN}  ✅  Token valide.${RESET}\n\n"

    # Update or append in accounts file
    touch "$ACCOUNTS_FILE"
    if grep -q "^${NEW_USER}|" "$ACCOUNTS_FILE" 2>/dev/null; then
        # Replace existing entry for this user
        local_tmp=$(mktemp)
        grep -v "^${NEW_USER}|" "$ACCOUNTS_FILE" > "$local_tmp"
        echo "${NEW_USER}|${NEW_EMAIL}|${NEW_TOKEN}|${NEW_LABEL}" >> "$local_tmp"
        mv "$local_tmp" "$ACCOUNTS_FILE"
        printf "${CYAN}  🔄  Compte '${NEW_USER}' mis à jour dans le registre.${RESET}\n"
    else
        echo "${NEW_USER}|${NEW_EMAIL}|${NEW_TOKEN}|${NEW_LABEL}" >> "$ACCOUNTS_FILE"
        printf "${GREEN}  ✅  Compte '${NEW_USER}' ajouté au registre.${RESET}\n"
    fi
    chmod 600 "$ACCOUNTS_FILE"

    SEL_USER="$NEW_USER"; SEL_EMAIL="$NEW_EMAIL"; SEL_TOKEN="$NEW_TOKEN"

# ── Select existing account ──
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

# ── Apply selected account ──
printf "${YELLOW}  ⏳  Activation du compte '$SEL_USER'...${RESET}\n"

{
    printf 'USERNAME="%s"\n' "$SEL_USER"
    printf 'EMAIL="%s"\n'    "$SEL_EMAIL"
    printf 'TOKEN="%s"\n'    "$SEL_TOKEN"
} > "$CONFIG_FILE"
chmod 600 "$CONFIG_FILE"

echo "$SEL_TOKEN" | gh auth login --with-token 2>/dev/null
git config --global user.name  "$SEL_USER"
git config --global user.email "$SEL_EMAIL"

printf "\n${GREEN}${BOLD}  ✅  Compte activé avec succès !${RESET}\n"
printf "${GREEN}  👤  Désormais connecté en tant que : ${BOLD}$SEL_USER${RESET}\n\n"
TOOLEOF
install_or_update "gitswitch" "$_T"; rm -f "$_T"

# ─────────────────────────────────────────────
#  gituninstall
# ─────────────────────────────────────────────
_T=$(mktemp); cat << 'TOOLEOF' > "$_T"
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

rm -f "$HOME/.github_config"   && printf "  ${GREEN}✓${RESET}  ~/.github_config supprimé\n"
rm -f "$HOME/.github_accounts" && printf "  ${GREEN}✓${RESET}  ~/.github_accounts supprimé\n"

printf "\n${GREEN}${BOLD}  ✅  Désinstallation terminée. À bientôt !${RESET}\n\n"
TOOLEOF
install_or_update "gituninstall" "$_T"; rm -f "$_T"

# ─────────────────────────────────────────────
#  githelp
# ─────────────────────────────────────────────
_T=$(mktemp); cat << 'TOOLEOF' > "$_T"
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
printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}🔀  gitswitch${RESET}    Changer / Ajouter un compte GitHub.     ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${RED}${BOLD}💣  gituninstall${RESET} Supprimer tous les outils.               ${CYAN}${BOLD}║${RESET}\n"
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
TOOLEOF
install_or_update "githelp" "$_T"; rm -f "$_T"

# ═══════════════════════════════════════════════════════════
#  STEP 4 — STORAGE (only if not already configured)
# ═══════════════════════════════════════════════════════════
if [ ! -d "/storage/emulated/0" ]; then
    printf "\n"
    print_step "Configuration de l'accès au stockage Termux..."
    termux-setup-storage
    print_success "Stockage configuré."
fi

# ═══════════════════════════════════════════════════════════
#  SUMMARY
# ═══════════════════════════════════════════════════════════
printf "\n${CYAN}${BOLD}╔══════════════════════════════════════════════════════════╗${RESET}\n"

if [ "$TOOLS_INSTALLED" -eq 0 ] && [ "$TOOLS_UPDATED" -eq 0 ]; then
    printf "${CYAN}${BOLD}║${RESET}  ${GREEN}${BOLD}✅  Tout est déjà à jour — aucune modification.${RESET}          ${CYAN}${BOLD}║${RESET}\n"
else
    [ "$TOOLS_INSTALLED" -gt 0 ] && \
        printf "${CYAN}${BOLD}║${RESET}  ${GREEN}${BOLD}✅  $TOOLS_INSTALLED outil(s) nouvellement installé(s).${RESET}              ${CYAN}${BOLD}║${RESET}\n"
    [ "$TOOLS_UPDATED" -gt 0 ] && \
        printf "${CYAN}${BOLD}║${RESET}  ${CYAN}${BOLD}🔄  $TOOLS_UPDATED outil(s) mis à jour.${RESET}                              ${CYAN}${BOLD}║${RESET}\n"
    [ "$TOOLS_SKIPPED" -gt 0 ] && \
        printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}⏭️   $TOOLS_SKIPPED outil(s) inchangé(s) — ignoré(s).${RESET}              ${CYAN}${BOLD}║${RESET}\n"
fi

printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${WHITE}${BOLD}👉  Tapez  ${YELLOW}githelp${RESET}${WHITE}${BOLD}  pour voir toutes vos commandes.${RESET}  ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}\n\n"
