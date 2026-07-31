# Ожидаемые проверки для преподавателя

Этот файл нужен для быстрой сверки результатов после запуска notebook.

| Проверка | Ожидаемое значение |
|---|---:|
| Строк в sales.csv | 190 |
| Полных дублей строк в sales.csv | 3 |
| Строк с повторяющимися order_id, keep=False | 10 |
| Нераспознанных дат order_date | 5 |
| quantity <= 0 | 4 |
| unit_price <= 0 | 3 |
| discount < 0 или discount > 1 | 5 |
| пустой region_id | 5 |
| уникальных неизвестных product_id | 2 |
| строк с неизвестным product_id | 6 |
| уникальных неизвестных client_id | 2 |
| строк с неизвестным client_id | 3 |
| уникальных неизвестных region_id | 2 |
| строк с неизвестным region_id | 4 |
| строк с дублями product_id в products.xlsx, keep=False | 4 |
| строк с дублями client_id в clients.csv, keep=False | 2 |
