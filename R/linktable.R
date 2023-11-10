#' @import data.table

link <- function(dt, keys) {
  data <- data.table::copy(dt)
  keep_columns <- unique(unlist(keys))
  cols_to_drop <- setdiff(names(data), keep_columns)
  data[, (cols_to_drop) := NULL]  
  for (key in names(keys)) {
    cols <- keys[[key]]
    if (!all(cols %in% names(data))) {
      msg <- paste0(cols[!cols %in% names(data)], collapse = ', ')
      logger::log_info("Coluna(s) '{msg}' não está presente na base de dados. Criando chave nula '{key}'")
      data[, (key) := NA_character_]
    } else {
      data[, (key) := do.call(paste, c(.SD, sep = "|")), .SDcols = cols]  
    }
  }
  data.table::setcolorder(data, names(keys))
  unique(data)
}

safe_link <- purrr::safely(link)

#' @export
create_link_table <- function(..., keys) {
  # Capture the names of the variables passed as ...
  dt_names <- as.character(substitute(list(...))[-1L])
  
  # Create a named list using the variable names as keys
  dt_list <- setNames(list(...), dt_names)
  dt_transformed <- lapply(dt_list, link, keys = keys)
  unique(data.table::rbindlist(dt_transformed, fill = TRUE))
}

#' @export
create_fact_table <- function(dt, key, drop_columns = NULL) {
  data <- data.table::copy(dt)
  key_name <- names(key)
  cols <- key[[key_name]]
  if (!all(cols %in% names(data))) {
      data[, (key_name) := NA_character_]
    } else {
      data[, (key_name) := do.call(paste, c(.SD, sep = "|")), .SDcols = cols]  
    }
  cols_rm <- intersect(names(data), unique(unlist(key))) 
  data[, (c(cols_rm, drop_columns)) := NULL]
  data.table::setcolorder(data, key_name)
  data[]
}
