# Диагностика типовых ошибок

Используйте этот документ, если notebook не запускается, не находит данные или выдаёт результат, отличный от контрольного.

## Быстрая последовательность проверки

Перед поиском сложной причины выполните пять шагов:

1. Убедитесь, что открыли **весь каталог пары**, а не только `.ipynb`.
2. Проверьте выбранный Python kernel.
3. Перезапустите kernel/runtime.
4. Выполните все ячейки сверху вниз.
5. Проверьте наличие `data/raw/MoviesOnStreamingPlatforms.csv` или контрольного файла соответствующей пары.

---

# 1. `FileNotFoundError` или сообщение «файл не найден»

## Возможная причина

Notebook был перемещён отдельно от папки `data`, открыт из другой рабочей директории либо в Colab загружен только `.ipynb`.

## Диагностика

Выполните:

```python
from pathlib import Path

print('Текущая папка:', Path.cwd())
print('Содержимое текущей папки:')
for path in Path.cwd().iterdir():
    print('-', path.name)
```

Проверьте, существует ли ожидаемый путь:

```python
from pathlib import Path

path = Path('data/raw/MoviesOnStreamingPlatforms.csv')
print(path.resolve())
print('Существует:', path.exists())
```

## Исправление в VS Code

1. Закройте отдельный файл notebook.
2. Выберите **File → Open Folder**.
3. Откройте каталог конкретной пары.
4. Повторно откройте `notebooks/student_practice.ipynb`.
5. Перезапустите kernel и выполните всё сверху вниз.

## Исправление в Colab

Загрузите и распакуйте весь каталог пары. Минимально необходимая структура:

```text
practice/
├── data/raw/MoviesOnStreamingPlatforms.csv
├── notebooks/student_practice.ipynb
└── outputs/
```

Во второй паре вместо основного CSV обязательно должны присутствовать контрольный длинный файл и справочники.

---

# 2. `ModuleNotFoundError`

Примеры:

```text
ModuleNotFoundError: No module named 'pandas'
ModuleNotFoundError: No module named 'sklearn'
```

## Причина

Библиотека не установлена в том Python-окружении, которое выбрано как kernel.

## Исправление

В терминале каталога пары:

```bash
python -m pip install -r requirements.txt
```

Для проверки:

```bash
python -c "import pandas, numpy, sklearn, matplotlib, joblib; print('OK')"
```

В notebook можно проверить используемый интерпретатор:

```python
import sys
print(sys.executable)
```

Путь должен соответствовать выбранному окружению `.venv` либо ожидаемому Colab runtime.

---

# 3. В VS Code не выбран kernel или ячейки не запускаются

## Симптомы

- кнопка запуска неактивна;
- VS Code просит выбрать kernel;
- установленная библиотека «не видна» notebook;
- терминал и notebook используют разные версии Python.

## Исправление

1. Нажмите **Select Kernel** в правом верхнем углу notebook.
2. Выберите Python Environment.
3. Выберите интерпретатор из `.venv`.
4. Выполните первую ячейку и сравните `sys.executable` с ожидаемым путём.

Официальная инструкция VS Code: <https://code.visualstudio.com/docs/datascience/jupyter-kernel-management>.

---

# 4. `NameError` или переменная не определена

Пример:

```text
NameError: name 'movies' is not defined
```

## Причина

Ячейки выполнены не по порядку, kernel был перезапущен либо ячейка создания переменной завершилась ошибкой.

## Исправление

1. Выберите **Restart Kernel**.
2. Выполните **Run All**.
3. Не запускайте ячейку с графиком или сохранением до ячейки подготовки данных.

Notebook хранит код, но переменные существуют только в памяти текущего kernel.

---

# 5. `KeyError` для имени столбца

Примеры:

```text
KeyError: 'rating_score'
KeyError: 'Prime_Video'
```

## Причины

- используется исходная таблица до переименования;
- пропущена ячейка `prepare_movies()`;
- столбец переименован вручную;
- загружен другой CSV с отличающейся схемой.

## Диагностика

```python
print(movies_raw.columns.tolist())
print(movies.columns.tolist())
```

## Исправление

Верните исходный CSV и выполните notebook с первой ячейки без ручного изменения названий.

---

