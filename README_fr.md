# infinity_chars - Sélecteur Multi-Personnages RedM

Module avancé de sélection et gestion de multiples personnages pour RedM, développé par Shepard & iiRedDev (ALTITUDE-DEV.COM). Conçu pour fonctionner en synergie avec Infinity Core et Infinity Skin.

## ✨ Fonctionnalités principales

- Menu de sélection multi-personnages (UI moderne)
- Synchronisation complète avec Infinity Core et Infinity Skin
- Changement de personnage, chargement skin et tenue
- Synchronisation serveur/client des données personnage
- Intégration base de données (oxmysql requis)
- Intégration facile avec les autres modules du framework

## 📦 Installation

1. Placez ce dossier dans `resources` de votre serveur RedM.
2. Ajoutez la ressource à votre `server.cfg` :
   ```
   ensure oxmysql              # Module SQL
   ensure infinity_core        # Module Framework core
   ensure infinity_skin        # Module système de skin
   ensure infinity_chars
   ```
3. Assurez-vous que [oxmysql](https://github.com/overextended/oxmysql) est installé et lancé avant ce script.
4. Configurez les fichiers selon vos besoins.

## ⚙️ Configuration

- Scripts principaux :
  - `client.lua` (logique client)
  - `server.lua` (logique serveur)
  - `clothes-skin.lua` (données skin/tenue)
- Interface utilisateur : `html/`

## 🛠 Contribution

Toute contribution est la bienvenue !
Merci de créer une issue ou une pull request pour toute suggestion ou amélioration.

## 🤝 Support & liens

- Documentation : [https://altitude-dev.gitbook.io/doc/](https://altitude-dev.gitbook.io/doc/)
- Discord support : [https://discord.gg/ncH7GX3XJd](https://discord.gg/ncH7GX3XJd)
- Auteurs : Shepard, iiRedDev

---

> Module sous licence ALTITUDE-DEV.COM. Toute reproduction ou distribution non autorisée est interdite.
