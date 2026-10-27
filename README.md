# xbar – YouTube « À regarder plus tard » 🇫🇷
# xbar – YouTube « Watch Later » 🇬🇧
🇫🇷 [Français](#xbar--youtube--à-regarder-plus-tard-) · 🇬🇧 [English](#xbar--youtube-watch-later)

Plugin [xbar](https://github.com/matryer/xbar) qui affiche, dans la barre de menus macOS, 5 vidéos tirées au hasard de votre playlist YouTube « À regarder plus tard », avec leurs miniatures. Un clic ouvre la vidéo dans votre navigateur.

<img width="576" height="605" alt="Capture d’écran 2026-10-22 à 14 26 27" src="https://github.com/user-attachments/assets/32b09e78-ba9a-465c-9f7d-54e99c4aa698" />

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

# 🇬🇧 xbar – YouTube "Watch Later"

[xbar](https://github.com/matryer/xbar) plugin that shows 5 random videos from your YouTube "Watch Later" playlist in the macOS menu bar, with their thumbnails. Click a video to open it in your browser.

## Requirements
- macOS and xbar
- yt-dlp: `brew install yt-dlp`
- A browser signed in to YouTube: Chrome, Brave, Firefox, Edge, Vivaldi, Opera, Chromium or Safari

## Installation
1. Copy `youtube-watchlater.30m.sh` to `~/Library/Application Support/xbar/plugins/`
2. Make it executable: `chmod +x youtube-watchlater.30m.sh`
3. Run it once in Terminal and allow Keychain access if macOS asks
4. In xbar: Refresh all

For Safari, grant xbar "Full Disk Access" (System Settings → Privacy & Security).

## Settings (at the top of the script)
- `NB_VIDEOS`: number of videos displayed
- `BROWSER`: `auto` (detection) or a specific browser, e.g. `firefox`, `chrome:Profile 1`
- `OPEN_IN`: `auto` (same browser), `default` (system default browser) or an application name
- `SHOW_THUMBS` / `THUMB_WIDTH`: show thumbnails and set their size

## Why yt-dlp?
The YouTube Data API does not give access to the "Watch Later" playlist. yt-dlp reads it locally using your browser session. No personal data is stored in this repository; the cache lives in `~/Library/Caches/xbar-youtube-wl`.
