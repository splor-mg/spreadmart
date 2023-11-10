library(frictionless)
library(data.table)
library(relatorios)
library(spreadmart)

sisor <- suppressMessages(read_package("datapackages/sisor/datapackage.json"))
loa_rec <- read_resource(sisor, "base_orcam_receita_fiscal") |> as.data.table()
loa_rec$ANO <- 2024
loa_rec$MDE  <- is_mde_rec(loa_rec)

loa_desp <- read_resource(sisor, "base_orcam_despesa_item_fiscal") |> as.data.table()
loa_desp$ANO <- 2024
loa_desp$MDE <- is_mde_desp(loa_desp)


reest <- suppressMessages(read_package("datapackages/reest/datapackage.json"))
reest_rec <- read_resource(reest, "reest_rec") |> as.data.table()
reest_rec$MDE <- is_mde_rec(reest_rec)
reest_desp <- read_resource(reest, "reest_desp") |> as.data.table()
reest_desp$MDE <- is_mde_desp(reest_desp)


chave_rec <- c("ANO", "UO_COD", "FONTE_COD", "MDE")
chave_desp <- c("ANO", "UO_COD", "FUNCAO_COD", "ACAO_COD", 
                "GRUPO_COD", "FONTE_COD", "IPU_COD", "MDE")

fact_loa_rec <- create_fact_table(loa_rec, list(chave_rec = chave_rec))
fwrite(fact_loa_rec, "data/fact_loa_rec.csv")

fact_reest_rec <- create_fact_table(reest_rec, list(chave_rec = chave_rec))
fwrite(fact_reest_rec, "data/fact_reest_rec.csv")

fact_loa_desp <- create_fact_table(loa_desp, list(chave_desp = chave_desp))
fwrite(fact_loa_desp, "data/fact_loa_desp.csv")

fact_reest_desp <- create_fact_table(reest_desp, list(chave_desp = chave_desp))
fwrite(fact_reest_desp, "data/fact_reest_desp.csv")

link_table <- create_link_table(loa_rec, loa_desp, reest_rec, reest_desp, keys = list(chave_rec = chave_rec, chave_desp = chave_desp))
fwrite(link_table, "data/link_table.csv")
