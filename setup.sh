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
    printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}            gitdel · gitlist · cspace · githelp       ${RESET}  ${CYAN}${BOLD}║${RESET}\n"
    printf "${CYAN}${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}\n"
    printf "\n"
}

print_step() {
    printf "${BLUE}${BOLD}[•]${RESET} ${WHITE}$1${RESET}\n"
}

print_success() {
    printf "${GREEN}${BOLD}[✓]${RESET} ${GREEN}$1${RESET}\n"
}

print_error() {
    printf "${RED}${BOLD}[✗]${RESET} ${RED}$1${RESET}\n"
}

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
printf "\n"

# ══════════════════════════════════════════════════════════
#  ÉTAPE 2 — Installation des paquets
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
#  ÉTAPE 3 — Authentification GitHub
# ══════════════════════════════════════════════════════════

print_step "Connexion à GitHub avec votre token..."
echo "$TOKEN" | gh auth login --with-token
print_success "Authentification réussie."
printf "\n"

# ══════════════════════════════════════════════════════════
#  ÉTAPE 4 — Création des outils personnalisés
# ══════════════════════════════════════════════════════════

printf "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
printf "${YELLOW}${BOLD}  🛠️   Création des outils personnalisés${RESET}\n"
printf "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n\n"

# ─────────────────────────────────────────────
#  gitup
#  • Vérifie l'existence du dépôt AVANT le push
#  • Demande la visibilité dès le début si repo absent
#  • Conserve les fichiers temporaires en cas d'échec définitif
# ─────────────────────────────────────────────
print_step "Création de la commande 'gitup'..."

cat << EOF > $PREFIX/bin/gitup
#!/bin/bash

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; BOLD='\033[1m'; RESET='\033[0m'

USERNAME="$USERNAME"
EMAIL="$EMAIL"
TOKEN="$TOKEN"
BASE_DIR="/storage/emulated/0"

printf "\n\${CYAN}\${BOLD}╔══════════════════════════════════════════════╗\${RESET}\n"
printf "\${CYAN}\${BOLD}║\${RESET}  \${YELLOW}\${BOLD}📤  GITHUB UPLOADER — Mode Intelligent\${RESET}       \${CYAN}\${BOLD}║\${RESET}\n"
printf "\${CYAN}\${BOLD}╚══════════════════════════════════════════════╝\${RESET}\n\n"

while true; do
    read -p "\$(printf "\${CYAN}\${BOLD}  📂  Dossier ou fichier à uploader : \${RESET}")" USER_PATH
    [ -z "\$USER_PATH" ] && printf "\${YELLOW}  ⚠️   Le nom ne peut pas être vide.\${RESET}\n" && continue
    FULL_TARGET="\$BASE_DIR/\$USER_PATH"
    [ -e "\$FULL_TARGET" ] && break
    printf "\${RED}  ⚠️   Introuvable : '\$FULL_TARGET' n'existe pas.\${RESET}\n"
done

TARGET_NAME=\$(basename "\$FULL_TARGET")
TERMUX_PATH="\$HOME/\${TARGET_NAME}_github"

read -p "\$(printf "\${CYAN}\${BOLD}  🏷️   Nom du dépôt (vide = '\$TARGET_NAME') : \${RESET}")" REPO_NAME
REPO_NAME=\${REPO_NAME:-\$TARGET_NAME}

# — Vérification de l'existence du dépôt AVANT toute opération —
printf "\n\${YELLOW}  🔍  Vérification du dépôt '\$REPO_NAME' sur GitHub...\${RESET}\n"
HTTP_CHECK=\$(curl -s -o /dev/null -w "%{http_code}" \
    -H "Authorization: token \$TOKEN" \
    "https://api.github.com/repos/\$USERNAME/\$REPO_NAME")

