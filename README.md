# xbar – YouTube « À regarder plus tard »

Plugin [xbar](https://github.com/matryer/xbar) qui affiche, dans la barre de menus macOS, 5 vidéos tirées au hasard de votre playlist YouTube « À regarder plus tard », avec leurs miniatures. Un clic ouvre la vidéo dans votre navigateur.

## Prérequis
- macOS et xbar
- yt-dlp : `brew install yt-dlp`
- Un navigateur connecté à YouTube : Chrome, Brave, Firefox, Edge, Vivaldi, Opera, Chromium ou Safari

## Installation
1. Copier `youtube-watchlater.30m.sh` dans `~/Library/Application Support/xbar/plugins/`
2. Le rendre exécutable : `chmod +x youtube-watchlater.30m.sh`
3. Le lancer une fois dans le Terminal et autoriser l'accès au trousseau si macOS le demande
4. Dans xbar : Refresh all

Pour Safari, donner à xbar l'« Accès complet au disque » (Réglages système → Confidentialité et sécurité).

## Réglages (en haut du script)
- `NB_VIDEOS` : nombre de vidéos affichées
- `BROWSER` : `auto` (détection) ou un navigateur précis, ex. `firefox`, `chrome:Profile 1`
- `OPEN_IN` : `auto` (même navigateur), `default` (navigateur par défaut) ou un nom d'application
- `SHOW_THUMBS` / `THUMB_WIDTH` : affichage et taille des miniatures

## Pourquoi yt-dlp ?
L'API YouTube Data ne donne pas accès à la playlist « À regarder plus tard ». yt-dlp la lit localement grâce à la session de votre navigateur. Aucune donnée personnelle n'est stockée dans ce dépôt ; le cache est dans `~/Library/Caches/xbar-youtube-wl`.
