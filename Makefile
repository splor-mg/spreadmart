.PHONY: all extract transform publish

include .env

all: extract transform publish

extract:
	dpm install
	Rscript scripts/extract_projetos_vale.R
	dpm concat datapackages/siafi*/**/datapackage.json --output-dir datapackages/siafi/data
	cd datapackages/siafi && frictionless describe --stats data/*.csv --type package --json > datapackage.json
	jq '. + {"name": "siafi"}' datapackages/siafi/datapackage.json > datapackage.json.tmp && mv datapackage.json.tmp datapackages/siafi/datapackage.json
	jq '.resources |= map(. + {"profile": "tabular-data-resource"})' datapackages/siafi/datapackage.json > datapackage.json.tmp && mv datapackage.json.tmp datapackages/siafi/datapackage.json


transform:
	Rscript scripts/transform.R
	frictionless describe --stats data/*.csv --type package --json > datapackage.json
	jq '. + {"name": "link"}' datapackage.json > datapackage.json.tmp && mv datapackage.json.tmp datapackage.json

publish:
	dpm load
	dpm load --package datapackage.json

clean:
	@rm -f data/*.csv