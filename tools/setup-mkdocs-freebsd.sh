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

BASE_DIR="${HOME}/.mkdocs"
VENV_DIR="${BASE_DIR}/venv"
DATA_DIR="${BASE_DIR}/data"
DATA_WEB="/data/www/vhosts/www.rootservice.org/data"
MKDOCS_BIN="${VENV_DIR}/bin/mkdocs"
PYTHON_BIN="${VENV_DIR}/bin/python"
NPM_USER_PREFIX="${HOME}/.local"
PORTS_TREE="/usr/ports"

TMPDIR=${TMPDIR:-/tmp}
WORKDIR=$(mktemp -d "${TMPDIR%/}/mkdocs.XXXXXX") || WORKDIR="${TMPDIR%/}/mkdocs.$$"

trap 'rm -rf "${WORKDIR}"' EXIT INT HUP TERM

log() { printf '%s\n' "$*" >&2; }
die() { log ">> ERROR: $*"; exit 1; }
require_non_root() { [ "$(id -u)" -ne 0 ] || die "run this subcommand as a regular user"; }

ensure_ports_tree() {
  if [ -f "${PORTS_TREE}/Mk/bsd.port.mk" ]; then
    return 0;
  fi
  command -v git || die "git required to fetch ports tree"
  log ">> Fetching ports tree to ${PORTS_TREE}"
  if [ -d "${PORTS_TREE}/.git" ]; then
    git -C "${PORTS_TREE}" pull --ff-only || die "ports git pull failed"
  else
    git clone --depth 1 https://git.FreeBSD.org/ports.git "${PORTS_TREE}" || die "ports git clone failed"
  fi
}

install_portmaster_if_needed() {
  if command -v portmaster; then
    return 0;
  fi
  log ">> Installing ports-mgmt/portmaster"
  env BATCH=yes make -C "${PORTS_TREE}/ports-mgmt/portmaster" install clean || die "installing portmaster failed"
}

python_bin() {
  if [ -x "${PYTHON_BIN}" ]; then
    printf '%s\n' "${PYTHON_BIN}"
  elif command -v python3; then
    command -v python3
  else
    die "python3 not found"
  fi
}

PYTHON_BIN="$(python_bin)"

ensure_venv() {
  if [ ! -d "${VENV_DIR}" ]; then
    PYTHON_SYS="/usr/local/bin/python3"
    log ">> Creating virtualenv at ${VENV_DIR} with system ${PYTHON_SYS}"
    "${PYTHON_SYS}" -m venv "${VENV_DIR}" || die "venv creation failed"
  else
    ver=$("${PYTHON_BIN}" -V 2>/dev/null || printf unknown)
    log ">> Reusing virtualenv at ${VENV_DIR} (python: ${ver})"
  fi
}

ensure_datadir() {
  if [ ! -d "${DATA_DIR}" ]; then
    mkdir -p "${DATA_DIR}"
    log ">> Created datadir: ${DATA_DIR}"
  fi
}

sync_repo_to_datadir() {
  ensure_datadir
  log ">> [INFO] Sync repo -> ${DATA_DIR}"
  # portable copy: tar to preserve mode/time
  (cd "$(pwd)"; tar -cf - .) | (cd "${DATA_DIR}"; tar -xf -)

  # cleanup snippets/ports
  sed -E -e '/^#[[:space:]]/d' -i '' "${DATA_DIR}/snippets/ports/*/options"
  sed -E -e 's/[[:space:]]*$//g' -i '' "${DATA_DIR}/snippets/ports/*/options"
  sed -E -e '/^_OPTIONS_READ/ s/\,[[:digit:]]+[[:space:]]?$//g' -i '' "${DATA_DIR}/snippets/ports/*/options"
  sed -E -e '/^_OPTIONS_READ/ s/\_[[:digit:]]+[[:space:]]?$//g' -i '' "${DATA_DIR}/snippets/ports/*/options"
}

cd_datadir() {
  ensure_datadir
  cd "${DATA_DIR}" || die "cannot cd to ${DATA_DIR}"
}

find_requirements() {
  base="${1}"
  cd_datadir
  if [ -f "${base}/requirements-dev.txt" ]; then
    printf '%s\n' "${base}/requirements-dev.txt"
  elif [ -f "${base}/requirements.txt" ]; then
    printf '%s\n' "${base}/requirements.txt"
  else
    printf '%s\n' ""
  fi
}

