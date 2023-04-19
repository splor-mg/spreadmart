# Data package manager (dpkgm)

## Extração

O arquivo `datapackage.yaml` contém todas as dependências de dados na propriedade `package.sources`. Para capturar a URL e a checksum de cada recurso no arquivo `datapackage.lock` execute:

```bash
dpkgm snapshot
```

Para efetivamente fazer o download das dependências de dados execute:

```bash
dpkgm fetch
```

Esse comando vai sobrescrever suas fontes de dados de acordo com as novas versões que foram publicadas. No entanto, arquivos de dados que por ventura não tenham tido nenhuma modificação não terão nenhuma modificação, inclusive de _timestamp_. Isso é proposital para que seja possível realizar processamentos incrementais.

Para estruturalmente os arquivos de dados execute:

```bash
frictionless validate --checks pick-syntax-checks datapackages/
```

Para realizar a carga na _staging area_ execute:

```bash
frictionless index datapackages/ sqlite:///data/staging/db.sqlite
```

## Validação

Como os dados primários podem sofrer alteração sem controle centralizado, as validações de conteúdo são feitas depois dos dados carregados para a _staging area_. Essa etapa vai permitir a determinação de mudanças de schema e no conteúdo dos dados primários.

```bash
frictionless validate data/staging/datapackage.json
```

## Carga

## Transformação

## Validação

Por fim são executados as validações de regras de negócio.