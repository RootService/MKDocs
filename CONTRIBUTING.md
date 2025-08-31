# Contributing

## Setup
```shell
python -m venv .venv && . .venv/bin/activate
pip install -r requirements-dev.txt
pre-commit install
```

## Build
```shell
mkdocs build --strict
CSP_ENV=preview python tools/update_server_headers.py
```

## Commit style
Conventional commits preferred: feat:, fix:, docs:, chore:.
