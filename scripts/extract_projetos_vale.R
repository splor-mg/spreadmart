library(data.table)
library(frictionless)

dt <- fread("https://dados.mg.gov.br/dataset/a71cf265-da22-4c73-acf5-9076637f726b/resource/01d05dc0-073a-4b16-9c75-8791d70cf885/download/projetos_acordo_judicial_reparacao_vale.csv", sep = ";", dec = ",")
setnames(dt, old = "codigo_projeto", new = "num_contrato_entrada")

package <- create_package()
package <- append(package, c(name = "acordo_vale_brumadinho"))
package <- add_resource(package, "projetos_vale", dt)

write_package(package, "datapackages/acordo_vale_brumadinho")
