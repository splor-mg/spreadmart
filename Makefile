.PHONY: all extract transform publish

include .env

all: extract transform publish

extract:
	dpm install

transform:
	Rscript scripts/transform.R
	frictionless describe --stats data/*.csv --type package --json > datapackage.json
	jq '. + {"name": "link"}' datapackage.json > datapackage.json.tmp && mv datapackage.json.tmp datapackage.json

publish:
	dpm load
	dpm load --package datapackage.json

clean:
	@rm -f data/*.csv