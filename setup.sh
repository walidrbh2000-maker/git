#!/bin/bash

clear

# ╔══════════════════════════════════════════════════════════╗
# ║         BANNIÈRE D'ACCUEIL - INSTALLATION GITHUB         ║
# ╚══════════════════════════════════════════════════════════╝

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
    printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}   Outils : gitup · gitdown · gitdel · gitclone · cspace${RESET}  ${CYAN}${BOLD}║${RESET}\n"
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

print_step "Installation de git, gh, openssh, zip..."
pkg install git gh openssh zip -y > /dev/null 2>&1
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
#  gitup — Uploader un dossier/fichier
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
    printf "\n\${RED}  ⚠️   Le dépôt '\$REPO_NAME' n'existe probablement pas encore.\${RESET}\n"
    read -p "\$(printf "\${CYAN}\${BOLD}  ❓  Créer le dépôt automatiquement ? (o/n) : \${RESET}")" CREATE_REPO

    if [[ "\$CREATE_REPO" == "o" || "\$CREATE_REPO" == "O" ]]; then
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

        printf "\${YELLOW}  ⏳  Création du dépôt \$VIS_TEXT sur GitHub...\${RESET}\n"
        curl -s -H "Authorization: token \$TOKEN" -d "\$JSON_PAYLOAD" https://api.github.com/user/repos > /dev/null

        printf "\${YELLOW}  🚀  Nouvelle tentative d'envoi...\${RESET}\n"
        if git push -u origin main -f > /dev/null 2>&1; then
            printf "\n\${GREEN}\${BOLD}  ✅  Succès ! Dépôt \$VIS_TEXT créé et fichiers envoyés.\${RESET}\n"
            rm -rf "\$TERMUX_PATH"
            printf "\${GREEN}  🧹  Nettoyage terminé.\${RESET}\n\n"
        else
            printf "\${RED}\${BOLD}  ❌  Échec définitif. Vérifiez votre token et vos droits.\${RESET}\n\n"
        fi
    else
        printf "\${RED}  🛑  Opération annulée par l'utilisateur.\${RESET}\n\n"
    fi
fi
EOF

# ─────────────────────────────────────────────
#  gitdown — Télécharger un dépôt en ZIP
# ─────────────────────────────────────────────
print_step "Création de la commande 'gitdown'..."

cat << EOF > $PREFIX/bin/gitdown
#!/bin/bash

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; BOLD='\033[1m'; RESET='\033[0m'

USERNAME="$USERNAME"
DOWNLOAD_DIR="/storage/emulated/0/Download"

printf "\n\${CYAN}\${BOLD}╔══════════════════════════════════════════════╗\${RESET}\n"
printf "\${CYAN}\${BOLD}║\${RESET}  \${YELLOW}\${BOLD}📥  GITHUB DOWNLOADER — Format ZIP\${RESET}          \${CYAN}\${BOLD}║\${RESET}\n"
printf "\${CYAN}\${BOLD}╚══════════════════════════════════════════════╝\${RESET}\n\n"

read -p "\$(printf "\${CYAN}\${BOLD}  🏷️   Nom du dépôt à télécharger : \${RESET}")" REPO_NAME
[ -z "\$REPO_NAME" ] && printf "\${RED}  ⚠️   Le nom ne peut pas être vide.\${RESET}\n" && exit 1

TARGET_FILE="\$DOWNLOAD_DIR/\$REPO_NAME.zip"
printf "\${YELLOW}  ⏳  Téléchargement de '\$REPO_NAME' en ZIP...\${RESET}\n"

if gh repo archive "\$USERNAME/\$REPO_NAME" --format zip --output "\$TARGET_FILE" > /dev/null 2>&1; then
    printf "\n\${GREEN}\${BOLD}  ✅  Téléchargement réussi !\${RESET}\n"
    printf "\${GREEN}  📂  Emplacement : \$TARGET_FILE\${RESET}\n\n"
else
    printf "\n\${RED}\${BOLD}  ❌  Échec. Dépôt introuvable ou accès refusé.\${RESET}\n\n"
fi
EOF

# ─────────────────────────────────────────────
#  gitclone — Cloner un dépôt avec mémoire Git
# ─────────────────────────────────────────────
print_step "Création de la commande 'gitclone'..."

cat << EOF > $PREFIX/bin/gitclone
#!/bin/bash

GREEN='\033[0;32m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; BOLD='\033[1m'; RESET='\033[0m'

USERNAME="$USERNAME"
GITHUB_DIR="/storage/emulated/0/github"

printf "\n\${CYAN}\${BOLD}╔══════════════════════════════════════════════╗\${RESET}\n"
printf "\${CYAN}\${BOLD}║\${RESET}  \${YELLOW}\${BOLD}🔄  GITHUB CLONE — Téléchargement Git complet\${RESET}  \${CYAN}\${BOLD}║\${RESET}\n"
printf "\${CYAN}\${BOLD}╚══════════════════════════════════════════════╝\${RESET}\n\n"

mkdir -p "\$GITHUB_DIR"

read -p "\$(printf "\${CYAN}\${BOLD}  🏷️   Nom du dépôt à cloner : \${RESET}")" REPO_NAME
[ -z "\$REPO_NAME" ] && printf "\${RED}  ⚠️   Le nom ne peut pas être vide.\${RESET}\n" && exit 1

TARGET_PATH="\$GITHUB_DIR/\$REPO_NAME"

if [ -d "\$TARGET_PATH" ]; then
    printf "\${YELLOW}  ⚠️   Le dossier '\$REPO_NAME' existe déjà dans '\$GITHUB_DIR'.\${RESET}\n\n"
    exit 1
fi

printf "\${YELLOW}  ⏳  Clonage de '\$REPO_NAME' dans '\$GITHUB_DIR'...\${RESET}\n"

if gh repo clone "\$USERNAME/\$REPO_NAME" "\$TARGET_PATH" > /dev/null 2>&1; then
    printf "\n\${GREEN}\${BOLD}  ✅  Clonage réussi avec mémoire Git complète !\${RESET}\n"
    printf "\${GREEN}  📂  Emplacement : \$TARGET_PATH\${RESET}\n"
    printf "\${GREEN}  💡  Conseil     : cd '\$TARGET_PATH' pour travailler dessus.\${RESET}\n\n"
else
    printf "\n\${RED}\${BOLD}  ❌  Échec du clonage. Vérifiez que le dépôt existe.\${RESET}\n\n"
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
#  githelp — Menu d'aide complet
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
printf "${CYAN}${BOLD}║${RESET}            Choix : dépôt Public 🌐 ou Privé 🔐          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${YELLOW}${BOLD}📥  gitdown${RESET}   Télécharger un dépôt en archive .ZIP.    ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}            Sauvegardé dans /storage/.../Download         ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}                                                          ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}  ${CYAN}${BOLD}🔄  gitclone${RESET}  Cloner un dépôt avec sa mémoire Git.      ${CYAN}${BOLD}║${RESET}\n"
printf "${CYAN}${BOLD}║${RESET}            Sauvegardé dans /storage/.../github/          ${CYAN}${BOLD}║${RESET}\n"
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
chmod +x $PREFIX/bin/gitdown
chmod +x $PREFIX/bin/gitclone
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
