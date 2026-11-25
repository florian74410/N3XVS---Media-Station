# Modules applicatifs
- `nexus_media/main.py` : démarrage PySide6 et QML.
- `nexus_media/ui/Main.qml` : shell d'interface QML de démonstration.
- `nexus_media/core/` : configuration et modèles.
- `nexus_media/services/` : adaptateurs future DLNA/VLC/streaming, sans couplage direct à la GUI.
- `nexus_media/data/` : données de démonstration **sans** affiliation réelle aux services.
- `tests/` : contrôles sans matériel.

Pour exécuter : `./start.sh` après `./installation.sh --check`. L'application QML actuelle est un prototype navigable ; les fonctions externes sont encore non intégrées.
