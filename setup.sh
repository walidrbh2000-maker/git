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
echo "⏳ Installation des paquets nécessaires (git, gh, openssh)..."
pkg update -y && pkg upgrade -y
pkg install git gh openssh -y > /dev/null 2>&1

echo "⚙️ Connexion à GitHub..."
echo "$TOKEN" | gh auth login --with-token

echo "🛠️ Création de vos outils personnalisés..."

# 2. بناء أداة gitup (النسخة المحدثة مع التنظيف التلقائي)
cat << EOF > $PREFIX/bin/gitup
#!/bin/bash
USERNAME="$USERNAME"
EMAIL="$EMAIL"
TOKEN="$TOKEN"

CURRENT_DIR=\$(pwd)
FOLDER_NAME=\$(basename "\$CURRENT_DIR")
TERMUX_PATH="\$HOME/\${FOLDER_NAME}_github"

echo "------------------------------------------------"
echo "📂 Dossier cible : \$FOLDER_NAME"
echo "------------------------------------------------"
echo "💡 Astuce : Appuyez sur [Ctrl + C] pour annuler."

while true; do
    read -p "🏷️ Entrez le nom du dépôt GitHub : " REPO_NAME
    if [ -z "\$REPO_NAME" ]; then
        echo "⚠️ Le nom ne peut pas être vide."
        continue
    fi
    read -p "❓ Confirmer le dépôt '\$REPO_NAME' ? (y/n) : " CONFIRM
    if [[ "\$CONFIRM" == "y" || "\$CONFIRM" == "Y" || "\$CONFIRM" == "" ]]; then
        break
    else
        echo "🔄 Recommençons..."
    fi
done

echo "⏳ Copie des fichiers vers Termux en cours..."
rm -rf "\$TERMUX_PATH"
cp -r "\$CURRENT_DIR" "\$TERMUX_PATH"

echo "⚙️ Initialisation de Git..."
cd "\$TERMUX_PATH" || exit
git init > /dev/null 2>&1
git config user.name "\$USERNAME"
git config user.email "\$EMAIL"
git add .
git commit -m "Upload automatique via script" > /dev/null 2>&1
git branch -M main
git remote add origin "https://\${TOKEN}@github.com/\${USERNAME}/\${REPO_NAME}.git"

echo "🚀 Upload vers GitHub en cours..."
if git push -u origin main -f; then
    echo "------------------------------------------------"
    echo "✅ Succès ! Dossier (\$FOLDER_NAME) envoyé vers (\$REPO_NAME)."
    rm -rf "\$TERMUX_PATH"
    echo "🧹 Nettoyage : La copie temporaire a été supprimée de Termux."
    echo "------------------------------------------------"
else
    echo "------------------------------------------------"
    echo "⚠️ Échec de l'upload. Le dépôt n'existe probablement pas."
    read -p "❓ Voulez-vous créer le dépôt automatiquement ? (y/n) : " CREATE_REPO
    if [[ "\$CREATE_REPO" == "y" || "\$CREATE_REPO" == "Y" ]]; then
        echo "⏳ Création du dépôt sur GitHub..."
        curl -s -H "Authorization: token \$TOKEN" -d "{\"name\":\"\$REPO_NAME\"}" https://api.github.com/user/repos > /dev/null
        echo "🚀 Nouvelle tentative d'upload..."
        if git push -u origin main -f; then
            echo "------------------------------------------------"
            echo "✅ Succès absolu ! Dépôt créé et dossier envoyé."
            rm -rf "\$TERMUX_PATH"
            echo "🧹 Nettoyage : La copie temporaire a été supprimée."
            echo "------------------------------------------------"
        else
            echo "❌ Échec définitif."
        fi
    else
        echo "🛑 Opération annulée."
    fi
fi
EOF

# 3. بناء أداة gitdel
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
    echo "✅ Succès ! Dépôt supprimé DÉFINITIVEMENT."
elif [ "\$HTTP_STATUS" -eq 403 ]; then
    echo "❌ Erreur (403) : Token sans permission 'delete_repo'."
else
    echo "❌ Échec. Code HTTP : \$HTTP_STATUS"
fi
EOF

# 4. بناء أداة cspace
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
        echo "✅ Succès ! Tapez 'cspace' à nouveau pour y accéder."
    else
        echo "❌ Échec de création."
    fi
fi
EOF

# 5. بناء أداة الدليل githelp
cat << 'EOF' > $PREFIX/bin/githelp
#!/bin/bash
echo "================================================="
echo "   🛠️ BOÎTE À OUTILS GITHUB (Termux) 🛠️"
echo "================================================="
echo "📌 COMMANDES PERSONNALISÉES :"
echo "  🟢 gitup   : Uploader un dossier (ou créer dépôt)."
echo "  🔴 gitdel  : Supprimer un dépôt DÉFINITIVEMENT."
echo "  ☁️ cspace  : Gérer les serveurs cloud Codespaces."
echo "  ℹ️ githelp : Afficher ce menu d'aide."
echo "📌 COMMANDES GITHUB UTILES :"
echo "  🗑️ gh codespace delete : Supprimer un serveur."
echo "  🚪 exit                : Quitter un serveur."
echo "================================================="
EOF

# 6. إعطاء الصلاحيات لجميع الأدوات وتفعيل التخزين
chmod +x $PREFIX/bin/gitup
chmod +x $PREFIX/bin/gitdel
chmod +x $PREFIX/bin/cspace
chmod +x $PREFIX/bin/githelp

termux-setup-storage

echo ""
echo "================================================="
echo "🎉 FÉLICITATIONS ! L'ENVIRONNEMENT EST PRÊT. 🎉"
echo "👉 Tapez 'githelp' pour voir vos commandes."
echo "================================================="
