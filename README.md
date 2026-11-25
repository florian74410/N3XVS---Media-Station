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

## État

Fondation du dépôt. Application et intégrations réelles **non encore livrées**. Les captures et catalogues d'exemple sont des maquettes, pas des affirmations de disponibilité de films sur une plateforme.