# 6. Ошибка при `stack()` и параметре `future_stack`

Пример:

```text
TypeError: stack() got an unexpected keyword argument 'future_stack'
```

## Причина

Параметр `future_stack` отсутствует в старых версиях pandas. Он появился в pandas 2.1, а поведение менялось между версиями.

## Исправление

В текущем комплекте должен использоваться совместимый вызов:

```python
stacked = movies_by_decade.stack().rename('movie_count').reset_index()
```

Не добавляйте `future_stack` вручную. Если ошибка осталась, скачайте актуальную версию notebook из репозитория и перезапустите kernel.

Документация:

- pandas 2.0: <https://pandas.pydata.org/pandas-docs/version/2.0/reference/api/pandas.DataFrame.stack.html>;
- pandas 2.1: <https://pandas.pydata.org/pandas-docs/version/2.1/reference/api/pandas.DataFrame.stack.html>.

---

# 7. Ошибка `OneHotEncoder`: `sparse` или `sparse_output`

Примеры:

```text
TypeError: OneHotEncoder.__init__() got an unexpected keyword argument 'sparse_output'
TypeError: OneHotEncoder.__init__() got an unexpected keyword argument 'sparse'
```

## Причина

API `OneHotEncoder` отличается между версиями scikit-learn.

## Исправление

В актуальном notebook используется функция, проверяющая сигнатуру:

```python
import inspect
from sklearn.preprocessing import OneHotEncoder


def make_one_hot_encoder():
    parameters = inspect.signature(OneHotEncoder).parameters
    common = {'handle_unknown': 'ignore'}
    if 'sparse_output' in parameters:
        return OneHotEncoder(sparse_output=False, **common)
    return OneHotEncoder(sparse=False, **common)
```

Если в вашем файле её нет, обновите notebook. Не заменяйте её одним параметром без проверки версии.

Официальная документация: <https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.OneHotEncoder.html>.

---

# 8. `ValueError: Found unknown categories during transform`

## Причина

Encoder обучен на исторических категориях, а в новых данных появилась другая категория. По умолчанию некоторые конфигурации encoder завершаются ошибкой.

## Исправление

Убедитесь, что используется:

```python
OneHotEncoder(handle_unknown='ignore')
```

В текущем комплекте этот параметр уже установлен. После изменения pipeline необходимо заново выполнить `fit` на исторической части, а затем `transform` новой части.

---

# 9. Ошибка `merge` или неожиданно выросло число строк

## Симптомы

- `MergeError` при `validate='many_to_one'`;
- после объединения строк стало больше;
- появились пропуски в полях справочника;
- `_merge` содержит `left_only`.

## Возможные причины

1. В справочнике есть дубликаты ключа.
2. Значения ключей отличаются пробелами или регистром.
3. Используется неверный столбец соединения.
4. Справочник изменён вручную.

## Диагностика

```python
print(platform_ref['platform'].duplicated().sum())
print(platform_ref['platform'].tolist())
print(movies_long['platform'].drop_duplicates().tolist())
```

После соединения:

```python
print(movies_enriched['_merge'].value_counts(dropna=False))
```

## Исправление

- восстановите исходные справочники;
- проверьте уникальность ключа;
- не убирайте `validate='many_to_one'` ради прохождения ошибки;
- не продолжайте расчёты, пока кардинальность не объяснена.

---

# 10. Контрольный `assert` завершился ошибкой

## Пример

```text
AssertionError
```

## Значение

`assert` не является «лишней ошибкой». Он сообщает, что нарушено ожидаемое свойство данных.

Частые причины:

- удалены строки;
- изменены платформенные флаги;
- повторно выполнена часть ячеек с изменением DataFrame;
- загружен другой файл;
- пропущена фильтрация `available == 1`;
- после `merge` появились дубликаты.

## Исправление

1. Посмотрите проверяемое условие непосредственно перед `assert`.
2. Выведите обе стороны сравнения.
3. Перезапустите notebook сверху вниз на исходных данных.
4. Не удаляйте `assert`, пока не установлена причина.

---

# 11. Результаты отличаются от контрольных размеров

Контрольные значения:

