# Plateformes officielles — stratégie

Sous Debian ARM64 S912, aucune des six plateformes visées n'est actuellement validée comme **application native Linux ARM64**. Ne pas installer d'APK Android comme un paquet Debian ; un PWA/browser n'est pas une app native indépendante du navigateur.

- Free TV : https://tv.free.fr/ ; https://assistance.free.fr/articles/1826
- Netflix : https://www.netflix.com/ ; https://help.netflix.com/fr/node/101653
- Disney+ : https://www.disneyplus.com/ ; https://help.disneyplus.com/article/disneyplus-devices-supported
- Prime Video : https://www.primevideo.com/ ; https://www.primevideo.com/help?nodeId=GUX9FYHU5D8LC9EJ
- Apple TV : https://tv.apple.com/fr/ ; https://support.apple.com/fr-fr/guide/tvplus/apdc0cb7ad64/web
- Replay : Free TV, france.tv, ARTE selon accès officiel.

Concevoir un lanceur vers application officielle si elle existe sur la cible ; à défaut, navigateur **externe compatible et installé**, avec message clair si pas de support DRM. Ne pas incorporer le site dans une iframe ou un WebView en supposant le DRM accessible. Ne pas promettre de deep-link titre sans URL approuvée/vérifiée. Métadonnées TMDb éventuellement via API autorisée et attribution ; ne pas confondre catalogue externe avec droits effectifs du compte.

Les maquettes de plateformes sont des simulations : aucun titre ou note de l'image ne prouve une disponibilité réelle.