pip_install_from_file() {
  req="${1}"; upg="${2:-0}"
  cd_datadir
  [ -x "${PYTHON_BIN}" ] || die "venv python missing: ${PYTHON_BIN}"
  if [ -z "${req}" ]; then
    log ">> No requirements file found. Skipping pip install."
    return 0
  fi
  if [ "${upg}" -eq 1 ]; then
    log ">> Upgrading pip/setuptools/wheel"
    "${PYTHON_BIN}" -m pip install --upgrade pip setuptools wheel || true
    log ">> Installing/Upgrading Python deps from $(basename "${req}")"
    "${PYTHON_BIN}" -m pip install --upgrade -r "${req}" || true
  else
    log ">> Installing Python deps from $(basename "${req}")"
    "${PYTHON_BIN}" -m pip install -r "${req}"
  fi
}

npm_user_setup() {
  cd_datadir
  if command -v npm; then
    mkdir -p "${NPM_USER_PREFIX}/bin"
    export NPM_CONFIG_PREFIX="${NPM_USER_PREFIX}"
    case ":$PATH:" in
      *":${NPM_USER_PREFIX}/bin:"*) ;;
      *) PATH="${NPM_USER_PREFIX}/bin:${PATH}"; export PATH ;;
    esac
    if ! command -v markdownlint >/dev/null 2>&1; then
      log ">> Installing markdownlint-cli to ${NPM_USER_PREFIX} (user scope)"
      npm install -g markdownlint-cli || log ">> markdownlint-cli install skipped"
    fi
  else
    log ">> npm not found; skipping markdownlint-cli"
  fi
}

mkdocs_bin() {
  if [ -x "${MKDOCS_BIN}" ]; then
    printf '%s\n' "${MKDOCS_BIN}"
  elif command -v mkdocs; then
    command -v mkdocs
  else
    die "mkdocs not found. Run 'sh setup-mkdocs.sh user' first."
  fi
}

MKDOCS_BIN="$(mkdocs_bin)"

require_mkdocs_config() {
  if [ ! -f "mkdocs.yml" ] && [ ! -f "mkdocs.yaml" ]; then
    die "mkdocs.yml not found in $(pwd). Run 'sh setup-mkdocs.sh user' to sync."
  fi
}

cmd_root() {
  set -eu
  PMMODE="auto"    # auto|pkg|portmaster
  ASSUME_YES=false
  while [ $# -gt 0 ]; do
    case "${1}" in
      -y|--yes) ASSUME_YES=true ;;
      --pkg) PMMODE="pkg" ;;
      --portmaster) PMMODE="portmaster" ;;
      --help|-h) printf '%s\n' "usage: root [-y]"; return 0 ;;
      *) die "unknown arg for root: $1" ;;
    esac
    shift || true
  done

  [ "$(id -u)" -eq 0 ] || die "run 'root' subcommand as root"

  ensure_ports_tree

  if [ "${PMMODE}" = "auto" ]; then
    if command -v portmaster >/dev/null 2>&1; then
      PMMODE="portmaster";
    else
      PMMODE="pkg";
    fi
  fi

  if [ "${PMMODE}" = "pkg" ]; then
    if ${ASSUME_YES}; then
      : "${ASSUME_ALWAYS_YES:=${ASSUME_YES:+YES}}"
      export ASSUME_ALWAYS_YES="${ASSUME_ALWAYS_YES:-YES}"
    fi
    pkg update || true
    pkg install -y python3 py3-pip libffi cairo pango gdk-pixbuf2 || true
    pkg install -y node npm || true
  else
    install_portmaster_if_needed
    PMFLAGS=""
    ${ASSUME_YES} && PMFLAGS="-y" || PMFLAGS=""
    env BATCH=yes portmaster ${PMFLAGS} lang/python devel/py-pip || true
    env BATCH=yes portmaster ${PMFLAGS} devel/libffi graphics/cairo x11-toolkits/pango graphics/gdk-pixbuf2 || true
    env BATCH=yes portmaster ${PMFLAGS} www/node www/npm || true
  fi
}

