# Входной аудит данных перед аналитическим отчётом

Учебный комплект для первого 90-минутного практического блока. Задача слушателя — не просто загрузить файлы, а провести входной аудит данных перед аналитическим отчётом по продажам.

## Практическая ситуация

Аналитик получает выгрузку заказов и несколько справочников. Руководитель хочет увидеть выручку по регионам, каналам продаж и категориям товаров. Перед расчётами нужно понять, можно ли доверять данным: нет ли дублей, неверных дат, сломанных бизнес-правил и несвязанных ключей.

## Состав комплекта

```text
data_quality_audit_case_v1/
├── README.md
├── requirements.txt
├── data/
│   └── raw/
│       ├── sales.csv
│       ├── products.xlsx
│       ├── clients.csv
│       └── regions.json
├── docs/
│   ├── control_values.json
│   ├── data_dictionary.md
│   └── expected_checks.md
├── notebooks/
│   ├── README.md
│   ├── 01_data_quality_audit_before_report.ipynb
│   └── 01_data_quality_audit_before_report_solution.ipynb
└── outputs/
```

## Как запускать

1. Распакуйте архив.
2. Откройте терминал или Anaconda Prompt в папке `data_quality_audit_case_v1`.
3. При необходимости установите зависимости:

```bash
pip install -r requirements.txt
```

4. Запустите Jupyter Notebook или JupyterLab.
5. Откройте файл `notebooks/01_data_quality_audit_before_report.ipynb`.
6. Выполните ячейки сверху вниз.
7. Проверьте, что в папке `outputs` появились итоговые файлы.

## Notebooks

| Файл | Назначение |
|---|---|
| `01_data_quality_audit_before_report.ipynb` | версия для слушателей |
| `01_data_quality_audit_before_report_solution.ipynb` | версия преподавателя с полным решением и контрольной сверкой |

## Исходные данные

| Файл | Роль | Ключ | Комментарий |
|---|---|---|---|
| `sales.csv` | факты продаж | `order_id` | основная таблица для аудита |
| `products.xlsx` | справочник товаров | `product_id` | содержит контролируемые дубли ключей и текстовые расхождения |
| `clients.csv` | справочник клиентов | `client_id` | содержит контролируемый дубль ключа |
| `regions.json` | справочник регионов | `region_id` | используется для проверки связности регионов |

## Ожидаемые результаты после запуска notebook

```text
outputs/
├── data_quality_summary.csv
├── data_quality_issues.csv
└── analyst_decision.md
```

## Контрольные значения

- Строк в `sales.csv`: 190
- Полных дублей строк в `sales.csv`: 3
- Строк с повторяющимися `order_id` при проверке `keep=False`: 10
- Нераспознанных дат заказа: 5
- Строк с `quantity <= 0`: 4
- Строк с `unit_price <= 0`: 3
- Строк со скидкой вне диапазона `0..1`: 5
- Строк с пустым `region_id`: 5
- Уникальных `product_id` из продаж без пары в справочнике: 2
- Строк с `product_id` без пары в справочнике: 6
- Уникальных `client_id` из продаж без пары в справочнике: 2
- Строк с `client_id` без пары в справочнике: 3
- Уникальных `region_id` из продаж без пары в справочнике: 2
- Строк с `region_id` без пары в справочнике: 4

Полный список контрольных значений находится в `docs/control_values.json` и `docs/expected_checks.md`.

## Учебный акцент

Данные специально содержат контролируемые проблемы. Они не предназначены для финального отчёта без очистки. Основная цель — научиться принимать решение о пригодности данных для дальнейшего анализа.


## Второй практический комплект

В архив добавлен второй 90-минутный комплект: **нормализация, стандартизация и подготовка аналитической витрины**.

Основные файлы:

```text
notebooks/02_normalization_standardization_datamart.ipynb
notebooks/02_normalization_standardization_datamart_solution.ipynb
docs/normalization_standardization_guide.md
docs/expected_datamart_checks.json
```

Цель комплекта — перейти от входного аудита к рабочей витрине данных: привести ключи, категории, даты и числовые показатели к единой логике, исключить критичные строки и подготовить файлы для итогового отчёта.
## Третий практический комплект

В архив добавлен третий 90-минутный комплект: **установка R, запуск RStudio и первые операции с данными**.

Основные файлы:

```text
r/03_setup_packages.R
r/03_r_check_environment.R
r/03_r_first_steps_student.R
r/03_r_first_steps_solution.R
docs/r_installation_and_first_steps.md
docs/r_teacher_scenario_90min.md
docs/r_student_instruction.md
docs/r_troubleshooting.md
data_quality_audit_case_v1.Rproj
```

Цель комплекта — не изучать R абстрактно, а перенести знакомый кейс входного аудита данных в RStudio: проверить окружение, загрузить CSV/XLSX/JSON, выполнить первые проверки качества и сохранить результаты в `outputs`.

Ожидаемые R-результаты:

```text
outputs/r_environment_check.csv
outputs/r_loaded_data_summary.csv
outputs/r_first_quality_preview.csv
outputs/r_reference_preview.csv
outputs/r_first_decision.md
```


## Комплект 4. Преобразование данных в R

Добавлен практический R-блок, который повторяет подготовку аналитической витрины средствами R.

### Основные файлы

```text
r/
├── 04_r_data_transformation_student.R
└── 04_r_data_transformation_solution.R

docs/
├── r_data_transformation_guide.md
├── r_transformation_student_instruction.md
├── r_transformation_teacher_scenario_90min.md
└── r_transformation_expected_checks.json
```

### Ожидаемые результаты

```text
outputs/
├── r_sales_prepared_with_quality_flags.csv
├── r_sales_datamart.csv
├── r_report_by_region_channel.csv
├── r_transformation_log.csv
├── r_normalization_decision.md
└── r_datamart_control_check.csv
```

R-скрипты нужно запускать в RStudio из файла `data_quality_audit_case_v1.Rproj` или из корневой папки проекта.
## Финальный интеграционный блок

Финальный блок на 60 минут предназначен для сверки Python- и R-результатов и мини-защиты итогового аналитического результата.

Добавленные файлы:

```text
notebooks/05_compare_python_r_results.ipynb
notebooks/05_compare_python_r_results_solution.ipynb
r/05_compare_results_in_r.R
docs/final_integration_teacher_scenario_60min.md
docs/final_integration_student_instruction.md
docs/final_seminar_checklist.md
docs/final_mini_defense_rubric.md
docs/final_post_assignment.md
outputs/final_python_r_comparison.csv
outputs/final_report_differences.csv
outputs/final_integrated_report.md
```

Порядок работы:

1. Запустить Python- и R-блоки или использовать ожидаемые результаты из `outputs`.
2. Открыть `notebooks/05_compare_python_r_results.ipynb`.
3. Сверить Python- и R-результаты.
4. Сформировать итоговый вывод аналитика.
5. Провести мини-защиту по рубрике из `docs/final_mini_defense_rubric.md`.
