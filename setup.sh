#!/bin/bash

clear
echo "================================================="
echo "   🚀 INSTALLATION DE L'ENVIRONNEMENT GITHUB 🚀"
echo "================================================="
echo ""

# 1. طلب البيانات الأساسية
read -p "👤 Entrez votre nom d'utilisateur GitHub : " USERNAME
read -p "📧 Entrez votre email GitHub : " EMAIL
read -p "🔑 Entrez votre Token (Classic) : " TOKEN

echo ""
echo "⏳ Installation des paquets nécessaires (git, gh, openssh, zip)..."
pkg update -y && pkg upgrade -y
pkg install git gh openssh zip -y > /dev/null 2>&1

echo "⚙️ Connexion à GitHub..."
echo "$TOKEN" | gh auth login --with-token

echo "🛠️ Création de vos outils personnalisés..."

# 2. أداة gitup (النسخة الذكية + اختيار نوع المستودع)
cat << EOF > $PREFIX/bin/gitup
#!/bin/bash
USERNAME="$USERNAME"
EMAIL="$EMAIL"
TOKEN="$TOKEN"
BASE_DIR="/storage/emulated/0"

echo "------------------------------------------------"
echo "📤 GITHUB UPLOADER (Mode Intelligent)"
echo "------------------------------------------------"

while true; do
    read -p "📂 Entrez le nom du dossier ou fichier (ex: MyGame) : " USER_PATH
    if [ -z "\$USER_PATH" ]; then
        echo "⚠️ Le nom ne peut pas être vide."
        continue
    fi
    FULL_TARGET="\$BASE_DIR/\$USER_PATH"

    if [ -e "\$FULL_TARGET" ]; then
        break
    else
        echo "⚠️ Introuvable : le chemin '\$FULL_TARGET' n'existe pas."
    fi
done

TARGET_NAME=\$(basename "\$FULL_TARGET")
TERMUX_PATH="\$HOME/\${TARGET_NAME}_github"

read -p "🏷️ Nom du dépôt (Laissez vide pour utiliser '\$TARGET_NAME') : " REPO_NAME
REPO_NAME=\${REPO_NAME:-\$TARGET_NAME}

echo "⏳ Préparation des fichiers..."
rm -rf "\$TERMUX_PATH"

if [ -d "\$FULL_TARGET" ]; then
    cp -r "\$FULL_TARGET" "\$TERMUX_PATH"
else
    mkdir -p "\$TERMUX_PATH"
    cp "\$FULL_TARGET" "\$TERMUX_PATH/"
fi

echo "⚙️ Initialisation de Git..."
cd "\$TERMUX_PATH" || exit
git init > /dev/null 2>&1
git config user.name "\$USERNAME"
git config user.email "\$EMAIL"
git add .
git commit -m "Upload automatique via script" > /dev/null 2>&1
git branch -M main
git remote add origin "https://\${TOKEN}@github.com/\${USERNAME}/\${REPO_NAME}.git"

echo "🚀 Upload de '\$TARGET_NAME' vers GitHub en cours..."
if git push -u origin main -f 2>/dev/null; then
    echo "------------------------------------------------"
    echo "✅ Succès ! '\$TARGET_NAME' a été envoyé vers '\$REPO_NAME'."
    rm -rf "\$TERMUX_PATH"
    echo "🧹 Nettoyage : Fichiers temporaires supprimés."
    echo "------------------------------------------------"
else
    echo "------------------------------------------------"
    echo "⚠️ Le dépôt '\$REPO_NAME' n'existe probablement pas."
    read -p "❓ Créer le dépôt '\$REPO_NAME' automatiquement ? (y/n) : " CREATE_REPO
    if [[ "\$CREATE_REPO" == "y" || "\$CREATE_REPO" == "Y" ]]; then
        echo "🔒 Visibilité du dépôt :"
        echo "   1) 🌐 Public (Visible par tous)"
        echo "   2) 🔐 Privé (Visible par vous uniquement)"
        read -p "👉 Choisissez (1 ou 2) : " VISIBILITY_CHOICE
        
        if [ "\$VISIBILITY_CHOICE" == "2" ]; then
            JSON_PAYLOAD="{\"name\":\"\$REPO_NAME\", \"private\":true}"
            VIS_TEXT="Privé 🔐"
        else
            JSON_PAYLOAD="{\"name\":\"\$REPO_NAME\", \"private\":false}"
            VIS_TEXT="Public 🌐"
        fi

        echo "⏳ Création du dépôt \$VIS_TEXT sur GitHub..."
        curl -s -H "Authorization: token \$TOKEN" -d "\$JSON_PAYLOAD" https://api.github.com/user/repos > /dev/null
        
        echo "🚀 Nouvelle tentative d'upload..."
        if git push -u origin main -f > /dev/null 2>&1; then
            echo "------------------------------------------------"
            echo "✅ Succès absolu ! Dépôt \$VIS_TEXT créé et fichiers envoyés."
            rm -rf "\$TERMUX_PATH"
            echo "🧹 Nettoyage terminé."
            echo "------------------------------------------------"
        else
            echo "❌ Échec définitif."
        fi
    else
        echo "🛑 Opération annulée."
    fi
