#!/usr/bin/env bash
#
# <xbar.title>YouTube – À regarder plus tard</xbar.title>
# <xbar.version>v2.1</xbar.version>
# <xbar.author>Haymitsu</xbar.author>
# <xbar.desc>Affiche 5 vidéos au hasard de la playlist « À regarder plus tard ». Détecte automatiquement le navigateur connecté à YouTube.</xbar.desc>
# <xbar.dependencies>yt-dlp</xbar.dependencies>
#
# Le nom du fichier (.30m.) = nouveau tirage toutes les 30 minutes.

# xbar ne charge pas le PATH du terminal : on le fixe nous-mêmes
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:/usr/bin:/bin"
export LC_ALL="en_US.UTF-8"

# ---------- Réglages ----------
NB_VIDEOS=5
CACHE_MAX_AGE=3600          # re-téléchargement de la playlist : 1 h
TITLE_MAX_LEN=60

# Miniatures : 1 = affichées, 0 = désactivées. Largeur en pixels.
SHOW_THUMBS=1
THUMB_WIDTH=128

# "auto" = essaie les navigateurs installés dans l'ordre de BROWSER_ORDER.
# Sinon, forcer un navigateur (et éventuellement un profil) :
#   BROWSER="firefox"   BROWSER="chrome:Profile 1"   BROWSER="brave"
BROWSER="auto"
BROWSER_ORDER="chrome brave firefox edge vivaldi opera chromium safari"

# "auto" = ouvre les vidéos dans le navigateur où le cookie a été trouvé.
# "default" = navigateur par défaut du Mac. Ou un nom d'app : "Firefox"…
OPEN_IN="auto"
# ------------------------------

PLAYLIST_URL="https://www.youtube.com/playlist?list=WL"
CACHE_DIR="$HOME/Library/Caches/xbar-youtube-wl"
CACHE="$CACHE_DIR/wl.tsv"
FOUND="$CACHE_DIR/navigateur.txt"   # navigateur qui a fonctionné la dernière fois
ERRLOG="$CACHE_DIR/erreur.log"
THUMBS="$CACHE_DIR/miniatures"
mkdir -p "$CACHE_DIR" "$THUMBS"

# Nom de l'application macOS correspondant à chaque navigateur yt-dlp
app_name() {
  case "${1%%:*}" in            # retire un éventuel ":Profil"
    chrome)   echo "Google Chrome" ;;
    brave)    echo "Brave Browser" ;;
    firefox)  echo "Firefox" ;;
    edge)     echo "Microsoft Edge" ;;
    vivaldi)  echo "Vivaldi" ;;
    opera)    echo "Opera" ;;
    chromium) echo "Chromium" ;;
    safari)   echo "Safari" ;;
    whale)    echo "Whale" ;;
  esac
}

is_installed() {
  local app; app="$(app_name "$1")"
  [ -n "$app" ] && { [ -d "/Applications/$app.app" ] || [ -d "$HOME/Applications/$app.app" ]; }
}

# Essaie de lire la playlist avec un navigateur donné. Code retour 0 = connecté.
try_browser() {
  local tmp="$CACHE.tmp"
  echo "== $1 ==" >>"$ERRLOG"
  if yt-dlp --cookies-from-browser "$1" \
            --flat-playlist --no-warnings \
            --print $'%(id)s\t%(title)s\t%(channel,uploader|)s' \
            "$PLAYLIST_URL" >"$tmp" 2>>"$ERRLOG"; then
    mv "$tmp" "$CACHE"
    echo "$1" >"$FOUND"
    return 0
  fi
  rm -f "$tmp"
  return 1
}

refresh_cache() {
  : >"$ERRLOG"
  if [ "$BROWSER" != "auto" ]; then
    try_browser "$BROWSER"; return
  fi
  # On recommence par le navigateur qui a marché la dernière fois
  local last=""; [ -s "$FOUND" ] && last="$(cat "$FOUND")"
  local b
  for b in $last $BROWSER_ORDER; do
    [ -n "$last" ] && [ "$b" = "$last" ] && [ -n "$deja" ] && continue
    [ "$b" = "$last" ] && deja=1
    is_installed "$b" || continue
    try_browser "$b" && return 0
  done
  rm -f "$FOUND"
  return 1
}

