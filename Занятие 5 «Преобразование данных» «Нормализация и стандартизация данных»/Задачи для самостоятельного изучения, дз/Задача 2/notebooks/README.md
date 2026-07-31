# Notebooks

- `01_data_quality_audit_before_report.ipynb` — версия для слушателей.

Рекомендуемый запуск: открыть Jupyter или JupyterLab из корня проекта и выполнить notebook сверху вниз.
Если notebook открыт из папки `notebooks`, встроенная функция поиска корня проекта также должна найти папку `data/raw`.


## Комплект 2. Нормализация, стандартизация и аналитическая витрина

- `02_normalization_standardization_datamart.ipynb` — версия для слушателей.

Результаты сохраняются в папку `outputs/`:

- `sales_prepared_with_quality_flags.csv`;
- `sales_datamart.csv`;
- `report_by_region_channel.csv`;
- `transformation_log.csv`;
- `normalization_decision.md`.
## R-блок

Для третьего 90-минутного комплекта используются R-скрипты из папки `r/`:

| Файл | Назначение |
|---|---|
| `r/03_setup_packages.R` | установка и проверка пакетов |
| `r/03_r_check_environment.R` | проверка рабочей папки и исходных файлов |
| `r/03_r_first_steps_student.R` | первая практика слушателя в R |
| `r/03_r_first_steps_solution.R` | эталонное решение преподавателя |

R-блок открывается через файл проекта `data_quality_audit_case_v1.Rproj`.


## Комплект 4. Преобразование данных в R

R-скрипты находятся в папке `r/`:

- `04_r_data_transformation_student.R` — версия для слушателей;

Документы находятся в папке `docs/`:

- `r_data_transformation_guide.md`;
- `r_transformation_student_instruction.md`;
- `r_transformation_teacher_scenario_90min.md`;
- `r_transformation_expected_checks.json`.
## Финальная сверка

- `05_compare_python_r_results.ipynb` — версия для слушателя.

Эти notebooks сравнивают Python- и R-результаты, сохраняют таблицу сверки и помогают подготовить итоговый аналитический вывод.