if [ "\$HTTP_CHECK" != "200" ]; then
    printf "\${YELLOW}  ⚠️   Le dépôt '\$REPO_NAME' n'existe pas encore.\${RESET}\n"
    read -p "\$(printf "\${CYAN}\${BOLD}  ❓  Créer le dépôt maintenant ? (o/n) : \${RESET}")" CREATE_REPO

    if [[ "\$CREATE_REPO" != "o" && "\$CREATE_REPO" != "O" ]]; then
        printf "\${RED}  🛑  Opération annulée.\${RESET}\n\n"
        exit 1
    fi

    printf "\n\${YELLOW}\${BOLD}  🔒  Visibilité du dépôt :\${RESET}\n"
    printf "      \${GREEN}1)  🌐  Public  — Visible par tous\${RESET}\n"
    printf "      \${YELLOW}2)  🔐  Privé   — Visible par vous uniquement\${RESET}\n"
    read -p "\$(printf "\${CYAN}\${BOLD}  👉  Votre choix (1 ou 2) : \${RESET}")" VISIBILITY_CHOICE

    if [ "\$VISIBILITY_CHOICE" == "2" ]; then
        JSON_PAYLOAD="{\"name\":\"\$REPO_NAME\", \"private\":true}"
        VIS_TEXT="Privé 🔐"
    else
        JSON_PAYLOAD="{\"name\":\"\$REPO_NAME\", \"private\":false}"
        VIS_TEXT="Public 🌐"
    fi

    printf "\${YELLOW}  ⏳  Création du dépôt \$VIS_TEXT...\${RESET}\n"
    HTTP_CREATE=\$(curl -s -o /dev/null -w "%{http_code}" \
        -H "Authorization: token \$TOKEN" \
        -d "\$JSON_PAYLOAD" \
        https://api.github.com/user/repos)

    if [ "\$HTTP_CREATE" != "201" ]; then
        printf "\${RED}\${BOLD}  ❌  Impossible de créer le dépôt. Code : \$HTTP_CREATE\${RESET}\n\n"
        exit 1
    fi
    printf "\${GREEN}  ✅  Dépôt \$VIS_TEXT créé avec succès.\${RESET}\n"
else
    printf "\${GREEN}  ✅  Dépôt trouvé — upload direct.\${RESET}\n"
fi

# — Préparation des fichiers —
printf "\n\${YELLOW}  ⏳  Préparation des fichiers...\${RESET}\n"
rm -rf "\$TERMUX_PATH"

if [ -d "\$FULL_TARGET" ]; then
    cp -r "\$FULL_TARGET" "\$TERMUX_PATH"
else
    mkdir -p "\$TERMUX_PATH"
    cp "\$FULL_TARGET" "\$TERMUX_PATH/"
fi

printf "\${YELLOW}  ⚙️   Initialisation de Git...\${RESET}\n"
cd "\$TERMUX_PATH" || exit
git init > /dev/null 2>&1
git config user.name "\$USERNAME"
git config user.email "\$EMAIL"
git add .
git commit -m "Upload automatique via gitup" > /dev/null 2>&1
git branch -M main
git remote add origin "https://\${TOKEN}@github.com/\${USERNAME}/\${REPO_NAME}.git"

printf "\${YELLOW}  🚀  Upload de '\$TARGET_NAME' vers GitHub...\${RESET}\n"

if git push -u origin main -f 2>/dev/null; then
    printf "\n\${GREEN}\${BOLD}  ✅  Succès ! '\$TARGET_NAME' → dépôt '\$REPO_NAME'.\${RESET}\n"
    rm -rf "\$TERMUX_PATH"
    printf "\${GREEN}  🧹  Fichiers temporaires supprimés.\${RESET}\n\n"
else
    printf "\n\${RED}\${BOLD}  ❌  Échec de l'upload.\${RESET}\n"
    printf "\${YELLOW}  💾  Fichiers temporaires conservés pour vérification :\${RESET}\n"
    printf "\${YELLOW}      📂  \$TERMUX_PATH\${RESET}\n\n"
fi
EOF

# ─────────────────────────────────────────────
#  gitget — remplace gitdown + gitclone
#  • Mode 1 : ZIP
#  • Mode 2 : Clone Git complet
# ─────────────────────────────────────────────
print_step "Création de la commande 'gitget'..."

cat << EOF > $PREFIX/bin/gitget
#!/bin/bash

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; BOLD='\033[1m'; RESET='\033[0m'

USERNAME="$USERNAME"
DOWNLOAD_DIR="/storage/emulated/0/Download"
GITHUB_DIR="/storage/emulated/0/github"

printf "\n\${CYAN}\${BOLD}╔══════════════════════════════════════════════╗\${RESET}\n"
printf "\${CYAN}\${BOLD}║\${RESET}  \${YELLOW}\${BOLD}📥  GITHUB GET — Téléchargement de dépôt\${RESET}     \${CYAN}\${BOLD}║\${RESET}\n"
printf "\${CYAN}\${BOLD}╚══════════════════════════════════════════════╝\${RESET}\n\n"

read -p "\$(printf "\${CYAN}\${BOLD}  🏷️   Nom du dépôt à télécharger : \${RESET}")" REPO_NAME
[ -z "\$REPO_NAME" ] && printf "\${RED}  ⚠️   Le nom ne peut pas être vide.\${RESET}\n\n" && exit 1

printf "\n\${YELLOW}\${BOLD}  📦  Mode de téléchargement :\${RESET}\n"
printf "      \${GREEN}1)  📦  ZIP    — Rapide, sans historique Git\${RESET}\n"
printf "      \${CYAN}2)  🔄  Clone  — Complet avec mémoire Git\${RESET}\n"
read -p "\$(printf "\${CYAN}\${BOLD}  👉  Votre choix (1 ou 2) : \${RESET}")" MODE_CHOICE
printf "\n"

if [[ "\$MODE_CHOICE" != "1" && "\$MODE_CHOICE" != "2" ]]; then
    printf "\${RED}  ⚠️   Choix invalide. Veuillez entrer 1 ou 2.\${RESET}\n\n"
    exit 1
fi

if [ "\$MODE_CHOICE" == "2" ]; then
    mkdir -p "\$GITHUB_DIR"
    TARGET_PATH="\$GITHUB_DIR/\$REPO_NAME"

    if [ -d "\$TARGET_PATH" ]; then
        printf "\${YELLOW}  ⚠️   Le dossier '\$REPO_NAME' existe déjà dans '\$GITHUB_DIR'.\${RESET}\n\n"
        exit 1
    fi

    printf "\${YELLOW}  ⏳  Clonage de '\$REPO_NAME' avec sa mémoire Git...\${RESET}\n"
    if gh repo clone "\$USERNAME/\$REPO_NAME" "\$TARGET_PATH" > /dev/null 2>&1; then
        printf "\n\${GREEN}\${BOLD}  ✅  Clonage réussi !\${RESET}\n"
        printf "\${GREEN}  📂  Emplacement : \$TARGET_PATH\${RESET}\n"
        printf "\${GREEN}  💡  Conseil     : cd '\$TARGET_PATH' pour travailler dessus.\${RESET}\n\n"
    else
        printf "\n\${RED}\${BOLD}  ❌  Échec du clonage. Vérifiez que le dépôt existe.\${RESET}\n\n"
    fi
else
    TARGET_FILE="\$DOWNLOAD_DIR/\$REPO_NAME.zip"
    printf "\${YELLOW}  ⏳  Téléchargement de '\$REPO_NAME' en ZIP...\${RESET}\n"
    if gh repo archive "\$USERNAME/\$REPO_NAME" --format zip --output "\$TARGET_FILE" > /dev/null 2>&1; then
        printf "\n\${GREEN}\${BOLD}  ✅  Téléchargement réussi !\${RESET}\n"
        printf "\${GREEN}  📂  Emplacement : \$TARGET_FILE\${RESET}\n\n"
    else
        printf "\n\${RED}\${BOLD}  ❌  Échec. Dépôt introuvable ou accès refusé.\${RESET}\n\n"
    fi
fi
EOF

# ─────────────────────────────────────────────
#  gitlist — Liste tous les dépôts
#  • Filtre : Tous / Publics / Privés
#  • Affiche nom + visibilité + date de mise à jour
# ─────────────────────────────────────────────
print_step "Création de la commande 'gitlist'..."

cat << EOF > $PREFIX/bin/gitlist
#!/bin/bash

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; MAGENTA='\033[0;35m'; BOLD='\033[1m'; RESET='\033[0m'

USERNAME="$USERNAME"
TOKEN="$TOKEN"

printf "\n\${CYAN}\${BOLD}╔══════════════════════════════════════════════╗\${RESET}\n"
printf "\${CYAN}\${BOLD}║\${RESET}  \${YELLOW}\${BOLD}📋  GITHUB LIST — Vos dépôts\${RESET}                 \${CYAN}\${BOLD}║\${RESET}\n"
printf "\${CYAN}\${BOLD}╚══════════════════════════════════════════════╝\${RESET}\n\n"

printf "\${YELLOW}\${BOLD}  🔒  Filtre :\${RESET}\n"
printf "      \${GREEN}1)  🌐  Tous les dépôts\${RESET}\n"
printf "      \${CYAN}2)  🌐  Publics uniquement\${RESET}\n"
printf "      \${YELLOW}3)  🔐  Privés uniquement\${RESET}\n"
read -p "\$(printf "\${CYAN}\${BOLD}  👉  Votre choix (1/2/3, vide = tous) : \${RESET}")" FILTER_CHOICE
printf "\n"

case "\$FILTER_CHOICE" in
    2) FILTER="public"  ;;
    3) FILTER="private" ;;
    *) FILTER="all"     ;;
