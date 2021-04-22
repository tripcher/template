PROJECT_NAME ?= {{cookiecutter.project_name}}
VERSION ?= 0.1.0

all:
	@echo "make lint		- Check code with flake8"
	@echo "make format		- Format code with isort"
	@echo "make test		- Run tests"
	@exit 0

lint:
	poetry run flake8 .

format:
	poetry run isort --atomic .

test: lint
	poetry run pytest -vv --cov=analyzer --cov-report=term-missing tests
