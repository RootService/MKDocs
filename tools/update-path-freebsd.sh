#!/bin/sh
###############################################################################
# update-path-freebsd.sh
# FreeBSD 14+ POSIX shell toolbox to manage PATH.
#
# Actions (exactly one):
#   --scope [user|machine]   (default: user)
#   --add PATH               Add entry to PATH
#   --remove PATH            Remove all occurrences
#   --list                   List PATH entries
#   --backup FILE            Save PATH to FILE
#   --restore FILE           Restore PATH from FILE
#   --clean-duplicates       Remove duplicate entries
#   --effective              Show effective PATH (machine+user)
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

[ -n "$ACTION" ] || { echo "You must specify an action" >&2; usage; }

# Helpers
get_user_path() {
  if [ -f "$HOME/.profile" ]; then
    awk -F= '/^export PATH=/{gsub(/"/,"",$2); print $2}' "$HOME/.profile" | tail -n1
  fi
}

set_user_path() {
  new="$1"
  sed -i '' '/^export PATH=/d' "$HOME/.profile" 2>/dev/null || true
  printf 'export PATH="%s"\n' "$new" >>"$HOME/.profile"
  echo "User PATH updated. Restart shell to see changes."
}

get_machine_path() {
  if [ -f /etc/profile ]; then
    awk -F= '/^PATH=/{gsub(/"/,"",$2); print $2}' /etc/profile | tail -n1
  fi
}

set_machine_path() {
  new="$1"
  if [ "$(id -u)" -ne 0 ]; then
    echo "Root privileges required for machine scope" >&2
    exit 1
  fi
  sed -i '' '/^PATH=/d' /etc/profile 2>/dev/null || true
  echo "PATH=\"$new\"" >>/etc/profile
  echo "Machine PATH updated. Re-login to see changes."
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

# Current path value
PATHVAL="$(get_path || true)"
[ -n "${PATHVAL:-}" ] || PATHVAL="$PATH"
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
      case "$p" in
        *"$ARG"*) printf '%2d. %s\n' "$i" "$p" ;;
      esac
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
    for p in $paths; do [ "$p" = "$ARG" ] && continue
      [ -z "$new" ] && new="$p" || new="$new:$p"
    done
    set_path "$new"
    ;;
  --effective)
    u="$(get_user_path || true)"
    m="$(get_machine_path || true)"
    eff="$m:$u"
    IFS=:; set -- $eff; unset IFS
    i=1
    for p in $*; do [ -n "$p" ] && printf '%2d. %s\n' "$i" "$p"; i=$((i+1)); done
    ;;
esac