esac

printf "\${YELLOW}  ⏳  Récupération de vos dépôts...\${RESET}\n\n"

REPOS=\$(curl -s \
    -H "Authorization: token \$TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/user/repos?per_page=100&type=\$FILTER&sort=updated")

COUNT=\$(echo "\$REPOS" | grep -o '"full_name"' | wc -l)

if [ "\$COUNT" -eq 0 ]; then
    printf "\${RED}  ❌  Aucun dépôt trouvé.\${RESET}\n\n"
    exit 0
fi

printf "\${CYAN}\${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\${RESET}\n"

echo "\$REPOS" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for r in data:
    name    = r.get('name','')
    private = r.get('private', False)
    updated = r.get('updated_at','')[:10]
    badge   = '\033[1;33m🔐 Privé \033[0m' if private else '\033[0;32m🌐 Public\033[0m'
    print(f'  {badge}  \033[1m{name:<30}\033[0m  \033[0;36mmis à jour : {updated}\033[0m')
"

printf "\${CYAN}\${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\${RESET}\n"
printf "\${GREEN}\${BOLD}  📊  Total : \$COUNT dépôt(s) trouvé(s).\${RESET}\n\n"
EOF

# ─────────────────────────────────────────────
#  gitpush — Pousser les modifications d'un clone
#  • Pour les dépôts clonés dans /github/
#  • Commit automatique + push
# ─────────────────────────────────────────────
print_step "Création de la commande 'gitpush'..."

