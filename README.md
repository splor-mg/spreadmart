# Data mart Orçamentário (aka Spreadmart)

## Pré-requisitos

- Docker Desktop;
- R (e pacote `devtools`);
- Python.

Criar as variáveis de ambiente `BITBUCKET_USER` e `BITBUCKET_PASSWORD` para acesso ao Bitbucket da DCAF e instalar as dependências do R e Python:

```bash
Rscript -e "devtools::install()"
python -m pip install -r requirements.txt
```

## Uso

Depois de levantar o banco [postgres](https://github.com/splor-mg/postgresql-carga-despesa#instala%C3%A7%C3%A3o-e-configura%C3%A7%C3%A3o-do-docker) execute:

```bash
make all
```

O resultado no terminal será:

```bash
dpm install
2023-10-20T17:50:41-0300 INFO  [dpm.install] Downloading package sisor....
2023-10-20T17:50:41-0300 INFO  [dpm.install] Data file of resource "base_orcam_despesa_item_fiscal" saved in "datapackages/sisor/data/base_orcam_despesa_item_fiscal.csv"
2023-10-20T17:50:41-0300 INFO  [dpm.install] Data file of resource "base_orcam_receita_fiscal" saved in "datapackages/sisor/data/base_orcam_receita_fiscal.csv"
2023-10-20T17:50:41-0300 INFO  [dpm.install] Downloading package reest....
2023-10-20T17:50:41-0300 INFO  [dpm.install] Using token stored in GITHUB_PAT for accessing data package reest
2023-10-20T17:50:41-0300 INFO  [dpm.install] Data file of resource "reest_rec" saved in "datapackages/reest/data/reest_rec.csv"
2023-10-20T17:50:41-0300 INFO  [dpm.install] Data file of resource "reest_desp" saved in "datapackages/reest/data/reest_desp.csv"
Rscript scripts/transform.R
INFO [2023-10-20 17:50:43] Coluna(s) 'FUNCAO_COD, ACAO_COD, GRUPO_COD, IPU_COD' não está presente na base de dados. Criando chave nula 'chave_desp'
INFO [2023-10-20 17:50:43] Coluna(s) 'FUNCAO_COD, ACAO_COD, GRUPO_COD, IPU_COD' não está presente na base de dados. Criando chave nula 'chave_desp'
dpm load --package datapackage.json
2023-10-20T17:50:43-0300 INFO  [dpm.load] Loading link.fact_loa_desp
2023-10-20T17:50:44-0300 INFO  [dpm.load] Loading link.fact_loa_rec
2023-10-20T17:50:44-0300 INFO  [dpm.load] Loading link.fact_reest_desp
2023-10-20T17:50:46-0300 INFO  [dpm.load] Loading link.fact_reest_rec
2023-10-20T17:50:47-0300 INFO  [dpm.load] Loading link.link_table
```

Um novo schema `link` será criado no banco de dados com a modelagem linktable para as bases da reestimativa e sisor.
