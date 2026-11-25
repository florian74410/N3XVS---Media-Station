# Bibliothèque de dépendances

Orthographe `Dependancy` conservée comme demandé.

Sous-dossiers :
- `apt/` : liste des noms de paquets Debian, par profil ; la résolution exacte dépend de la version Debian.
- `qt-pyside6/` : Qt/PySide6, interfaces QML et documentation.
- `vlc-ffmpeg/` : lecture, libVLC, codecs et diagnostics.
- `network-dlna/` : SMB/NFS, GUPnP/DLNA et Avahi.
- `streaming-launchers/` : URL officielles et limites DRM (aucun APK tiers).
- `offline/` : dépôt APT ARM64 construit pour une **version Debian précise**, hors Git.

**Important :** les sources et licences ne doivent pas être confondues avec les paquets compilés ; noter versions, SHA256, licences, origine, architecture et dépendances transitives. Pour installer hors ligne, préférer un mini dépôt APT local signé ou des .deb d'origine et vérifiés à un `curl | bash` ou `npm install` non épinglé.
