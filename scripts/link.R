library(frictionless)
library(data.table)
library(relatorios)
library(spreadmart)
library(purrr)
library(glue)
library(checksplanejamento)

create_fact_table_ <- function(resource_name, package_name, config) {
  datapackage <- read_package(glue("datapackages/{package_name}/datapackage.json"))
  resource <- read_resource(datapackage, resource_name) |> as.data.table()
  key_name <- config$packages[[package_name]][[resource_name]]
  create_fact_table(resource, config$keys[key_name])
}

create_fact_tables <- function(package_name, config) {
  resource_names <- names(config$packages[[package_name]])
  map(resource_names, create_fact_table_, package_name, config) |> set_names(resource_names)
}

config <- RcppTOML::parseTOML("relationships.toml")

fact_tables <- map(names(config$packages), create_fact_tables, config) |> list_flatten()

iwalk(fact_tables, \(x, idx) fwrite(x, glue("data/{idx}.csv")))

all_resources <- map(names(config$packages), ~ read_datapackage(glue("datapackages/{.x}/datapackage.json"))) |> 
  list_flatten()

link_table <- create_link_table(all_resources, keys = config$keys)
fwrite(link_table, "data/link_table.csv")
