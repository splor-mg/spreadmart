# Data mart Orçamentário (aka Spreadmart)

## [Instalação e configuração do docker](https://github.com/splor-mg/postgresql-carga-despesa/tree/main#instala%C3%A7%C3%A3o-e-configura%C3%A7%C3%A3o-do-docker)

- Baixar e instalar o Docker Desktop.

### [Uso](https://github.com/splor-mg/postgresql-carga-despesa/tree/main#uso)

O arquivo `docker-compose.yml` está configurado para levantar o [PostgreSQL](https://www.postgresql.org/) (usuário: postgres; senha: postgres) e [pgAdmin](https://www.pgadmin.org/) (usuário: [splor@planejamento.mg.gov.br](mailto:splor@planejamento.mg.gov.br); senha: admin). Para isso execute na linha de comando (depois de abrir o Docker Desktop)

```shell
docker compose up
```

O pgAdmin está disponível em [http://localhost:5050/](http://localhost:5050/). É necessário inserir a senha default `postgres` para conexão ao banco.

Se o cliente `psql` estiver instalado é possível se conectar ao banco de dados com:

```shell
psql -h localhost -U postgres -W
```
