# 03_r_first_steps_solution.R
# Эталонное решение для преподавателя.
# Скрипт выполняет первый запуск R на знакомом кейсе и сохраняет контрольные таблицы.

library(tidyverse)
library(readxl)
library(jsonlite)

sales_path <- "data/raw/sales.csv"
products_path <- "data/raw/products.xlsx"
clients_path <- "data/raw/clients.csv"
regions_path <- "data/raw/regions.json"

required_files <- c(sales_path, products_path, clients_path, regions_path)

if (!all(file.exists(required_files))) {
  stop("Не найдены исходные файлы. Откройте проект из корневой папки или файл .Rproj.")
}

if (!dir.exists("outputs")) {
  dir.create("outputs", recursive = TRUE)
}

sales <- read_csv(sales_path, show_col_types = FALSE)
products <- read_excel(products_path, sheet = "products")
clients <- read_csv(clients_path, show_col_types = FALSE)
regions <- fromJSON(regions_path) |> as_tibble()

loaded_data_summary <- tibble(
  dataset = c("sales", "products", "clients", "regions"),
  rows = c(nrow(sales), nrow(products), nrow(clients), nrow(regions)),
  columns = c(ncol(sales), ncol(products), ncol(clients), ncol(regions)),
  missing_cells = c(
    sum(is.na(sales)),
    sum(is.na(products)),
    sum(is.na(clients)),
    sum(is.na(regions))
  )
)

sales_checked <- sales |>
  mutate(
    order_date_parsed = lubridate::ymd(order_date, quiet = TRUE),
    invalid_order_date = is.na(order_date_parsed)
  )

duplicated_orders <- sales_checked |>
  add_count(order_id, name = "order_id_count") |>
  filter(order_id_count > 1) |>
  arrange(order_id)

quality_preview <- tibble(
  check_name = c(
    "invalid_order_date",
    "non_positive_quantity",
    "non_positive_unit_price",
    "discount_out_of_range",
    "duplicated_order_id_rows"
  ),
  rows_count = c(
    sum(sales_checked$invalid_order_date),
    sum(sales_checked$quantity <= 0, na.rm = TRUE),
    sum(sales_checked$unit_price <= 0, na.rm = TRUE),
    sum(sales_checked$discount < 0 | sales_checked$discount > 1, na.rm = TRUE),
    nrow(duplicated_orders)
  )
)

missing_products <- setdiff(unique(na.omit(sales$product_id)), unique(na.omit(products$product_id)))
missing_clients <- setdiff(unique(na.omit(sales$client_id)), unique(na.omit(clients$client_id)))
missing_regions <- setdiff(unique(na.omit(sales$region_id)), unique(na.omit(regions$region_id)))

reference_preview <- tibble(
  check_name = c("unknown_product_id", "unknown_client_id", "unknown_region_id"),
  unique_keys_count = c(length(missing_products), length(missing_clients), length(missing_regions))
)

# Контрольные ожидания по исходному датасету.
expected_quality <- tibble(
  check_name = c(
    "invalid_order_date",
    "non_positive_quantity",
    "non_positive_unit_price",
    "discount_out_of_range",
    "duplicated_order_id_rows"
  ),
  expected_rows_count = c(5, 4, 3, 5, 10)
)

quality_check <- quality_preview |>
  left_join(expected_quality, by = "check_name") |>
  mutate(check_passed = rows_count == expected_rows_count)

expected_reference <- tibble(
  check_name = c("unknown_product_id", "unknown_client_id", "unknown_region_id"),
  expected_unique_keys_count = c(2, 2, 2)
)

reference_check <- reference_preview |>
  left_join(expected_reference, by = "check_name") |>
  mutate(check_passed = unique_keys_count == expected_unique_keys_count)

write_csv(loaded_data_summary, "outputs/r_loaded_data_summary.csv")
write_csv(quality_preview, "outputs/r_first_quality_preview.csv")
write_csv(reference_preview, "outputs/r_reference_preview.csv")
write_csv(quality_check, "outputs/r_quality_control_check.csv")
write_csv(reference_check, "outputs/r_reference_control_check.csv")

r_decision_text <- c(
  "# Первое решение аналитика после запуска R",
  "",
  "## Общий статус",
  "Данные успешно открылись в R. Набор данных пригоден для учебного аудита, но не должен использоваться для финального отчёта без исправления критичных проблем.",
  "",
  "## Критичные наблюдения",
  paste0("- Нераспознанных дат заказа: ", quality_preview$rows_count[quality_preview$check_name == "invalid_order_date"], "."),
  paste0("- Строк с quantity <= 0: ", quality_preview$rows_count[quality_preview$check_name == "non_positive_quantity"], "."),
  paste0("- Строк с unit_price <= 0: ", quality_preview$rows_count[quality_preview$check_name == "non_positive_unit_price"], "."),
  paste0("- Строк со скидкой вне диапазона 0..1: ", quality_preview$rows_count[quality_preview$check_name == "discount_out_of_range"], "."),
  paste0("- Строк с повторяющимися order_id: ", quality_preview$rows_count[quality_preview$check_name == "duplicated_order_id_rows"], "."),
  "",
  "## Проблемы связности",
  paste0("- Неизвестных product_id: ", reference_preview$unique_keys_count[reference_preview$check_name == "unknown_product_id"], "."),
  paste0("- Неизвестных client_id: ", reference_preview$unique_keys_count[reference_preview$check_name == "unknown_client_id"], "."),
  paste0("- Неизвестных region_id: ", reference_preview$unique_keys_count[reference_preview$check_name == "unknown_region_id"], "."),
  "",
  "## Следующий шаг",
  "Повторить подготовку аналитической витрины в R: нормализовать текстовые поля, очистить критичные строки, проверить ключи и собрать таблицу для отчёта."
)

writeLines(r_decision_text, "outputs/r_first_decision.md", useBytes = TRUE)

cat("R-решение выполнено. Файлы сохранены в outputs.\n")
cat("Контроль качества по бизнес-правилам:\n")
print(quality_check)
cat("Контроль качества по справочникам:\n")
print(reference_check)
