# ROADMAP — N3XVS Media Station

## 0.0.1 — Fondation et prototype GUI
- [x] Structure `MAIN/{App,Assets,Docs,Dependancy}`.
- [x] Scripts prudents de base ; modes de vérification.
- [x] GUI Qt Quick/QML de démonstration navigable avec mosaïques simulées.
- [ ] Intégrer les 3 images sources fournies par l'utilisateur dans `MAIN/Assets/`.
- [ ] Tester la GUI sur Linux Mint XFCE (X11), 1280×800 et 2560×1440.
- [ ] Vérifier dépendances ARM64 et sortie vidéo réelle TX8.

## 0.1 — Bibliothèque locale
- [ ] Indexeur HDD/USB en lecture seule, miniatures mises en cache, SQLite, états (jamais vu/en cours/déjà vu).
- [ ] Lecture via VLC ; suivi de progression pour médias locaux.
- [ ] Filtres par genre, carrousels espacés, clavier et souris, responsive.

## 0.2 — Sources réseau
- [ ] SMB, NFS ; DLNA/UPnP AV via couche découplée ; découvertes testées.
- [ ] Playlist IPTV M3U/HLS/RTSP autorisée ; diagnostic de flux et choix HD/SD.
- [ ] Free TV+ via site/application officiel si support matériel/DRM confirmé.

## 0.3 — Handoff plateformes
- [ ] Lanceurs Netflix, Disney+, Prime Video, Apple TV, Free TV, Replays.
- [ ] Retour GUI fiable à la fermeture, Ctrl+N et raccourci système hors processus.
- [ ] Catalogues facultatifs sur APIs autorisées ; métadonnées distinctes de disponibilité réelle ; deep links seulement confirmés.

## 0.4 — Session Media et box TX8
- [ ] Session de connexion `Multimedia` séparée (sans lancer XFCE), retour à XFCE intact.
- [ ] Gestion supervision systemd --user et reprise après crash.
- [ ] Mesures 2 Go RAM, GPU Mali-T820, décodage V4L2/DRM, 1440p et 1080p.
- [ ] Bundle Debian ARM64 offline, dépendances transitives vérifiées, licence et SHA256.

## Plus tard
AirPlay UxPlay, Miracast, WebRTC, EPG XMLTV, streaming distant, A/B update, stockage hybride.

**Barrière de sécurité :** aucun flash eMMC sans identification du DTB, backup vérifié et procédure de restauration.
