.PHONY: all extract transform publish

include .env

all: extract transform publish

extract:
	dpm install

transform:
	Rscript scripts/transform.R

publish:
	dpm load --package datapackage.json