# Renvoie le paramètre xbar "image=..." pour une vidéo (vide si échec).
# Chaque miniature est téléchargée une seule fois, puis réutilisée.
thumb_param() {
  [ "$SHOW_THUMBS" = "1" ] || return 0
  local id="$1" f="$THUMBS/$1.jpg" tmp="$THUMBS/$1.tmp"
  if [ ! -s "$f" ]; then
    curl -sfL --max-time 5 "https://i.ytimg.com/vi/$id/mqdefault.jpg" -o "$tmp" \
      && sips --resampleWidth "$THUMB_WIDTH" "$tmp" --out "$f" >/dev/null 2>&1
    rm -f "$tmp"
  fi
  [ -s "$f" ] && echo " image=$(base64 -i "$f" | tr -d '\n')"
}

open_cmd() {   # $1 = URL → paramètres xbar pour l'ouvrir
  local target="$OPEN_IN"
  if [ "$target" = "auto" ]; then
    target="$(app_name "$(cat "$FOUND" 2>/dev/null)")"
  fi
  if [ -z "$target" ] || [ "$target" = "default" ]; then
    echo "shell=/usr/bin/open param1=\"$1\" terminal=false"
  else
    echo "shell=/usr/bin/open param1=-a param2=\"$target\" param3=\"$1\" terminal=false"
  fi
}

# Clic sur « Rafraîchir la playlist »
if [ "$1" = "--refresh" ]; then
  rm -f "$FOUND"        # relance la détection complète
  refresh_cache
  exit 0
fi

if [ ! -f "$CACHE" ] || [ $(( $(date +%s) - $(stat -f %m "$CACHE") )) -gt "$CACHE_MAX_AGE" ]; then
  refresh_cache
fi

# Ménage : supprime les miniatures de plus de 30 jours (re-téléchargées au besoin)
find "$THUMBS" -name '*.jpg' -mtime +30 -delete 2>/dev/null

# ---------- Barre de menus ----------
echo "Watch Later ▶︎"
echo "---"

if ! command -v yt-dlp >/dev/null 2>&1; then
  echo "yt-dlp introuvable | color=red"
  echo "Installer : brew install yt-dlp | font=Menlo size=11"
  exit 0
fi

if [ ! -f "$CACHE" ]; then
  echo "Aucun navigateur connecté à YouTube trouvé | color=red"
  echo "Connectez-vous à YouTube dans votre navigateur | size=11 color=gray"
  echo "Voir le journal d'erreur | shell=/usr/bin/open param1=-t param2=\"$ERRLOG\" terminal=false"
  echo "Réessayer | shell=\"$0\" param1=--refresh terminal=false refresh=true"
  exit 0
fi

TOTAL=$(grep -c . "$CACHE")
SOURCE="$(app_name "$(cat "$FOUND" 2>/dev/null)")"

if [ "$TOTAL" -eq 0 ]; then
  echo "La playlist est vide | color=gray"
else
  SHOWN=$(( TOTAL < NB_VIDEOS ? TOTAL : NB_VIDEOS ))
  echo "$SHOWN vidéos au hasard sur $TOTAL | size=11 color=gray"
  echo "---"
  awk 'BEGIN { srand() } NF { printf "%f\t%s\n", rand(), $0 }' "$CACHE" \
    | sort -n | cut -f2- | head -n "$NB_VIDEOS" \
    | while IFS=$'\t' read -r id title channel; do
        [ -z "$id" ] && continue
        title="${title//|/–}"
        channel="${channel//|/–}"
        if [ "${#title}" -gt "$TITLE_MAX_LEN" ]; then
          title="${title:0:$TITLE_MAX_LEN}…"
        fi
        echo "$title | $(open_cmd "https://www.youtube.com/watch?v=${id}&list=WL")$(thumb_param "$id")"
        [ -n "$channel" ] && echo "-- $channel | size=11 color=gray"
      done
fi

echo "---"
[ -n "$SOURCE" ] && echo "Cookies lus depuis : $SOURCE | size=11 color=gray"
echo "Nouveau tirage | refresh=true"
echo "Rafraîchir la playlist | shell=\"$0\" param1=--refresh terminal=false refresh=true"
echo "Ouvrir la playlist complète | $(open_cmd "$PLAYLIST_URL")"
