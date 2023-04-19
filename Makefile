.PHONY: fetch

fetch:
	ckanapi dump datasets --remote https://dados.mg.gov.br/ --datapackages=datapackages despesa
