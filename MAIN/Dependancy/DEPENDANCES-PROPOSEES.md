# Dépendances proposées — N3XVS Media Station v0.1

**Statut : inventaire DIRECT provisoire**, pas un bundle pré-téléchargé ni une preuve d'exécution sur TX8. Les sous-dépendances, versions exactes, ABI et possibilités de lecture GPU/VPU dépendent de la release Debian ARM64 et du système graphique réellement installé. Pour préparer une installation totalement hors ligne, résoudre les dépendances APT dans un environnement propre `Debian release cible + arm64` (pas Ubuntu/Mint amd64), archiver tous les `.deb` nécessaires, noter les versions, SHA256 et licences, et tester la réinstallation sans Internet avant d'utiliser la box.

## 1. Interface native — obligatoires

- `python3` : runtime application.
- `python3-pyside6.qtcore` : infrastructure Qt.
- `python3-pyside6.qtgui` : GUI.
- `python3-pyside6.qtqml` : chargement QML.
- `python3-pyside6.qtquick` : moteur Qt Quick.
- `qml6-module-qtquick` : QML visuels.
- `qml6-module-qtquick-controls` : boutons / dialogs / contrôles.
- `qml6-module-qtquick-layouts` : layouts adaptatifs.
- `qml6-module-qtquick-window` : fenêtres QML.

Ces noms sont initialement ciblés pour Debian 13 Trixie ARM64. Les paquets Qt natifs transitifs doivent venir du même ensemble de dépôts officiels Debian.

## 2. Lecture média — pack optionnel v0.1

- `vlc` : application et moteur externe.
- `libvlc5` : bibliothèque moteur VLC (nom Debian à contrôler sur cible).
- `python3-vlc` : intégration Python via libVLC.
- `ffmpeg` : `ffprobe`, analyse vidéo, codecs disponibles dans les dépôts.
- `gstreamer1.0-tools` : outils de diagnostic pipeline.
- `gstreamer1.0-plugins-base` : pipelines usuels.
- `gstreamer1.0-plugins-good` : formats/protocoles usuels.
- `gstreamer1.0-libav` : codecs FFmpeg pour GStreamer.
- `gstreamer1.0-plugins-bad`, `gstreamer1.0-plugins-ugly` : facultatifs et à examiner selon usage/licences.

**Attention** : avoir VLC et les codecs ne garantit pas le décodage matériel HEVC/VP9 sous Debian sur S912. Le pilote VPU de l'image Linux doit être testé séparément. Pas d'installation automatique de Widevine ni autre composant DRM.

## 3. Réseau, DLNA, stockage — optionnels

- `avahi-daemon` : découverte mDNS (certains protocoles réseau).
- `gupnp-tools` : test et découverte UPnP/DLNA.
- `smbclient` : partages SMB.
- `cifs-utils` : montages SMB/CIFS.
- `nfs-common` : client NFS.
- `python3-gi` et bibliothèques GUPnP/GSSDP GI : à ajouter après essai d'une implémentation cliente, en vérifiant leur packaging ARM64.
- `udisks2` : gestion des volumes USB lorsque utile, selon politique utilisateur.

DLNA et partage d'écran sont distincts : AirPlay via UxPlay, Miracast et WebRTC restent des options futures après inventaire des pilotes réseau/vidéo.

## 4. Scripts, logs et tests — développement seulement

- `git` : dépôt et mises à jour.
- `shellcheck` : validation des scripts `.sh`.
- `python3-pytest` : tests.
- `python3-venv` : environnement de développement facultatif.
- `xserver-xorg-core`, `xinit`, `openbox` ou session X11 minimale : **à confirmer selon système de connexion existant**, non requis pour le prototype sur session XFCE en cours.
- `dpkg-dev` : `dpkg-scanpackages` pour générer un index APT local sur machine de préparation.

## 5. Préparation du bundle hors ligne

Un bundle de déploiement devrait contenir :

```
N3XVS-Offline-debian-<release>-arm64/
├── Packages.gz
├── pool/                     fichiers .deb, architecture arm64 ou all
├── SHA256SUMS
├── manifest.json             package/version/architecture/licence/source
├── DEPENDENCIES-RESOLVED.txt
└── install-offline.sh        aucune connexion réseau
```

Faire résoudre le jeu exact de `.deb` par APT depuis les dépôts officiels de la release choisie, en incluant la **fermeture transitive** des dépendances, et tester avec les dépôts distants désactivés. Toute installation sur le matériel réel nécessite confirmation explicite et récupération du système précédent.

## 6. Plateformes commerciales : ne PAS fournir de faux exécutables Linux

| Plateforme | Linux ARM64 natif officiel confirmé ? | Accès officiel et aide |
|---|---|---|
| Free TV | Non identifié | https://tv.free.fr/ ; https://assistance.free.fr/articles/1826 |
| Netflix | Non identifié | https://www.netflix.com/ ; https://help.netflix.com/fr/node/101653 |
| Disney+ | Non identifié | https://www.disneyplus.com/ ; https://help.disneyplus.com/article/disneyplus-devices-supported |
| Prime Video | Non identifié | https://www.primevideo.com/ ; https://www.primevideo.com/help?nodeId=GUX9FYHU5D8LC9EJ |
| Apple TV | Non identifié | https://tv.apple.com/fr/ ; https://support.apple.com/fr-fr/guide/tvplus/apdc0cb7ad64/web |
| Replays | Lancement dépend service | https://tv.free.fr/ ; https://www.france.tv/ ; https://www.arte.tv/fr/ |

Sur Debian, utiliser des lanceurs vers **applications officielles compatibles lorsqu'elles existent réellement**, ou navigateur externe avec support DRM confirmé. Les APK Android / programmes Windows ne sont pas des applications Debian ARM64. La disponibilité de liens profonds vers un titre spécifique n'est pas garantie.
