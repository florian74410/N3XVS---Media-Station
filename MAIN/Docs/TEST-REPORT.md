# Rapport de validation v0.1

Branche feat/nexus-multimedia-0.1, issue de main au commit dabfda603a73ff27cb1f010be0bc0f0837100545. Prototype testé le 25 novembre 2026 sur Debian 13.7 x86_64 et avec les bibliothèques Debian trixie arm64 extraites du bundle. Mint XFCE et la Tanix physique restent à valider.

| Fonction | Essai et résultat |
|---|---|
| Interface native | Lancement Qt Quick réel, sans navigateur. Rendu logiciel hors écran en 1280×800, 1920×1080, 2560×1440 et 640×480. Souris vers Netflix puis Tab/Espace vers Disney+. Chargement des huit entrées de navigation et sortie propre. |
| X11 | Démarrage, statut et arrêt via xcb sur un serveur Xvfb. Le sandbox limite l'énumération des interfaces réseau. |
| ARM64 | Python 3.13 et PySide6 6.8.2.1 exécutés sous qemu-aarch64 dans un chroot utilisateur. Les 193 .deb du profil core ont été extraits dans la racine de test. Chargement de la GUI, rendu logiciel et export PNG 1280×800 réussis. Avertissement de locale C dans la racine minimale. |
| Instances | Lancement daemon, second appel avec même PID, restart, statut, arrêt et statut arrêté exercés. Verrou conservé par le processus GUI. |
| Bibliothèque | Scan en lecture seule, index SQLite, recherche, deuxième scan sans nouvelle sonde, conservation de la progression, dossier absent et signets. ffprobe réel sur MP3 généré pour le test, durée 2,038 s. |
| Lecture | MP3 chargé par le véritable libVLC 3.0.24 amd64, progression observée et état final Ended. Aucun périphérique ALSA utilisable dans le test. Fallback VLC absent vérifié. Sortie HDMI et vidéo matérielle à essayer sur appareil. |
| IPTV | Lecture d'une playlist de test, conservation du titre et de RTSP, rejet de file:// et des identifiants dans l'URL. Flux réel Freebox à essayer sur LAN. |
| UPnP AV | Le test HTTP local exerce la description, le nom du serveur, le POST Browse et l'extraction de dossier DIDL. Le SSDP réel retourne réseau inaccessible dans cet environnement. Aucun serveur fictif annoncé. |
| Plateformes | URLs officielles, consentement, fenêtre Firefox dédiée et retour surveillé. Test de cycle de vie du processus avec doublure. DRM, login et fermeture d'une vraie fenêtre Firefox restent à vérifier sur la plateforme cible. |
| Session | Session séparée avec Openbox, superviseur, xbindkeys et Ctrl+N. Installation via gestionnaire de connexion et raccourci global non testés sur Mint. |
| Contrôles | Sept tests unittest réussis. ShellCheck réussi sur les scripts shell et lancement Qt sans erreur QML. installation.sh --dry-run exécuté. Le profil ARM64 refuse l'hôte amd64. |
| Ressources | Sur un échantillon au repos du prototype x86_64 offscreen software, RSS 90 784 KiB et CPU 0,67 % d'un cœur sur 3 s. Ces chiffres excluent Firefox et la lecture. |
| Visuels | Catalogue et bibliothèque de référence présents. Ville originale intégrée, deux compositions interactives testées en 640×480, 1280×800, 1672×941, 1920×1080 et 2560×1440. Rendu de Bibliothèque également capturé sur ARM64 émulé. |

## Dépendances hors ligne

| Bundle .tar | Paquets | Taille en octets | SHA256 de l'archive |
|---|---:|---:|---|
| N3XVS-Core-trixie-arm64 | 193 | 121907200 | 7367a5a6142c6add728a42286a0ab738963ecf128ff62670962088f0bbcbf4ed |
| N3XVS-Media-trixie-arm64 | 500 | 251852800 | ac2373780cd51ea049abb974e245aa5047d7f568c60df51e8444d13b01771743 |
| N3XVS-Diagnostic-trixie-arm64 | 310 | 159805440 | a473ffd722b6be1a4020bb8b0aba4dc00e2ee6155d398174dbdfd6f0dd66cd65 |

APT a résolu les trois profils depuis les index Debian signés avec un statut dpkg vide. Pour chaque lot, vérification SHA256 puis simulation APT avec seulement les .deb locaux, les sources distantes désactivées et --no-download. Le profil Media inclut le profil Core. Les totaux se recouvrent. La simulation et l'exécution Qt sous QEMU ne couvrent pas les scripts de post-installation sur une image Debian ARM64 native.

Les versions, dépendances et empreintes des .deb figurent dans MAIN/Dependancy/apt/trixie-arm64-*.lock.json. Les bibliothèques réellement mappées pendant le test x86_64 figurent dans DEPENDENCIES-TESTED-amd64.txt. Les captures originales du rendu sont dans Captures/.

## Reproduire les tests sur PC

    python3 -m unittest discover -s MAIN/App/tests -v
    python3 MAIN/App/tests/gui_smoke.py --captures MAIN/Docs/Captures
    shellcheck *.sh MAIN/App/packaging/*.sh MAIN/Dependancy/apt/*.sh

Utiliser .venv/bin/python sur le profil Mint. Lancer la session dédiée et les essais sur la TX8 seulement après décision du propriétaire. Les prochaines validations portent sur le disque externe, la lecture vidéo et audio réelle, la Freebox, les DRM et la reprise du bureau.
