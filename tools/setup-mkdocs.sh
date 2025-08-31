#!/bin/sh
###############################################################################
# setup-mkdocs.sh
# FreeBSD 14+ POSIX /bin/sh toolbox for MkDocs/Material
#
# Subcommands:
#   root  [-y]                Install deps with ports/portmaster (system-wide).
#   user  [--upgrade] [--no-sync]
#                             Create/refresh venv in ~/.mkdocs using system python3,
#                             sync repo to ~/.mkdocs/data, install from requirements.
#   build [preview|production] [--strict]
#   serve [preview|production] [--addr HOST:PORT]
#   clean [--npm]
#
# Conventions:
#   - System-Python: uses /usr/local/bin/python3 from ports (no version flags).
#   - Venv base:  $HOME/.mkdocs
#   - Datadir:    $HOME/.mkdocs/data   (working tree for mkdocs)
#   - mkdocs runs from datadir
#   - npm installs to $HOME/.local (user scope)
#   - Python deps from requirements-dev.txt or requirements.txt
###############################################################################

set -eu

VENVDIR="${HOME}/.mkdocs"
DATADIR="${HOME}/.mkdocs/data"
MKDOCS_BIN="${VENVDIR}/bin/mkdocs"
PYTHON_BIN="${VENVDIR}/bin/python"
NPM_USER_PREFIX="${HOME}/.local"
PORTS_TREE="/usr/ports"

log() { printf '%s\n' "$*" >&2; }
die() { log "ERROR: $*"; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

require_non_root() { [ "$(id -u)" -ne 0 ] || die "run this subcommand as a regular user"; }

# ---- Ports / root mode -------------------------------------------------------
ensure_ports_tree() {
  if [ -f "${PORTS_TREE}/Mk/bsd.port.mk" ]; then return 0; fi
  have git || die "git required to fetch ports tree"
  log ">> Fetching ports tree to ${PORTS_TREE}"
  if [ -d "${PORTS_TREE}/.git" ]; then
    git -C "${PORTS_TREE}" pull --ff-only || die "ports git pull failed"
  else
    git clone --depth 1 https://git.FreeBSD.org/ports.git "${PORTS_TREE}" || die "ports git clone failed"
  fi
}

install_portmaster_if_needed() {
  if have portmaster; then return 0; fi
  log ">> Installing ports-mgmt/portmaster"
  env BATCH=yes make -C "${PORTS_TREE}/ports-mgmt/portmaster" install clean || die "installing portmaster failed"
}

cmd_root() {
  # args: [-y]
  [ "$(id -u)" -eq 0 ] || die "run 'root' subcommand as root"
  YES=0
  while [ "$#" -gt 0 ]; do
    case "$1" in
      -y) YES=1 ;;
      --help|-h) printf '%s\n' "usage: root [-y]"; return 0 ;;
      *) die "unknown arg for root: $1" ;;
    esac
    shift
  done

  ensure_ports_tree
  install_portmaster_if_needed

  PMFLAGS="-G"; [ $YES -eq 1 ] && PMFLAGS="$PMFLAGS -y"

  # Base ports including meta 'lang/python3' and pip (default flavor).
  BASE_PORTS="devel/git lang/python3 devel/py-pip www/node graphics/cairo x11-toolkits/pango graphics/gdk-pixbuf2 devel/libffi textproc/libxml2 textproc/libxslt"
  log ">> Installing via portmaster: $BASE_PORTS"
  env BATCH=yes portmaster $PMFLAGS $BASE_PORTS || die "portmaster failed installing base ports"

  # Assert system python3 presence
  command -v python3 >/dev/null 2>&1 || die "python3 not found after install. Check ports configuration."
  log ">> System python3: $(command -v python3)"
}

# ---- User mode / venv and requirements --------------------------------------
ensure_venv() {
  command -v python3 >/dev/null 2>&1 || die "python3 not found. Run 'sudo sh setup-mkdocs.sh root -y' first."
  if [ ! -d "$VENVDIR" ]; then
    log ">> Creating virtualenv at $VENVDIR with system python3"
    python3 -m venv "$VENVDIR" || die "venv creation failed"
  else
    ver=$("$VENVDIR/bin/python" -V 2>/dev/null || printf unknown)
    log ">> Reusing virtualenv at $VENVDIR (python: $ver)"
  fi
}

