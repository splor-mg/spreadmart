# Data mart Orçamentário (aka Spreadmart)

## Pré-requisitos

- Docker Desktop;
- R (e pacote `devtools`);
- Python.

Crie um arquivo `.env` com os valores para as variáveis de ambiente `SQLALCHEMY_URL`, `GITHUB_PAT`, `BITBUCKET_USER` e `BITBUCKET_PASSWORD`[^20231110T125652]. Existe um modelo em `.env.example`. __Não utilize aspas__. 
Este arquivo contêm variáveis de ambiente que serão inseridas no `Makefile` e parseadas aos programas durante sua execução.

[^20231110T125652]: A variável `GITHUB_PAT` é para a [personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) da sua conta no Github. As variáveis `BITBUCKET_USER` e `BITBUCKET_PASSWORD` são para acesso ao [Bitbucket](https://bitbucket.org/dcgf/workspace/overview/) da DCAF/SPLOR. Se você não tiver essa informação entre em contato com um colega de equipe.

Agora você pode instalar as dependências do R e Python[^20231110T125612]:

[^20231110T125612]: Lembre-se de criar e ativar o seu ambiente virtual no python

```bash
Rscript -e "devtools::install()"
python -m pip install -r requirements.txt
```

## Levantar o banco postgress

O arquivo `docker-compose.yml` está configurado para levantar o [PostgreSQL](https://www.postgresql.org/) (usuário: postgres; senha: postgres) e [pgAdmin](https://www.pgadmin.org/) (usuário: splor@planejamento.mg.gov.br; senha: admin). Para isso, depois de abrir o Docker Desktop, execute o seguinte código na linha de comando: 

```bash
docker compose up
```
## Uso

Depois de levantar o banco [postgres](https://github.com/splor-mg/postgresql-carga-despesa#instala%C3%A7%C3%A3o-e-configura%C3%A7%C3%A3o-do-docker) execute:

```bash
make all
```

O resultado no terminal será:

### make extract

```bash
dpm install
2023-10-20T17:50:41-0300 INFO  [dpm.install] Downloading package sisor....
2023-10-20T17:50:41-0300 INFO  [dpm.install] Data file of resource "base_orcam_despesa_item_fiscal" saved in "datapackages/sisor/data/base_orcam_despesa_item_fiscal.csv"
2023-10-20T17:50:41-0300 INFO  [dpm.install] Data file of resource "base_orcam_receita_fiscal" saved in "datapackages/sisor/data/base_orcam_receita_fiscal.csv"
2023-10-20T17:50:41-0300 INFO  [dpm.install] Downloading package reest....
2023-10-20T17:50:41-0300 INFO  [dpm.install] Using token stored in GITHUB_PAT for accessing data package reest
2023-10-20T17:50:41-0300 INFO  [dpm.install] Data file of resource "reest_rec" saved in "datapackages/reest/data/reest_rec.csv"
2023-10-20T17:50:41-0300 INFO  [dpm.install] Data file of resource "reest_desp" saved in "datapackages/reest/data/reest_desp.csv"
```

### make transform

```bash
Rscript scripts/transform.R
INFO [2023-10-20 17:50:43] Coluna(s) 'FUNCAO_COD, ACAO_COD, GRUPO_COD, IPU_COD' não está presente na base de dados. Criando chave nula 'chave_desp'
INFO [2023-10-20 17:50:43] Coluna(s) 'FUNCAO_COD, ACAO_COD, GRUPO_COD, IPU_COD' não está presente na base de dados. Criando chave nula 'chave_desp'
```

### make publish

```bash
dpm load
2023-11-10T13:05:20-0300 INFO  [dpm.load] Loading sisor.base_orcam_despesa_item_fiscal
2023-11-10T13:07:17-0300 INFO  [dpm.load] Loading sisor.base_orcam_receita_fiscal
2023-11-10T13:07:17-0300 INFO  [dpm.load] Loading reest.reest_rec
2023-11-10T13:07:18-0300 INFO  [dpm.load] Loading reest.reest_desp
dpm load --package datapackage.json
2023-11-10T13:07:20-0300 INFO  [dpm.load] Loading link.fact_loa_desp
2023-11-10T13:07:21-0300 INFO  [dpm.load] Loading link.fact_loa_rec
2023-11-10T13:07:21-0300 INFO  [dpm.load] Loading link.fact_reest_desp
2023-11-10T13:07:22-0300 INFO  [dpm.load] Loading link.fact_reest_rec
2023-11-10T13:07:24-0300 INFO  [dpm.load] Loading link.link_table
```