cmd_user() {
  set -eu
  UPGRADE=false
  SYNC=true
  while [ $# -gt 0 ]; do
    case "${1}" in
      --upgrade) UPGRADE=true ;;
      --no-sync) SYNC=false ;;
      --help|-h) printf '%s\n' "usage: user [--upgrade] [--no-sync]"; return 0 ;;
      *) die "unknown arg for user: $1" ;;
    esac
    shift || true
  done

  require_non_root

  ensure_venv
  ensure_datadir

  if ${SYNC}; then
    sync_repo_to_datadir
    REQ="$(find_requirements "${DATA_DIR}")"
  else
    REQ="$(find_requirements "$(pwd)")"
  fi

  log ">> [INFO] Installing from ${REQ}"
  if ${UPGRADE}; then
    pip_install_from_file "${REQ}" 1
  else
    pip_install_from_file "${REQ}" 0
  fi

  log ">> [OK] venv ready: source ${VENV_DIR}/bin/activate"

  cd_datadir
  npm_user_setup
  log ">> Working directory: $(pwd)"
  log ">> Tip: ${MKDOCS_BIN} serve -a 127.0.0.1:8000"
}

cmd_build() {
  set -eu
  MODE="${1:-preview}"; shift || true
  STRICT=false
  while [ $# -gt 0 ]; do
    case "${1}" in
      --strict) STRICT=true ;;
      --help|-h) printf '%s\n' "usage: build [preview|production] [--strict]"; return 0 ;;
      *) die "unknown arg for build: $1" ;;
    esac
    shift || true
  done

  require_non_root

  cd_datadir
  require_mkdocs_config

  export CSP_ENV="${MODE}"
  log ">> CSP_ENV=${CSP_ENV}"

  if ${STRICT}; then
    log ">> ${MKDOCS_BIN} build --strict"
    "${MKDOCS_BIN}" build --strict
  else
    log ">> ${MKDOCS_BIN} build"
    "${MKDOCS_BIN}" build
  fi

  if [ -f "${DATA_DIR}/tools/update_server_headers.py" ]; then
    log ">> Running ${DATA_DIR}/tools/update_server_headers.py with ${PYTHON_BIN}"
    "${PYTHON_BIN}" "${DATA_DIR}/tools/update_server_headers.py" || log ">> header update script returned non-zero"
  fi
  log ">> Build complete -> $(pwd)/site"

  # deploy to webroot
  sudo rm -rf "${DATA_WEB}"
  sudo cp -a "${DATA_DIR}/site" "${DATA_WEB}"
  sudo cp -a "${DATA_DIR}/docs/.well-known" "${DATA_WEB}/"
  sudo chown -R www:www "${DATA_WEB}"
}

cmd_serve() {
  set -eu
  MODE="${1:-preview}"; shift || true
  ADDR="0.0.0.0:8000"
  while [ $# -gt 0 ]; do
    case "${1}" in
      --addr) shift || die "--addr needs HOST:PORT"; ADDR="${1}" ;;
      --help|-h) printf '%s\n' "usage: serve [preview|production] [--addr HOST:PORT]"; return 0 ;;
      *) die "unknown arg for serve: $1" ;;
    esac
    shift || true
  done

  require_non_root

  cd_datadir
  require_mkdocs_config

  export CSP_ENV="${MODE}"
  log ">> CSP_ENV=${CSP_ENV}"

  log ">> ${MKDOCS_BIN} serve -a ${ADDR} (cwd=$(pwd))"
  log ">> [INFO] Serving at http://${ADDR}"
  exec ${MKDOCS_BIN} serve -a "${ADDR}"
}

cmd_clean() {
  NPM=false
  [ "${1:-}" = "--npm" ] && NPM=true

  require_non_root

  cd_datadir

  if [ -d "${DATA_DIR}/site" ]; then
    log ">> Removing ${DATA_DIR}/site"
    rm -rf "${DATA_DIR}/site"
  fi
  if [ -d "${DATA_DIR}/.cache" ]; then
    log ">> Removing ${DATA_DIR}/.cache"
    rm -rf "${DATA_DIR}/.cache"
  fi
  log ">> Removing __pycache__"
  find "${DATA_DIR}/" -type d -name '__pycache__' -depth -exec rm -rf {} + 2>/dev/null || true
  if ${NPM}; then
    if command -v npm; then
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
case "${sub}" in
  "")
    if [ "$(id -u)" -eq 0 ]; then
      die "no subcommand. run as non-root for default 'user+build' or use 'root' for system installs"
    fi
    cmd_user "$@"
    cmd_build "$@"
    ;;
  root) shift; cmd_root "$@";;
  user) shift; cmd_user "$@";;
  build) shift; cmd_build "$@";;
  serve) shift; cmd_serve "$@";;
  clean) shift; cmd_clean "$@";;
  -h|--help|help) usage ;;
  *) die "unknown subcommand: ${sub}" ;;
esac
