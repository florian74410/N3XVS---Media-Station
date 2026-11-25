# Préparer un support hors ligne

Sur un poste Debian avec APT, dpkg-dev, debian-archive-keyring, Python 3, gzip et sha256sum, choisir une destination neuve. Le résolveur utilise une base de paquets installés vide et les index arm64 indépendamment de l'architecture du poste.

    MAIN/Dependancy/apt/build-offline.sh ~/N3XVS-core core
    MAIN/Dependancy/apt/build-offline.sh ~/N3XVS-media core media network
    MAIN/Dependancy/apt/build-offline.sh ~/N3XVS-diagnostic diagnostic

Le dossier contient pool/, Packages.gz, manifest.json, DEPENDENCIES-RESOLVED.txt, profiles.txt, licenses/, SHA256SUMS et install-offline.py. Transférer le dossier entier et vérifier l'empreinte de l'archive par un canal de confiance. Un fichier SHA256SUMS joint protège contre la corruption accidentelle. Une personne capable de remplacer l'archive entière peut aussi remplacer ce fichier.

Sur un système Debian trixie arm64 de test seulement après vérification de la release, de l'architecture et de la procédure de restauration :

    ./installation.sh --offline /chemin/N3XVS-core

Le script vérifie les SHA, l'inventaire et l'architecture hôte, simule la transaction, puis appelle APT en interdisant le téléchargement. APT demande la confirmation de la transaction. Une simulation réussie ne valide ni les scripts de post-installation ni les pilotes de la box. Les bundles contiennent des dépendances de l'application et supposent une base Debian installée et opérationnelle.
