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

# OS detection (POSIX)
OS_UNAME=$(uname -s 2>/dev/null || echo unknown)
case "$OS_UNAME" in
  FreeBSD) OS_FAMILY="freebsd" ;;
  Linux)   OS_FAMILY="linux" ;;
  Darwin)  OS_FAMILY="darwin" ;;  # not used but harmless
  *)       OS_FAMILY="unknown" ;;
esac

# Resolve python3 path
if command -v python3 >/dev/null 2>&1; then
  PYTHON_BIN=$(command -v python3)
elif [ -x /usr/local/bin/python3 ]; then
  PYTHON_BIN=/usr/local/bin/python3
else
  PYTHON_BIN=python3
fi

# Portable mktemp directory
TMPDIR=${TMPDIR:-/tmp}
WORKDIR=$(mktemp -d "${TMPDIR%/}/mkdocs.XXXXXX") || WORKDIR="${TMPDIR%/}/mkdocs.$$"

# Ensure cleanup
trap 'rm -rf "$WORKDIR"' EXIT INT HUP TERM

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
  set -eu
  PMMODE="auto"    # auto|pkg|portmaster
  ASSUME_YES=false
  PORTSNAP=false

  # parse flags: -y/--yes, --pkg, --portmaster, --portsnap
  while [ $# -gt 0 ]; do
    case "$1" in
      -y|--yes) ASSUME_YES=true ;;
      --pkg) PMMODE="pkg" ;;
      --portmaster) PMMODE="portmaster" ;;
      --portsnap) PORTSNAP=true ;;
    esac
    shift || true
  done

  echo "[INFO] root installer for $OS_FAMILY (mode=${PMMODE})"

  if [ "$OS_FAMILY" = "freebsd" ] ; then
    # Decide tool automatically if requested
    if [ "$PMMODE" = "auto" ]; then
      if command -v portmaster >/dev/null 2>&1; then PMMODE="portmaster"; else PMMODE="pkg"; fi
    fi

    if [ "$PMMODE" = "pkg" ]; then
      : "${ASSUME_ALWAYS_YES:=${ASSUME_YES:+YES}}"
      export ASSUME_ALWAYS_YES=${ASSUME_ALWAYS_YES:-YES}
      pkg update || true
      pkg install -y python3 py3-pip cairo pango pkgconf libxslt || true
      pkg install -y node npm || true
    else
      # portmaster branch
      if [ "$PORTSNAP" = "true" ]; then
        if command -v portsnap >/dev/null 2>&1; then
          echo "[INFO] Updating ports tree via portsnap"
          portsnap fetch update || true
        else
          echo "[WARN] portsnap not found, skipping ports tree update"
        fi
      fi
      # Install via ports
      # Use -y when ASSUME_YES; otherwise interactive
      PMFLAGS=""
      $ASSUME_YES && PMFLAGS="-y" || PMFLAGS=""
      # Core toolchain
      portmaster $PMFLAGS lang/python devel/py-pip || true
      # Rendering stack for CairoSVG etc.
      portmaster $PMFLAGS graphics/cairo x11-toolkits/pango devel/pkgconf textproc/libxslt || true
      # Optional Node for CI and screenshots
      portmaster $PMFLAGS www/node www/npm || true
    fi

  elif [ "$OS_FAMILY" = "linux" ]; then
    if command -v apt-get >/dev/null 2>&1; then
      apt-get update
      apt-get install -y python3 python3-venv python3-pip nodejs npm
    elif command -v dnf >/dev/null 2>&1; then
      dnf install -y python3 python3-pip python3-virtualenv nodejs npm
    elif command -v yum >/dev/null 2>&1; then
      yum install -y python3 python3-pip python3-virtualenv nodejs npm
    else
      echo "[WARN] Unknown Linux distro. Install Python3 + pip + venv manually."
    fi
  else
    echo "[INFO] Use PowerShell script on Windows: tools/Setup-MKDocs.ps1"
  fi
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
  set -eu
  UPGRADE=false
  SYNC=true
  REQS="requirements.txt"
  while [ $# -gt 0 ]; do
    case "$1" in
      --upgrade) UPGRADE=true ;;
      --no-sync) SYNC=false ;;
      --requirements) shift; REQS="$1" ;;
    esac
    shift || true
  done
  VENV_DIR="${HOME}/.mkdocs/venv"
  DATA_DIR="${HOME}/.mkdocs/data"
  mkdir -p "$VENV_DIR" "$DATA_DIR"
  if [ ! -x "$VENV_DIR/bin/python" ]; then
    echo "[INFO] Creating venv at $VENV_DIR with $PYTHON_BIN"
    "$PYTHON_BIN" -m venv "$VENV_DIR"
  fi
  # Upgrade pip/wheels
  "$VENV_DIR/bin/python" -m pip install --upgrade pip wheel
  if [ -f "$REQS" ]; then
    echo "[INFO] Installing from $REQS"
    "$VENV_DIR/bin/python" -m pip install -r "$REQS"
  else
    echo "[WARN] $REQS not found"
  fi
  if $UPGRADE; then
    "$VENV_DIR/bin/python" -m pip install -U -r "$REQS" || true
  fi
  if $SYNC; then
    echo "[INFO] Sync repo -> $DATA_DIR"
    # portable copy: tar to preserve mode/time
    (cd "$(pwd)"; tar -cf - .) | (cd "$DATA_DIR"; tar -xf -)
  fi
  echo "[OK] venv ready: source "$VENV_DIR/bin/activate""
}
 serve -a 127.0.0.1:8000"
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
  set -eu
  MODE="${1:-preview}"; shift || true
    while [ $# -gt 0 ]; do
    case "$1" in
      --strict)     esac
    shift || true
  done
  if [ -x "${HOME}/.mkdocs/venv/bin/mkdocs" ]; then
    MK="${HOME}/.mkdocs/venv/bin/mkdocs"
  else
    MK="mkdocs"
  fi
  echo "[INFO] Build mode=${MODE}"
  $MK build 
}
 build"
    "$MKDOCS" build
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
# deploy to webroot
sudo rm -rf /data/www/vhosts/www.rootservice.org/data
sudo cp -a ./site /data/www/vhosts/www.rootservice.org/data
sudo cp -a ./docs/.well-known /data/www/vhosts/www.rootservice.org/data/
sudo chown -R www:www /data/www/vhosts/www.rootservice.org/data
}

cmd_serve() {
  set -eu
  MODE="${1:-preview}"; shift || true
  ADDR="0.0.0.0:8000"
  while [ $# -gt 0 ]; do
    case "$1" in
      --addr) shift; ADDR="$1" ;;
    esac
    shift || true
  done
  if [ -x "${HOME}/.mkdocs/venv/bin/mkdocs" ]; then
    MK="${HOME}/.mkdocs/venv/bin/mkdocs"
  else
    MK="mkdocs"
  fi
  echo "[INFO] Serving at http://${ADDR}"
  exec $MK serve -a "$ADDR"
}
 serve -a ${ADDR} (cwd=$(pwd))"
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
