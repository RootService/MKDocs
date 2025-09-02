#!/bin/sh
###############################################################################
# update-path-ubuntu.sh
# Ubuntu 22.04+ POSIX shell toolbox to manage PATH.
#
# Actions (choose exactly one):
#   --scope [user|machine]   (default: user)
#   --add PATH               Add entry to PATH
#   --remove PATH            Remove all occurrences
#   --list                   List PATH entries
#   --backup FILE            Save PATH to FILE
#   --restore FILE           Restore PATH from FILE
#   --clean-duplicates       Remove duplicate entries
#   --effective              Show effective PATH
#   --search KEYWORD         Search PATH entries
###############################################################################

set -eu

SCOPE="user"
ACTION=""
ARG=""

usage() {
  sed -n '2,25p' "$0"
  exit 1
}

# Parse args
while [ $# -gt 0 ]; do
  case "$1" in
    --scope) SCOPE="$2"; shift 2 ;;
    --add|--remove|--backup|--restore|--search)
      ACTION="$1"; ARG="$2"; shift 2 ;;
    --list|--clean-duplicates|--effective) ACTION="$1"; shift ;;
    --help|-h) usage ;;
    *) echo "Unknown arg: $1" >&2; usage ;;
  esac
done

if [ -z "$ACTION" ]; then
  echo "You must specify an action" >&2
  usage
fi

# Helpers
get_user_path() {
  # Default: look in ~/.profile for PATH exports
  if [ -f "$HOME/.profile" ]; then
    grep -E '^export PATH=' "$HOME/.profile" | tail -n1 | sed 's/^export PATH=//' | sed 's/"//g'
  fi
}

set_user_path() {
  new="$1"
  sed -i '/^export PATH=/d' "$HOME/.profile"
  printf 'export PATH="%s"\n' "$new" >>"$HOME/.profile"
  echo "User PATH updated. Restart shell to see changes."
}

get_machine_path() {
  if [ -f /etc/environment ]; then
    grep '^PATH=' /etc/environment | cut -d= -f2 | tr -d '"'
  fi
}

set_machine_path() {
  new="$1"
  sudo sed -i '/^PATH=/d' /etc/environment
  echo "PATH=\"$new\"" | sudo tee -a /etc/environment >/dev/null
  echo "Machine PATH updated. Reboot or re-login to see changes."
}

get_path() {
  if [ "$SCOPE" = "machine" ]; then
    get_machine_path
  else
    get_user_path
  fi
}

set_path() {
  if [ "$SCOPE" = "machine" ]; then
    set_machine_path "$1"
  else
    set_user_path "$1"
  fi
}

# Action implementations
PATHVAL="$(get_path || true)"
IFS=:; set -- $PATHVAL; unset IFS
paths="$*"

case "$ACTION" in
  --list)
    i=1
    for p in $paths; do
      printf '%2d. %s\n' "$i" "$p"; i=$((i+1))
    done
    ;;
  --search)
    i=1
    for p in $paths; do
      echo "$p" | grep -i -- "$ARG" >/dev/null 2>&1 || { i=$((i+1)); continue; }
      printf '%2d. %s\n' "$i" "$p"
      i=$((i+1))
    done
    ;;
  --backup)
    get_path >"$ARG"
    echo "$SCOPE PATH backed up to $ARG"
    ;;
  --restore)
    [ -f "$ARG" ] || { echo "File not found: $ARG" >&2; exit 1; }
    new="$(cat "$ARG")"
    set_path "$new"
    ;;
  --clean-duplicates)
    seen=""
    new=""
    for p in $paths; do
      echo "$seen" | grep -F -q ":$p:" && continue
      seen="$seen:$p:"
      [ -z "$new" ] && new="$p" || new="$new:$p"
    done
    set_path "$new"
    ;;
  --add)
    for p in $paths; do [ "$p" = "$ARG" ] && { echo "Already in PATH"; exit 0; }; done
    new="$PATHVAL:$ARG"
    set_path "$new"
    ;;
  --remove)
    new=""
    for p in $paths; do [ "$p" = "$ARG" ] && continue; [ -z "$new" ] && new="$p" || new="$new:$p"; done
    set_path "$new"
    ;;
  --effective)
    u="$(get_user_path || true)"
    m="$(get_machine_path || true)"
    eff="$m:$u"
    IFS=:; set -- $eff; unset IFS
    i=1
    for p in $*; do printf '%2d. %s\n' "$i" "$p"; i=$((i+1)); done
    ;;
esac
