#' @export
read_datapackage <- function(path) {
  if (!is_url(path)) {
    path <- here::here(path)
  }
  package <- suppressMessages(frictionless::read_package(path))
  resource_names <- frictionless::resources(package)
  result <- lapply(resource_names, function(resource_name) {
    data.table::as.data.table(frictionless::read_resource(package, resource_name))
  })
  names(result) <- resource_names
  result
}

is_url <- function(x) {
  grepl("http:|https:", x)
}
