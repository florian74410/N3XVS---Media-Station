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
