.PHONY: install build serve test lint clean

install:
	tools/setup-mkdocs.sh user --upgrade --requirements requirements-dev.txt

build:
	tools/setup-mkdocs.sh build

serve:
	. $$HOME/.mkdocs/venv/bin/activate && mkdocs serve -a 0.0.0.0:8000

test:
	pytest --maxfail=1 --disable-warnings -q

lint:
	pre-commit run --all-files

clean:
	rm -rf site
