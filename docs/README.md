# Data package manager (dpkgm)

## Extração

O arquivo `datapackage.yaml` contém todas as fontes de dados do projeto na propriedade `package.sources`.
Cada fonte de dados é um data package frictionless ou um conjunto de dados do CKAN.

Para fazer o download de todos os recursos e armazenar na pasta `data/raw/` execute:

```bash
make extract
```

Para copiar para a pasta `data/staging/` somente os recursos que tiveram modificação execute:

```bash
make ingest
```

Nesse momento é possível que tenha sido feita a ingestão de novos recursos e mudanças 

```bash
make load # load all 
```

```bash
frictionless validate data/staging/datapackage.json
```

```bash
make transform
```

```bash
make check
```

```bash
frictionless validate datapackage.yaml
```