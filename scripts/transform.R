library(frictionless)
library(data.table)
library(relatorios)
library(spreadmart)
library(purrr)
library(glue)
library(rrapply)

create_fact_table_ <- function(resource_name, package_name, config) {
  datapackage <- read_package(glue("datapackages/{package_name}/datapackage.json"))
  resource <- read_resource(datapackage, resource_name) |> as.data.table()
  key_name <- config$packages[[package_name]][[resource_name]]
  create_fact_table(resource, config$keys[key_name])
}

create_fact_tables <- function(package_name, config) {
  map(names(config$packages[[package_name]]), create_fact_table_, package_name, config)  
}

config <- RcppTOML::parseTOML("relationships.toml")

resource_names <- map(config$packages, names) |> unlist() |> unname()

fact_tables <- map(names(config$packages), create_fact_tables, config) |> 
               rrapply::rrapply(classes = "data.frame", how = "flatten") |> 
               set_names(resource_names)

resources <- map(names(config$packages), \(package_name) read_datapackage(glue("datapackages/{package_name}/datapackage.json"))) |> 
              rrapply::rrapply(classes = "data.frame", how = "flatten")

link_table <- create_link_table(resources, keys = config$keys)

fact_tables |> imap(\(value, key) fwrite(value, glue("data/fact_{key}.csv")))

fwrite(link_table, "data/link_table.csv")