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

Um novo schema `link` será criado no banco de dados com a modelagem linktable.
