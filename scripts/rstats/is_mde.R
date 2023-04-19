library(relatorios); library(DBI)

?is_mde_desp

con <- dbConnect(duckdb::duckdb(), dbdir = "data/db.duckdb", read_only = FALSE)