| Результат | Ожидаемое число строк |
|---|---:|
| исходный CSV | 9515 |
| `movies_clean.csv` | 9515 |
| `movies_long.csv` | 9777 |
| `movies_datamart.csv` | 167 |
| `scaled_movie_features.csv` | 9515 |
| историческая preprocessing-матрица | 8326 |
| новая preprocessing-матрица | 1189 |

## Проверьте

- совпадает ли исходный файл;
- не удалялись ли пропуски вручную;
- не изменялась ли граница разделения по году;
- выполнены ли все фильтры;
- не запускались ли ячейки в изменённом порядке.

---

# 12. График не отображается или сохраняется пустым

## Исправление

Убедитесь, что:

```python
import matplotlib.pyplot as plt
```

и после построения вызываются:

```python
plt.tight_layout()
plt.savefig(output_path, dpi=140)
plt.show()
```

Проверьте, что DataFrame после фильтрации не пуст:

```python
print(plot_data.shape)
display(plot_data.head())
```

В headless-среде PNG может сохраниться, даже если интерактивное окно не показано. Проверьте папку `outputs`.

---

# 13. Не удаётся сохранить CSV, PNG или `.joblib`

## Возможные причины

- файл открыт и заблокирован Excel;
- нет прав на запись;
- папка удалена;
- выбран путь только для чтения;
- в Colab используется путь вне `/content` без подключённого Drive.

## Исправление

1. Закройте выходной CSV в Excel.
2. Убедитесь, что папка создаётся:

```python
from pathlib import Path
Path('outputs').mkdir(parents=True, exist_ok=True)
```

3. Проверьте доступность записи:

```python
from pathlib import Path

test_path = Path('outputs/write_test.txt')
test_path.write_text('OK', encoding='utf-8')
print(test_path.resolve())
```

---

# 14. После повторного запуска появились странные результаты

## Причина

Некоторые переменные могли быть изменены в памяти предыдущими ячейками.

## Исправление

Используйте чистый запуск:

1. Restart Kernel/Runtime.
2. Clear All Outputs — по необходимости.
3. Run All.

Не полагайтесь на переменные, созданные при прошлой сессии.

---

# 15. Colab потерял файлы после перезапуска

## Причина

Файлы в `/content` хранятся во временной среде выполнения.

## Исправление

- повторно загрузите ZIP;
- распакуйте его;
- выполните notebook заново;
- перед завершением скачайте результаты или скопируйте их на Google Drive.

Официальные примеры работы с внешними данными: <https://colab.research.google.com/notebooks/io.ipynb>.

---

# 16. Pipeline даёт разные шкалы для истории и новых данных

## Причина

На новой части ошибочно выполнен повторный `fit` или `fit_transform`.

## Правильно

```python
history_matrix = pipeline.fit_transform(X_history)
new_matrix = pipeline.transform(X_new)
```

## Неправильно

```python
history_matrix = pipeline.fit_transform(X_history)
new_matrix = pipeline.fit_transform(X_new)
```

Во втором варианте новые медианы, средние, стандартные отклонения и категории рассчитываются заново, поэтому матрицы перестают быть сопоставимыми. Рекомендации по предотвращению утечки данных приведены в документации scikit-learn: <https://scikit-learn.org/stable/common_pitfalls.html>.

---

# 17. Сохранённый pipeline не загружается

## Симптом

Ошибка при:

```python
import joblib
pipeline = joblib.load('outputs/preprocessing_pipeline.joblib')
```

## Возможные причины

- файл повреждён;
- используется существенно другая версия scikit-learn;
- изменился путь;
- файл был создан в другой среде и несовместим с текущей.

## Исправление

1. Проверьте путь и размер файла.
2. Используйте то же окружение и зависимости, в которых pipeline создавался.
3. При сомнении заново выполните четвёртый notebook и пересохраните объект.
4. Не загружайте неизвестные `.joblib`/pickle-файлы из недоверенного источника.

---

# 18. Когда обращаться к преподавателю

Сообщите:

1. название пары и notebook;
2. номер или заголовок ячейки;
3. полный текст ошибки;
4. вывод `Path.cwd()`;
5. вывод `sys.version` и версий pandas/scikit-learn;
6. какие действия были выполнены перед ошибкой.

Не присылайте только скриншот последней строки. Полный traceback обычно содержит имя функции, строку кода и первичную причину.
