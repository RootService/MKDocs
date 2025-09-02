#!/bin/sh
###############################################################################
# File: pathctl.sh
# Purpose: Idempotent PATH management for POSIX shells on FreeBSD 14+
# Shell: /bin/sh (POSIX)
# License: CC BY-NC-SA 4.0
#
# Usage:
#   sh pathctl.sh add  DIR [--persist]
#   sh pathctl.sh rm   DIR [--persist]
#   sh pathctl.sh show
###############################################################################

set -eu
MARK_BEGIN="# BEGIN pathctl managed block"
MARK_END="# END pathctl managed block"
PROFILE="$HOME/.profile"

log() { printf '%s\n' "$*" >&2; }
die() { log "ERROR: $*"; exit 1; }

normpath() {
  _p=$1
  [ -n "$_p" ] || { printf '\n'; return; }
  _d=$(dirname -- "$_p")
  _b=$(basename -- "$_p")
  (
    cd "$_d" 2>/dev/null || exit 0
    printf '%s/%s\n' "$(pwd -P 2>/dev/null || pwd)" "$_b"
  )
}

in_path() {
  _dir=$1
  OLDIFS=$IFS; IFS=:
  for p in $PATH; do
    [ "$p" = "$_dir" ] && { IFS=$OLDIFS; return 0; }
  done
  IFS=$OLDIFS
  return 1
}

path_add_session() {
  _dir=$1
  [ -d "$_dir" ] || die "Directory not found: $_dir"
  if in_path "$_dir"; then
    log "Already in PATH: $_dir"
  else
    PATH="${PATH:+$PATH:}$_dir"
    export PATH
    log "Added to PATH (session): $_dir"
  fi
}

path_rm_session() {
  _dir=$1
  OLDIFS=$IFS; IFS=:
  NEW=""
  found=0
  for p in $PATH; do
    if [ "$p" = "$_dir" ]; then
      found=1
      continue
    fi
    if [ -z "$NEW" ]; then NEW="$p"; else NEW="${NEW}:$p"; fi
  done
  IFS=$OLDIFS
  PATH="$NEW"; export PATH
  if [ $found -eq 1 ]; then
    log "Removed from PATH (session): $_dir"
  else
    log "Not present in PATH: $_dir"
  fi
}

ensure_profile_block() {
  if [ ! -f "$PROFILE" ]; then : > "$PROFILE"; fi
  if ! grep -qF "$MARK_BEGIN" "$PROFILE" 2>/dev/null; then
    {
      printf '\n%s\n' "$MARK_BEGIN"
      printf '# Managed by pathctl.sh\n'
      printf '%s\n' "$MARK_END"
    } >>"$PROFILE"
  fi
}

profile_add() {
  _dir=$1
  ensure_profile_block
  awk -v begin="$MARK_BEGIN" -v end="$MARK_END" -v dir="$_dir" '
    BEGIN{inside=0; added=0}
    $0==begin{print; inside=1; next}
    $0==end{
      if (inside && !added) {
        print "case :$PATH: in"
        print "  *:" dir ":*) ;;"
        print "  *) PATH=\"${PATH:+$PATH:}" dir "\" ; export PATH ;;"
        print "esac"
        added=1
      }
      print; inside=0; next
    }
    {print}
  ' "$PROFILE" > "$PROFILE.tmp" && mv "$PROFILE.tmp" "$PROFILE"
  log "Persisted add in $PROFILE: $_dir"
}

profile_rm() {
  _dir=$1
  ensure_profile_block
  awk -v begin="$MARK_BEGIN" -v end="$MARK_END" -v dir="$_dir" '
    BEGIN{inside=0}
    $0==begin{print; inside=1; next}
    $0==end{print; inside=0; next}
    {
      if (inside) {
        if (index($0, dir) == 0) print
      } else {
        print
      }
    }
  ' "$PROFILE" > "$PROFILE.tmp" && mv "$PROFILE.tmp" "$PROFILE"
  log "Persisted removal in $PROFILE: $_dir"
}

cmd=$1 2>/dev/null || cmd=""
case "$cmd" in
  add)
    shift
    dir=$1 2>/dev/null || die "add requires DIR"
    persist=0
    [ "${2-}" = "--persist" ] && persist=1
    d=$(normpath "$dir")
    path_add_session "$d"
    [ $persist -eq 1 ] && profile_add "$d"
    ;;
  rm|remove|delete)
    shift
    dir=$1 2>/dev/null || die "rm requires DIR"
    persist=0
    [ "${2-}" = "--persist" ] && persist=1
    d=$(normpath "$dir")
    path_rm_session "$d"
    [ $persist -eq 1 ] && profile_rm "$d"
    ;;
  show)
    printf '%s\n' "$PATH"
    ;;
  *)
    sed -n '1,80p' "$0"; exit 1 ;;
esac