cat << EOF > $PREFIX/bin/gitpush
#!/bin/bash

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; BOLD='\033[1m'; RESET='\033[0m'

USERNAME="$USERNAME"
EMAIL="$EMAIL"
TOKEN="$TOKEN"
GITHUB_DIR="/storage/emulated/0/github"

printf "\n\${CYAN}\${BOLD}╔══════════════════════════════════════════════╗\${RESET}\n"
printf "\${CYAN}\${BOLD}║\${RESET}  \${YELLOW}\${BOLD}🚀  GITHUB PUSH — Envoi des modifications\${RESET}     \${CYAN}\${BOLD}║\${RESET}\n"
printf "\${CYAN}\${BOLD}╚══════════════════════════════════════════════╝\${RESET}\n\n"

# — Lister les dépôts clonés disponibles —
if [ ! -d "\$GITHUB_DIR" ] || [ -z "\$(ls -A "\$GITHUB_DIR" 2>/dev/null)" ]; then
    printf "\${RED}  ❌  Aucun dépôt cloné trouvé dans '\$GITHUB_DIR'.\${RESET}\n"
    printf "\${YELLOW}  💡  Conseil : utilisez 'gitget' mode 2 pour cloner un dépôt.\${RESET}\n\n"
    exit 1
fi

printf "\${YELLOW}\${BOLD}  📂  Dépôts disponibles dans '\$GITHUB_DIR' :\${RESET}\n"
INDEX=1
REPOS_LIST=()
for DIR in "\$GITHUB_DIR"/*/; do
    REPO_NAME=\$(basename "\$DIR")
    REPOS_LIST+=("\$REPO_NAME")
    printf "      \${GREEN}\$INDEX)  \$REPO_NAME\${RESET}\n"
    ((INDEX++))
done
printf "\n"

read -p "\$(printf "\${CYAN}\${BOLD}  👉  Numéro du dépôt à pousser : \${RESET}")" CHOICE

if ! [[ "\$CHOICE" =~ ^[0-9]+\$ ]] || [ "\$CHOICE" -lt 1 ] || [ "\$CHOICE" -gt "\${#REPOS_LIST[@]}" ]; then
    printf "\${RED}  ⚠️   Choix invalide.\${RESET}\n\n"
    exit 1
fi

SELECTED_REPO="\${REPOS_LIST[\$((CHOICE-1))]}"
TARGET_PATH="\$GITHUB_DIR/\$SELECTED_REPO"

read -p "\$(printf "\${CYAN}\${BOLD}  📝  Message de commit (vide = 'Mise à jour automatique') : \${RESET}")" COMMIT_MSG
COMMIT_MSG=\${COMMIT_MSG:-"Mise à jour automatique via gitpush"}

printf "\n\${YELLOW}  ⚙️   Préparation du commit...\${RESET}\n"
cd "\$TARGET_PATH" || exit

git config user.name "\$USERNAME"
git config user.email "\$EMAIL"

# Mise à jour de l'URL remote avec le token
REPO_URL="https://\${TOKEN}@github.com/\${USERNAME}/\${SELECTED_REPO}.git"
git remote set-url origin "\$REPO_URL" > /dev/null 2>&1

git add .
CHANGES=\$(git status --porcelain)

if [ -z "\$CHANGES" ]; then
    printf "\${YELLOW}  ℹ️   Aucune modification détectée — dépôt déjà à jour.\${RESET}\n\n"
    exit 0
fi

git commit -m "\$COMMIT_MSG" > /dev/null 2>&1
printf "\${YELLOW}  🚀  Envoi des modifications vers GitHub...\${RESET}\n"

if git push origin main 2>/dev/null || git push origin master 2>/dev/null; then
    printf "\n\${GREEN}\${BOLD}  ✅  Modifications envoyées avec succès !\${RESET}\n"
    printf "\${GREEN}  📦  Dépôt : '\$SELECTED_REPO'\${RESET}\n"
    printf "\${GREEN}  💬  Commit : '\$COMMIT_MSG'\${RESET}\n\n"
else
    printf "\n\${RED}\${BOLD}  ❌  Échec du push. Vérifiez vos droits sur ce dépôt.\${RESET}\n\n"
fi
EOF

# ─────────────────────────────────────────────
#  gitdel — Supprimer un dépôt GitHub
# ─────────────────────────────────────────────
print_step "Création de la commande 'gitdel'..."

cat << EOF > $PREFIX/bin/gitdel
#!/bin/bash

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; BOLD='\033[1m'; RESET='\033[0m'

USERNAME="$USERNAME"
TOKEN="$TOKEN"

printf "\n\${CYAN}\${BOLD}╔══════════════════════════════════════════════╗\${RESET}\n"
printf "\${CYAN}\${BOLD}║\${RESET}  \${RED}\${BOLD}🗑️   GITHUB DELETE — Suppression de dépôt\${RESET}    \${CYAN}\${BOLD}║\${RESET}\n"
printf "\${CYAN}\${BOLD}╚══════════════════════════════════════════════╝\${RESET}\n\n"

printf "\${YELLOW}  💡  Conseil : tapez 'gitlist' pour voir vos dépôts.\${RESET}\n\n"

read -p "\$(printf "\${CYAN}\${BOLD}  🏷️   Nom du dépôt à supprimer : \${RESET}")" REPO_NAME
[ -z "\$REPO_NAME" ] && exit 1

printf "\n\${RED}\${BOLD}  ⚠️   ATTENTION : Cette action est IRRÉVERSIBLE !\${RESET}\n"
read -p "\$(printf "\${YELLOW}\${BOLD}  ❓  Retapez '\$REPO_NAME' pour confirmer : \${RESET}")" CONFIRM_NAME

if [ "\$CONFIRM_NAME" != "\$REPO_NAME" ]; then
    printf "\${GREEN}  🛑  Suppression annulée — les noms ne correspondent pas.\${RESET}\n\n"
    exit 1
fi

printf "\${YELLOW}  ⏳  Suppression en cours...\${RESET}\n"
HTTP_STATUS=\$(curl -s -o /dev/null -w "%{http_code}" -X DELETE \
    -H "Authorization: token \$TOKEN" \
    "https://api.github.com/repos/\$USERNAME/\$REPO_NAME")

if [ "\$HTTP_STATUS" -eq 204 ]; then
    printf "\n\${GREEN}\${BOLD}  ✅  Dépôt '\$REPO_NAME' supprimé avec succès.\${RESET}\n\n"
else
    printf "\n\${RED}\${BOLD}  ❌  Échec. Code HTTP retourné : \$HTTP_STATUS\${RESET}\n\n"
fi
EOF

# ─────────────────────────────────────────────
#  cspace — Gérer les GitHub Codespaces
# ─────────────────────────────────────────────
print_step "Création de la commande 'cspace'..."

cat << EOF > $PREFIX/bin/cspace
#!/bin/bash

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; BOLD='\033[1m'; RESET='\033[0m'

USERNAME="$USERNAME"

printf "\n\${CYAN}\${BOLD}╔══════════════════════════════════════════════╗\${RESET}\n"
printf "\${CYAN}\${BOLD}║\${RESET}  \${YELLOW}\${BOLD}☁️   GITHUB CODESPACES — Serveur Cloud\${RESET}       \${CYAN}\${BOLD}║\${RESET}\n"
printf "\${CYAN}\${BOLD}╚══════════════════════════════════════════════╝\${RESET}\n\n"

read -p "\$(printf "\${CYAN}\${BOLD}  🏷️   Dépôt pour créer un espace (vide = connexion) : \${RESET}")" REPO_NAME

if [ -z "\$REPO_NAME" ]; then
    printf "\${YELLOW}  🔗  Connexion à votre Codespace existant...\${RESET}\n"
    gh codespace ssh
else
    printf "\${YELLOW}  ⏳  Création d'un serveur Cloud pour '\$REPO_NAME'...\${RESET}\n"
    if gh codespace create -R "\$USERNAME/\$REPO_NAME"; then
        printf "\n\${GREEN}\${BOLD}  ✅  Serveur créé ! Tapez 'cspace' pour vous y connecter.\${RESET}\n\n"
    else
        printf "\n\${RED}\${BOLD}  ❌  Échec de création du Codespace.\${RESET}\n\n"
    fi
fi
EOF

# ─────────────────────────────────────────────
#  githelp — Menu d'aide complet mis à jour
# ─────────────────────────────────────────────
print_step "Création de la commande 'githelp'..."

cat << 'EOF' > $PREFIX/bin/githelp
#!/bin/bash

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; MAGENTA='\033[0;35m'; BOLD='\033[1m'; RESET='\033[0m'

printf "\n"
printf "${CYAN}${BOLD}╔══════════════════════════════════════════════════════════╗${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}🛠️   BOÎTE À OUTILS GITHUB — Termux Edition${RESET}             ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╠══════════════════════════════════════════════════════════╣${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${GREEN}${BOLD}📤  gitup${RESET}     Uploader un dossier/fichier vers GitHub.  ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}            Vérifie le dépôt avant l'envoi.              ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}            Choix : Public 🌐 ou Privé 🔐               ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}📥  gitget${RESET}    Télécharger un dépôt GitHub.             ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}            Mode 1 : 📦 ZIP   (rapide, sans Git)         ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}            Mode 2 : 🔄 Clone (complet avec Git)         ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${CYAN}${BOLD}📋  gitlist${RESET}   Afficher tous vos dépôts GitHub.          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}            Filtrage : Tous / Publics 🌐 / Privés 🔐     ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${GREEN}${BOLD}🚀  gitpush${RESET}   Pousser les modifications d'un clone.     ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}            Sélection dans la liste des clones locaux.   ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}            Commit automatique + push vers GitHub.       ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${RED}${BOLD}🗑️   gitdel${RESET}    Supprimer un dépôt DÉFINITIVEMENT.        ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}            Double confirmation requise pour sécurité.    ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${MAGENTA}${BOLD}☁️   cspace${RESET}    Créer ou rejoindre un GitHub Codespace.  ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}            Serveur cloud pour coder à distance.          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${GREEN}${BOLD}ℹ️   githelp${RESET}   Afficher ce menu d'aide.                  ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╠══════════════════════════════════════════════════════════╣${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}📌  COMMANDES GITHUB UTILES${RESET}                             ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╠══════════════════════════════════════════════════════════╣${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${RED}${BOLD}🗑️   gh codespace delete${RESET}  Supprimer un serveur Cloud.    ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}🚪  exit${RESET}                 Quitter un serveur Codespace.  ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}\n"
printf "\n"
EOF

# ══════════════════════════════════════════════════════════
#  ÉTAPE 5 — Attribution des permissions
# ══════════════════════════════════════════════════════════

print_step "Attribution des permissions d'exécution..."
chmod +x $PREFIX/bin/gitup
chmod +x $PREFIX/bin/gitget
chmod +x $PREFIX/bin/gitlist
chmod +x $PREFIX/bin/gitpush
chmod +x $PREFIX/bin/gitdel
chmod +x $PREFIX/bin/cspace
chmod +x $PREFIX/bin/githelp
print_success "Permissions accordées à toutes les commandes."
printf "\n"

# ══════════════════════════════════════════════════════════
#  ÉTAPE 6 — Configuration du stockage
# ══════════════════════════════════════════════════════════

print_step "Configuration de l'accès au stockage Termux..."
termux-setup-storage
print_success "Stockage configuré."
printf "\n"

# ══════════════════════════════════════════════════════════
#  BANNIÈRE DE FIN
# ══════════════════════════════════════════════════════════

printf "${CYAN}${BOLD}╔══════════════════════════════════════════════════════════╗${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${GREEN}${BOLD}🎉  INSTALLATION TERMINÉE AVEC SUCCÈS !${RESET}               ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${WHITE}${BOLD}👉  Tapez  ${YELLOW}githelp${RESET}${WHITE}${BOLD}  pour voir toutes vos commandes.${RESET}  ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}\n"
printf "\n"
