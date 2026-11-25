# Profils de dépendances

Dans MAIN/Dependancy/apt, chaque packages-<profil>.txt est l'entrée directe du résolveur. Le profil par défaut est core. Les fichiers lock JSON consignent le résultat réel de la résolution pour la release et l'architecture indiquées. Chaque entrée identifie version, source Debian, dépendances, pré-dépendances, empreinte du .deb et notice de licence. Les notices complètes sont dans licenses/ du bundle. Les dépôts signés sont relus à chaque construction. Conserver les archives vérifiées pour reproduire les versions exactes après une mise à jour des miroirs.

| Profil | Contenu |
|---|---|
| core | Python 3, PySide6 Core/Gui/Qml/Quick, modules QML Controls, Layouts, Window, Templates, WorkerScript et Dialogs |
| media | VLC, libVLC, bindings Python, FFmpeg, GStreamer base/good/libav et outils |
| network | Avahi, GUPnP tools, SMB, CIFS et NFS |
| storage | udisks2 |
| diagnostic | ffprobe via ffmpeg, outils GStreamer et GUPnP |
| optional | plugins GStreamer bad/ugly |
| dev | Git, ShellCheck, pytest, venv, dpkg-dev |
| session | Openbox, xbindkeys, wmctrl, x11-utils pour une session X11 existante |

La liste proposée d'origine est conservée dans MAIN/Dependancy/DEPENDANCES-PROPOSEES.md. Les futurs outils GI/GSSDP, UxPlay, Miracast, XMLTV, WebRTC et le serveur X dépendent des pilotes et de l'environnement de session. Le client SSDP actuel utilise la bibliothèque standard Python. Les connexions aux services commerciaux se font dans Firefox ou Firefox ESR installé par l'utilisateur.

## Mint 22 amd64

Le chemin Mint utilise des wheels PySide6-Essentials et shiboken6 dans .venv, verrouillées dans qt-pyside6/mint22-amd64.txt. Ces deux dépendances proviennent de PyPI. Les profils APT facultatifs utilisent uniquement les dépôts configurés sur Mint. Le lanceur détecte .venv, NEXUS_PYTHON permet d'indiquer un autre interpréteur. Les modules Python installés uniquement par APT sont isolés de ce venv, auquel cas le lecteur VLC externe prend le relais.

## Debian 13 trixie arm64

Le builder utilise explicitement deb.debian.org, debian-security et le trousseau debian-archive-keyring. Commande de vérification locale d'un profil avant installation :

    ./installation.sh --profile network --check

Source Debian et notices de redistribution : https://packages.debian.org/trixie/ et /usr/share/doc/<paquet>/copyright.