find_requirements() {
  base="$1"
  if [ -f "${base}/requirements-dev.txt" ]; then
    printf '%s\n' "${base}/requirements-dev.txt"
  elif [ -f "${base}/requirements.txt" ]; then
    printf '%s\n' "${base}/requirements.txt"
  else
    printf '%s\n' ""
  fi
}

pip_install_from_file() {
  req="$1"; upg="${2:-0}"
  [ -x "$PYTHON_BIN" ] || die "venv python missing: $PYTHON_BIN"
  if [ -z "$req" ]; then
    log ">> No requirements file found. Skipping pip install."
    return 0
  fi
  if [ "$upg" -eq 1 ]; then
    log ">> Upgrading pip/setuptools/wheel"
    "$PYTHON_BIN" -m pip install --upgrade pip setuptools wheel
  fi
  log ">> Installing Python deps from $(basename "$req")"
  "$PYTHON_BIN" -m pip install -r "$req"
}

npm_user_setup() {
  if have npm; then
    mkdir -p "${NPM_USER_PREFIX}/bin"
    export NPM_CONFIG_PREFIX="${NPM_USER_PREFIX}"
    case ":$PATH:" in
      *":${NPM_USER_PREFIX}/bin:"*) ;;
      *) PATH="${NPM_USER_PREFIX}/bin:${PATH}"; export PATH ;;
    esac
    if ! command -v markdownlint >/dev/null 2>&1; then
      log ">> Installing markdownlint-cli to ${NPM_USER_PREFIX} (user scope)"
      npm install -g markdownlint-cli || log "markdownlint-cli install skipped"
    fi
  else
    log ">> npm not found; skipping markdownlint-cli"
  fi
}

ensure_datadir() {
  if [ ! -d "$DATADIR" ]; then
    mkdir -p "$DATADIR"
    log ">> Created datadir: $DATADIR"
  fi
}

sync_repo_to_datadir() {
  ensure_datadir
  log ">> Syncing repo -> ${DATADIR}"
  for f in mkdocs.yml mkdocs.yaml .markdownlint.json .markdownlint.yaml .markdownlintignore requirements.txt requirements-dev.txt; do
    if [ -f "$f" ]; then cp -fp "$f" "$DATADIR/"; fi
  done
  for d in docs overrides snippets tools; do
    if [ -d "$d" ]; then
      rm -rf "${DATADIR}/$d"
      mkdir -p "${DATADIR}"
      cp -R "$d" "$DATADIR/"
    fi
  done
}

cd_datadir() {
  ensure_datadir
  cd "$DATADIR" || die "cannot cd to $DATADIR"
}

cmd_user() {
  require_non_root
  # args: [--upgrade] [--no-sync]
  UPG=0
  SYNC=1
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --upgrade) UPG=1 ;;
      --no-sync) SYNC=0 ;;
      --help|-h) printf '%s\n' "usage: user [--upgrade] [--no-sync]"; return 0 ;;
      *) die "unknown arg for user: $1" ;;
    esac
    shift
  done
  ensure_venv
  if [ $SYNC -eq 1 ]; then
    sync_repo_to_datadir
    REQ="$(find_requirements "$DATADIR")"
  else
    REQ="$(find_requirements "$(pwd)")"
  fi
  pip_install_from_file "$REQ" "$UPG"
  npm_user_setup
  cd_datadir
  log ">> Working directory: $(pwd)"
  log ">> Tip: ${MKDOCS_BIN} serve -a 127.0.0.1:8000"
}

# ---- Build/serve/clean from datadir -----------------------------------------
mkdocs_bin() {
  if [ -x "$MKDOCS_BIN" ]; then
    printf '%s\n' "$MKDOCS_BIN"
  elif have mkdocs; then
    printf '%s\n' "$(command -v mkdocs)"
  else
    die "mkdocs not found. Run 'sh setup-mkdocs.sh user' first."
  fi
}

python_bin() {
  if [ -x "$PYTHON_BIN" ]; then
    printf '%s\n' "$PYTHON_BIN"
  elif have python3; then
    printf '%s\n' "$(command -v python3)"
  else
    die "python3 not found"
  fi
}

require_mkdocs_config() {
  if [ ! -f "mkdocs.yml" ] && [ ! -f "mkdocs.yaml" ]; then
    die "mkdocs.yml not found in $(pwd). Run 'sh setup-mkdocs.sh user' to sync."
  fi
}

