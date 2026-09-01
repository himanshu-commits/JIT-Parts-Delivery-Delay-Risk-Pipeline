.PHONY: setup data etl viz all clean lint tf-validate

PY ?= ./.venv/bin/python
RISK_THRESHOLD ?= 12
SEED ?= 42

setup:
	python3 -m venv .venv
	./.venv/bin/pip install --upgrade pip
	./.venv/bin/pip install -r requirements.txt

data:
	$(PY) generate_mock_data.py --seed $(SEED)

etl:
	$(PY) etl.py --risk-threshold-hours $(RISK_THRESHOLD)

viz:
	$(PY) visualize.py

all: data etl viz

lint:
	./.venv/bin/ruff check .

tf-validate:
	cd terraform && terraform init -backend=false && terraform validate

clean:
	rm -rf data output dist
