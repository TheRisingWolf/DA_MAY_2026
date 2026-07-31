# Самостоятельная работа: подготовка витрины активности пользователей

Комплект предназначен для закрепления навыков преобразования данных, изменения формы таблиц, объединения источников, создания признаков, нормализации, стандартизации и воспроизводимого применения preprocessing к новой выгрузке.

## Состав комплекта

```text
user_activity_homework_transform_scaling/
├── assignment_brief.md
├── data_dictionary.md
├── grading_rubric.md
├── self_checklist.md
├── requirements.txt
├── data/
│   ├── raw/
│   │   ├── users.csv
│   │   ├── monthly_activity_wide.csv
│   │   ├── tariffs.csv
│   │   └── new_users.csv
│   └── processed/
├── notebooks/
│   ├── user_activity_homework_student.ipynb
│   └── user_activity_homework_teacher.ipynb
├── outputs/
└── teacher_materials/
    ├── teacher_guide.md
    ├── expected_results.md
    └── qa_report.md
```

## Быстрый старт в VS Code или Jupyter

1. Распакуйте архив полностью, не перемещая отдельные файлы из папок.
2. Откройте корневую папку проекта в VS Code.
3. Создайте виртуальное окружение и установите зависимости:

```bash
python -m venv .venv
```

Windows:

```bash
.venv\Scripts\activate
pip install -r requirements.txt
```

macOS / Linux:

```bash
source .venv/bin/activate
pip install -r requirements.txt
```

4. Откройте `notebooks/user_activity_homework_student.ipynb`.
5. Выберите Python kernel из созданного окружения.
6. Выполняйте notebook сверху вниз.

## Быстрый старт в Google Colab

1. Загрузите ZIP-архив в Colab.
2. Распакуйте его в `/content`:

```python
!unzip -q user_activity_homework_student.zip -d /content/homework
%cd /content/homework
```

3. Откройте или загрузите `notebooks/user_activity_homework_student.ipynb`.
4. Выполняйте ячейки сверху вниз. В notebook есть автоматический поиск корня проекта.

## Формат сдачи

Передайте заполненный notebook, итоговые CSV-файлы, графики и краткий аналитический вывод. Подробные требования находятся в `assignment_brief.md`.