cmd_build() {
  require_non_root
  MODE="production"
  STRICT=0
  while [ "$#" -gt 0 ]; do
    case "$1" in
      preview|production) MODE="$1" ;;
      --strict) STRICT=1 ;;
      --help|-h) printf '%s\n' "usage: build [preview|production] [--strict]"; return 0 ;;
      *) die "unknown arg for build: $1" ;;
    esac
    shift
  done
  cd_datadir
  require_mkdocs_config
  MKDOCS=$(mkdocs_bin)
  export CSP_ENV="$MODE"
  log ">> CSP_ENV=$CSP_ENV"
  if [ $STRICT -eq 1 ]; then
    log ">> ${MKDOCS} build --strict"
    "$MKDOCS" build --strict
  else
    log ">> ${MKDOCS} build"
    "$MKDOCS" build
  fi
  if [ -f "tools/update_server_headers.py" ]; then
    PY=$(python_bin)
    log ">> Running tools/update_server_headers.py with ${PY}"
    "$PY" tools/update_server_headers.py || log "header update script returned non-zero"
  fi
  log ">> Build complete -> $(pwd)/site"
}

cmd_serve() {
  require_non_root
  MODE="preview"
  ADDR="127.0.0.1:8000"
  while [ "$#" -gt 0 ]; do
    case "$1" in
      preview|production) MODE="$1" ;;
      --addr) shift || die "--addr needs HOST:PORT"; ADDR="$1" ;;
      --help|-h) printf '%s\n' "usage: serve [preview|production] [--addr HOST:PORT]"; return 0 ;;
      *) die "unknown arg for serve: $1" ;;
    esac
    shift
  done
  cd_datadir
  require_mkdocs_config
  MKDOCS=$(mkdocs_bin)
  export CSP_ENV="$MODE"
  log ">> CSP_ENV=$CSP_ENV"
  log ">> ${MKDOCS} serve -a ${ADDR} (cwd=$(pwd))"
  exec "$MKDOCS" serve -a "$ADDR"
}

cmd_clean() {
  require_non_root
  NPM=0
  [ "${1:-}" = "--npm" ] && NPM=1
  cd_datadir
  if [ -d "./site" ]; then
    log ">> Removing ./site"
    rm -rf ./site
  fi
  if [ -d "./.cache" ]; then
    log ">> Removing ./.cache"
    rm -rf ./.cache
  fi
  log ">> Removing __pycache__"
  find . -type d -name '__pycache__' -depth -exec rm -rf {} + 2>/dev/null || true
  if [ $NPM -eq 1 ]; then
    if have npm; then
      log ">> Cleaning npm cache (user scope)"
      npm cache clean --force || true
    else
      log ">> npm not found. Skip npm cache clean"
    fi
  fi
  log ">> Cleanup complete"
}

usage() {
  cat <<'USAGE'
Usage:
  setup-mkdocs.sh                 # default: runs 'user' then 'build production'
  setup-mkdocs.sh root  [-y]
  setup-mkdocs.sh user  [--upgrade] [--no-sync]
  setup-mkdocs.sh build [preview|production] [--strict]
  setup-mkdocs.sh serve [preview|production] [--addr HOST:PORT]
  setup-mkdocs.sh clean [--npm]
Notes:
  - Default behavior (non-root): synchronize repo to ~/.mkdocs/data, install deps, then build.
  - 'root' is only for system ports/packages and root-only actions. All other subcommands must be run as a normal user.
  - Uses system /usr/local/bin/python3 for venv creation. No version selection.
  - Python packages are installed from requirements-dev.txt (preferred) or requirements.txt.
USAGE
  exit 1
}

sub="${1:-}"
case "$sub" in
  "")
    if [ "$(id -u)" -eq 0 ]; then
      die "no subcommand. run as non-root for default 'user+build' or use 'root' for system installs"
    fi
    cmd_user "$@"
    cmd_build
    ;;
  root) shift; cmd_root "$@";;
  user) shift; cmd_user "$@";;
  build) shift; cmd_build "$@";;
  serve) shift; cmd_serve "$@";;
  clean) shift; cmd_clean "$@";;
  -h|--help|help) usage ;;
  *) die "unknown subcommand: $sub" ;;
esac