fi
EOF

# 3. أداة gitdown (تحميل المشاريع كـ ZIP)
cat << EOF > $PREFIX/bin/gitdown
#!/bin/bash
USERNAME="$USERNAME"
DOWNLOAD_DIR="/storage/emulated/0/Download"

echo "------------------------------------------------"
echo "📥 GITHUB DOWNLOADER (Mode ZIP)"
echo "------------------------------------------------"

read -p "🏷️ Entrez le nom du dépôt à télécharger : " REPO_NAME

if [ -z "\$REPO_NAME" ]; then
    echo "⚠️ Le nom ne peut pas être vide."
    exit 1
fi

TARGET_FILE="\$DOWNLOAD_DIR/\$REPO_NAME.zip"
echo "⏳ Téléchargement de '\$REPO_NAME' en format ZIP..."

if gh repo archive "\$USERNAME/\$REPO_NAME" --format zip --output "\$TARGET_FILE" > /dev/null 2>&1; then
    echo "------------------------------------------------"
    echo "✅ Succès ! Le dépôt a été téléchargé."
    echo "📂 Emplacement : \$TARGET_FILE"
    echo "------------------------------------------------"
else
    echo "------------------------------------------------"
    echo "❌ Échec. Le dépôt '\$REPO_NAME' n'existe pas ou accès refusé."
    echo "------------------------------------------------"
fi
EOF

# 4. أداة gitdel (حذف المستودعات)
cat << EOF > $PREFIX/bin/gitdel
#!/bin/bash
USERNAME="$USERNAME"
TOKEN="$TOKEN"

echo "------------------------------------------------"
echo "🗑️ Suppression de dépôt GitHub"
echo "------------------------------------------------"
read -p "🏷️ Entrez le nom du dépôt à SUPPRIMER : " REPO_NAME
if [ -z "\$REPO_NAME" ]; then exit 1; fi

echo "⚠️ ATTENTION : Cette action est IRRÉVERSIBLE !"
read -p "❓ Tapez le nom du dépôt ('\$REPO_NAME') pour confirmer : " CONFIRM_NAME

if [ "\$CONFIRM_NAME" != "\$REPO_NAME" ]; then
    echo "🛑 Suppression annulée par sécurité."
    exit 1
fi

echo "⏳ Suppression en cours..."
HTTP_STATUS=\$(curl -s -o /dev/null -w "%{http_code}" -X DELETE -H "Authorization: token \$TOKEN" "https://api.github.com/repos/\$USERNAME/\$REPO_NAME")

if [ "\$HTTP_STATUS" -eq 204 ]; then
    echo "✅ Succès ! Dépôt supprimé."
else
    echo "❌ Échec. Code HTTP : \$HTTP_STATUS"
fi
EOF

# 5. أداة cspace (إدارة الخوادم السحابية)
cat << EOF > $PREFIX/bin/cspace
#!/bin/bash
USERNAME="$USERNAME"

echo "------------------------------------------------"
echo "☁️ Gestionnaire GitHub Codespaces"
echo "------------------------------------------------"
read -p "🏷️ Entrez le nom du dépôt pour CRÉER un espace (ou laissez vide) : " REPO_NAME

if [ -z "\$REPO_NAME" ]; then
    gh codespace ssh
else
    echo "⏳ Création d'un serveur Cloud pour '\$REPO_NAME'..."
    if gh codespace create -R "\$USERNAME/\$REPO_NAME"; then
        echo "✅ Succès ! Tapez 'cspace' pour y accéder."
    else
        echo "❌ Échec de création."
    fi
fi
EOF

# 6. أداة الدليل الشامل (githelp)
cat << 'EOF' > $PREFIX/bin/githelp
#!/bin/bash
echo "================================================="
echo "   🛠️ BOÎTE À OUTILS GITHUB (Termux) 🛠️"
echo "================================================="
echo "📌 VOS COMMANDES PERSONNALISÉES :"
echo "  🟢 gitup   : Uploader dossier/fichier vers GitHub (Public/Privé)."
echo "  📥 gitdown : Télécharger un dépôt GitHub en .ZIP."
echo "  🔴 gitdel  : Supprimer un dépôt DÉFINITIVEMENT."
echo "  ☁️ cspace  : Gérer vos serveurs cloud Codespaces."
echo "  ℹ️ githelp : Afficher ce menu d'aide."
echo "================================================="
EOF

# 7. إعطاء الصلاحيات وإعداد مساحة التخزين
chmod +x $PREFIX/bin/gitup
chmod +x $PREFIX/bin/gitdown
chmod +x $PREFIX/bin/gitdel
chmod +x $PREFIX/bin/cspace
chmod +x $PREFIX/bin/githelp

termux-setup-storage

echo ""
echo "================================================="
echo "🎉 FÉLICITATIONS ! L'ENVIRONNEMENT EST PRÊT. 🎉"
echo "👉 Tapez 'githelp' pour voir vos nouvelles commandes."
echo "================================================="
