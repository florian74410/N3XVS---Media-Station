# Architecture de travail

## But et choix technique
GUI native `PySide6 + Qt Quick/QML` (sans Electron/Chromium embarqué), Python pour orchestration et bibliothèque, VLC libVLC/moteurs média en adaptateurs, SQLite intégré pour état local. Rust seulement sur preuve d'un goulet CPU.

Développer d'abord sur PC Linux Mint ; la cible Tanix TX8 S912 2 Go / eMMC reste présumée, non validée. La mise en route sur Debian ARM64 dépend du noyau, du DTB, du GPU et de l'affichage.

## Modes
`Multimedia` sera **une session X11 indépendante** sélectionnée depuis le gestionnaire de connexion, lançant directement l'interface Media. Ne jamais désinstaller ou tuer XFCE du compte Desktop. Une session dédiée doit rester réversible. `start.sh` lance uniquement NEXUS, pas de modification globale de cible systemd.

## Stockage
- Programme et bibliothèques installés sur eMMC à terme.
- Données utilisateur, médiathèque, projets sur HDD USB externe.
- Cache miniatures facultatif sur eMMC avec quotas, recréable.
- Les bases de données et écritures importantes ne doivent pas reposer exclusivement sur copie au STOP ; sauvegardes cohérentes et crash-safe.

## Interfaces attendues
`ProviderAdapter` (plateformes), `LibraryAdapter` (HDD/SMB/NFS/DLNA), `PlayerAdapter` (VLC/libVLC), `LaunchManager` (handoff/retour). Les providers DRM ne fournissent pas de flux directs à NEXUS. Aucune extraction de secrets/cookies.

## Résolutions
Responsive, grand espacement des tuiles, horizontal scroll par catégorie, rendu léger. Palette noire/bleu électrique ; rouge discret, fond urbain fourni, overlays suffisants pour lisibilité.

## Chemins exécutés en v0.1

main.py possède le verrou d'instance et le moteur QML. core/backend.py expose les actions Qt et garde la connexion SQLite du thread graphique. Le scanner ouvre sa propre connexion sur un thread distinct. Il compare les dates de modification avant de sonder à nouveau un média. Les chemins absents restent indexés pour préserver le suivi des disques amovibles. Un seul dossier est surveillé périodiquement, les dossiers déjà indexés restent consultables.

Le profil de stockage par défaut est XDG_DATA_HOME/nexus-media. NEXUS_DATA_MOUNT sélectionne un volume déjà monté pour Databases/nexus-media. En l'absence de ce volume le catalogue local de secours est explicitement indiqué. Les fichiers multimédias sont en lecture seule. La copie vers Backups et les quotas de cache restent à réaliser.

Les adresses de plateformes sont dans config/providers.json. Le lecteur libVLC publie la progression toutes les cinq secondes de lecture et à l'arrêt. Le repli VLC externe accepte une position initiale, le signet y est manuel. Les serveurs DLNA sont interrogés sur action et les ressources HTTP(S) doivent désigner l'adresse de l'émetteur SSDP. Un serveur qui annonce seulement son nom DNS ou utilise un autre hôte de ressources nécessitera une extension de cette politique.

Le superviseur de session lance exclusivement Openbox, xbindkeys et NEXUS. Une sortie normale laisse le raccourci Ctrl+N disponible. Un crash provoque une relance après deux secondes. Quitter Openbox termine la session et ses processus supervisés.
