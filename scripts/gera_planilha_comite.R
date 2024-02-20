library(spreadmart)
library(toolkit)
library(data.table)
library(dplyr)
library(writexl)

config <- RcppTOML::parseTOML("relationships.toml")
siafi <- read_datapackage("datapackages/siafi/datapackage.json")
vale <- read_datapackage("datapackages/acordo_vale_brumadinho/datapackage.json")
siad <- read_datapackage("datapackages/siad/datapackage.json")
totais <- read_datapackage("https://raw.githubusercontent.com/splor-mg/armazem-siafi-totais-dados/main/datapackage.json")
rp_folha <- read_datapackage("https://raw.githubusercontent.com/splor-mg/armazem-siafi-restos-pagar-folha-dados/main/datapackage.json")

projetos <- vale$projetos_vale[!duplicated(num_contrato_entrada)]
exec_rp <- siafi$restos_pagar[
  ano %in% 2021:2024 & num_contrato_entrada %in% projetos$num_contrato_entrada
]

exec_rp[, vlr_pago_rpnp := vlr_saldo_rpp + vlr_despesa_liquidada_rpnp - vlr_despesa_liquidada_pagar]

exec_desp <- siafi$execucao[
  ano %in% 2021:2024 & num_contrato_entrada %in% projetos$num_contrato_entrada
]

execucao <- join(exec_rp, exec_desp, 
                 by = c("ano", "uo_cod", "num_contrato_entrada", "num_processo_compra", "num_contrato_saida"),
                 value.var = c("vlr_empenhado", 
                               "vlr_liquidado", 
                               "vlr_despesa_liquidada_rpnp",
                               "vlr_pago_financeiro",
                               "vlr_pago_rpnp",
                               "vlr_pago_rpp"),
                 regex = FALSE)

valores_contratos <- siad$compras[
  ,
  .(vlr_total_atualizado = sum(vlr_total_atualizado)),
  .(uo_cod, 
    num_contrato_saida)
]

info_contratos <- siad$compras[
  ,
  .(vlr_total_atualizado = sum(vlr_total_atualizado)),
  .(uo_cod, 
    num_contrato_saida,
    num_processo_compra, 
    objeto_contrato_saida,
    data_inicio_vigencia_contrato_saida, 
    data_limite_vigencia_contrato_saida)
]


dt <- left_join(execucao, 
          contratos, 
          by = c("uo_cod", "num_processo_compra", "num_contrato_saida")) |> 
      left_join(projetos, "num_contrato_entrada")

ouptut <- dt[
  ,
  .(vlr_total_atualizado_contrato = sum(vlr_total_atualizado),
    vlr_empenhado = sum(vlr_empenhado),
    vlr_liquidado = sum(vlr_despesa_liquidada_rpnp),
    vlr_pago_financeiro = sum(vlr_pago_financeiro),
    vlr_pago_rpnp = sum(vlr_pago_rpnp),
    vlr_pago_rpp = sum(vlr_pago_rpp)
    ),
  .(num_contrato_entrada, 
    projeto, 
    num_processo_compra, 
    num_contrato_saida, 
    objeto_contrato_saida, 
    data_inicio_vigencia_contrato_saida, 
    data_limite_vigencia_contrato_saida)
]

writexl::write_xlsx(ouptut, "acordo-judicial-reparacao-vale.xlsx")

