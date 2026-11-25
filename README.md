# N3XVS — Media Station

Station multimédia légère pour Linux (prototype sur Linux Mint, cible envisagée Debian ARM64 / Amlogic S912 après validation matérielle).

## Objectif

Une interface **NEXUS Multimedia** cyberpunk, pilotable au clavier, avec catalogue de démonstration, bibliothèque locale, modules DLNA/UPnP, chaînes M3U/RTSP, lancement de VLC et raccourcis vers les plateformes officielles lorsque compatibles.

**Architecture envisagée :** Python 3 + PySide6 / Qt Quick (QML), SQLite pour les métadonnées, VLC/libVLC pour la lecture. Des composants Rust pourront être évalués après benchmarks. Aucun contournement DRM.

## Structure

- `MAIN/App/` : application et modules.
- `MAIN/Assets/` : images, maquettes, thèmes et styles.
- `MAIN/Docs/` : architecture, protocoles, pilotes, dépendances et tests.
- `MAIN/Dependancy/` : manifests, sources/licences et instructions de paquets hors-ligne (orthographe demandée conservée).
- `installation.sh`, `start.sh`, `stop.sh`, `update.sh` : scripts de cycle de vie, à développer/tester avant tout usage sur TX8.
- `ROADMAP.md` : périmètre et critères de validation.

## Sécurité et matériel

Ne **pas** écraser l'eMMC de la TX8 ni désactiver XFCE système avant sauvegarde, test du démarrage externe et identification précise du matériel. Utiliser une **session de connexion séparée** pour NEXUS, sans désinstaller ni tuer XFCE de l'autre session.

## Prototype v0.1

Sur Linux Mint 22.x amd64, depuis le dépôt :

    ./installation.sh --dry-run
    ./installation.sh --install
    ./start.sh

Pour les codecs et VLC, installer séparément le profil media. Le rendu logiciel se sélectionne au lancement :

    ./installation.sh --profile media --install
    QT_QUICK_BACKEND=software ./start.sh --daemon
    ./start.sh --status
    ./start.sh --restart
    ./stop.sh

Dans Bibliothèque, choisir le dossier média ou un partage déjà monté. La recherche filtre les titres de l'index. TV Direct accepte les playlists M3U. Applications et Replays ouvrent le site officiel avec accord explicite. Paramètres permet le plein écran. Dans la session X11 habituelle, la fermeture de NEXUS rend la main au bureau.

Session dédiée facultative : installer le profil session puis utiliser `./installation.sh --install-session` et sélectionner Multimedia à la prochaine connexion. Conserver le dépôt au même emplacement. Ctrl+N appartient à cette session. Les paquets du profil ARM64 se vérifient indépendamment.

## Guides et validations

- [Rapport des tests](MAIN/Docs/TEST-REPORT.md)
- [Captures Qt](MAIN/Docs/Captures)
- [Dépendances et profils](MAIN/Docs/DEPENDENCIES.md)
- [Fabrication hors ligne](MAIN/Docs/INSTALL-OFFLINE.md)
- [Architecture et stockage](MAIN/Docs/ARCHITECTURE.md)
- [Interface](MAIN/Docs/UI-DESIGN.md)
- [Plateformes](MAIN/Docs/STREAMING.md)
- [Matériel](MAIN/Docs/HARDWARE.md)
- [Sécurité](MAIN/Docs/SECURITY.md)
- [Étapes suivantes](ROADMAP.md)
