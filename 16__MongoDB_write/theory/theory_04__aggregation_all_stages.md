# Операции агрегации в MongoDB Compass 

Операции агрегации обрабатывают несколько документов и возвращают вычисленные результаты. Вы можете использовать операции агрегации для:

- Группировки значений из нескольких документов.
- Выполнения операций над сгруппированными данными для получения единого результата.
- Анализа изменений данных со временем.

Для выполнения операций агрегации можно использовать:

- Конвейеры агрегации (Aggregation pipelines) — это предпочтительный метод выполнения агрегаций.
- Методы агрегации для одной цели (Single-purpose aggregation methods) — они просты в использовании, но не обладают такими возможностями, как конвейеры агрегации.




## 01. $addFields - Добавляет или изменяет поля.

*Пример: Добавить поле hours_per_day, разделив hours_per_week на 7.*
```
{
  "$addFields": {
    "hours_per_day": { "$divide": ["$hours_per_week", 7] }
  }
}
```

## 02. $bucket - Разбивает документы на группы (корзины) на основе диапазонов.

*Пример: Разделить документы по возрастным группам (до 20, от 20 до 40, от 40).*
```
{
  "$bucket": {
    "groupBy": "$age",
    "boundaries": [0, 20, 40, 60],
    "default": "other",
    "output": {
      "count": { "$sum": 1 },
      "average_income": { "$avg": "$total" }
    }
  }
}
```

## 03. $bucketAuto

Аналогично $bucket, но автоматически определяет границы.

*Пример: Создать 3 возрастные группы автоматически.*
```
{
  "$bucketAuto": {
    "groupBy": "$age",
    "buckets": 3
  }
}
```

## 04. $collStats

Возвращает статистику о коллекции.

*Пример: Получить статистику о коллекции.*
```
{
  "$collStats": { "latencyStats": { "histograms": true } }
}
```

## 05. $count

Подсчитывает количество документов.

*Пример: Подсчитать количество записей.*
```
{
  "$count": "total_documents"
}
```

## 06. $densify

Создаёт пропущенные значения в последовательности.

*Пример: Заполнить пропущенные значения в диапазоне `age`.*
```
{
  "$densify": {
    "field": "age",
    "range": { "step": 1, "unit": "none" }
  }
}
```

## 07. $facet

Разделяет агрегатный процесс на несколько потоков.

*Пример: Считать средний возраст и максимальный capital_gain (прирост_капитала)*
```
{
  "$facet": {
    "average_age": [{ "$group": { "_id": null, "averageAge": { "$avg": "$age" } } }],
    "max_capital_gain": [{ "$group": { "_id": null, "maxGain": { "$max": "$capital_gain" } } }]
  }
}
```

## 08. $fill

Заполняет пропущенные значения в документе.

*Пример: Заполнить пропущенные значения capital_gain нулями.*
```
{
  "$fill": {
    "output": {
      "capital_gain": { "value": 0 }
    }
  }
}
```

## 09. $geoNear

Выполняет геопространственный поиск документов, которые находятся рядом с указанной точкой. Используется для работы с данными, содержащими географические координаты.

*Пример: Найти ближайшие магазины к заданной точке.*

```
{
  "$geoNear": {
    "near": { "type": "Point", "coordinates": [ -73.9667, 40.78 ] }, // Точка, рядом с которой ищем
    "distanceField": "distance",                                    // Поле для записи расстояния
    "maxDistance": 5000,                                            // Максимальное расстояние (в метрах)
    "query": { "type": "store" },                                   // Дополнительный фильтр
    "spherical": true                                               // Указывает на использование сферической геометрии
  }
}
```

Объяснение параметров:
- `near` - Точка, рядом с которой выполняется поиск. Указывается в формате GeoJSON (type, coordinates).
- `distanceField` - Имя поля, куда будет записано расстояние до найденных документов.
- `maxDistance` - 	Максимальное расстояние (в метрах), в пределах которого будут найдены документы.
- `query` -	Условие фильтрации для отбора документов, например, по типу (type: "store").
- `spherical`	- Определяет, будет ли использоваться сферическая геометрия (для работы с геокоординатами Земли).

Требования к данным:
- Коллекция должна содержать индекс типа 2dsphere для работы с геопространственными данными.

Пример создания индекса:
```
db.collection.createIndex({ location: "2dsphere" });
```

Пример результата:
Если в коллекции есть данные о магазинах:
```
[
  {
    "name": "Store A",
    "location": { "type": "Point", "coordinates": [ -73.965, 40.775 ] },
    "distance": 1200
  },
  {
    "name": "Store B",
    "location": { "type": "Point", "coordinates": [ -73.970, 40.780 ] },
    "distance": 3000
  }
]
```

## 10. $graphLookup
 
Рекурсивно выполняет поиск в коллекции (графовые запросы).

*Пример: Найти все страны, связанные с указанной страной через поле `native_country`.*
```
{
  "$graphLookup": {
    "from": "US_adult_income",
    "startWith": "$native_country",
    "connectFromField": "native_country",
    "connectToField": "native_country",
    "as": "related_countries"
  }
}
```

## 11. $group

Группирует документы и применяет агрегатные функции.

*Пример: Группировать по полю gender и подсчитать средний возраст.*
```
{
  "$group": {
    "_id": "$gender",
    "averageAge": { "$avg": "$age" }
  }
}
```

## 12. $indexStats

Показывает статистику индексов для коллекции.

*Пример: Получить статистику индексов.*
```
{
  "$indexStats": {}
}
```

## 13. $limit

Ограничивает количество документов.

*Пример: Вернуть первые 3 документа.*
```
{
  "$limit": 3
}
```

## 14. $lookup

Выполняет join с другой коллекцией.

*Пример: Присоединить документы из коллекции `US_states` на основе поля `native_country`.*
```
{
  "$lookup": {
    "from": "US_states",
    "localField": "native_country",
    "foreignField": "name",
    "as": "state_info"
  }
}
```

## 15. $match 
Фильтрует документы на основе заданных условий.

*Пример: Найти документы, где возраст больше 35.*
```
{
  "$match": {
    "age": { "$gt": 35 }
  }
}
```

## 16. $merge

Сохраняет результаты агрегации в другую коллекцию, заменяя/обновляя данные.

*Пример: Обновить коллекцию income_summary результатами агрегации.*
```
{
  "$merge": {
    "into": "income_summary",
    "whenMatched": "merge",
    "whenNotMatched": "insert"
  }
}
```

## 17. $out

Сохраняет результаты в новую коллекцию.

*Пример: Сохранить результаты агрегации в коллекцию filtered_income.*
```
{
  "$out": "filtered_income"
}
```

## 18. $project - Выбирает, исключает или изменяет поля документа.

*Пример: Оставить только поля `age`, `workclass` и `_id`.*
```
{
  "$project": {
    "_id": 1,
    "age": 1,
    "workclass": 1
  }
}
```

## 19. $redact

Используется для фильтрации **вложенных** данных. Это значит, что он может применяться к отдельным частям документа, включая массивы или вложенные объекты.
`$redact` обрабатывает каждый уровень документа по отдельности и принимает решение:
- `$$KEEP`: сохранить текущий уровень.
- `$$PRUNE`: удалить текущий уровень (и все вложенные уровни). 
- `$$DESCEND`: сохранить текущий уровень и продолжить обработку вложенных данных.

*Пример: Сохранить только документы, где age больше 35.*
```
{
  "$redact": {
    "$cond": {
      "if": { "$gt": ["$age", 35] },
      "then": "$$KEEP",
      "else": "$$PRUNE"
    }
  }
}
```

## 20. $replaceRoot

Оператор $replaceRoot в MongoDB заменяет текущий документ указанным поддокументом. Это полезно, если нужно сделать один из вложенных объектов "корневым" документом, чтобы работать с ним напрямую.

*Пример: Заменить весь документ на его поддокумент education.*
```
{
  "$replaceRoot": {
    "newRoot": "$education"
  }
}
```

Было:
```
[
  {
    "_id": 1,
    "name": "Alice",
    "education": {
      "degree": "Bachelors",
      "field": "Computer Science",
      "year": 2015
    }
  },
  {
    "_id": 2,
    "name": "Bob",
    "education": {
      "degree": "Masters",
      "field": "Mathematics",
      "year": 2018
    }
  }
]
```

Стало:
```
[
  {
    "degree": "Bachelors",
    "field": "Computer Science",
    "year": 2015
  },
  {
    "degree": "Masters",
    "field": "Mathematics",
    "year": 2018
  }
]
```

## 21. $replaceWith

Аналогично `$replaceRoot`, но более универсально.

*Пример: Заменить документ на результат выражения.*
```
{
  "$replaceWith": { "age_and_income": { "age": "$age", "income": "$total" } }
}
```

## 22. $sample

Выбирает случайное подмножество документов.

*Пример: Выбрать 5 случайных документов.*
```
{
  "$sample": { "size": 5 }
}
```

## 23. $set

Добавляет или изменяет поля (аналог $addFields).

*Пример: Добавить поле `double_age`.*
```
{
  "$set": {
    "double_age": { "$multiply": ["$age", 2] }
  }
}
```

## 24. $setWindowFields

Позволяет выполнять операции оконного анализа над данными. 
Используется для расчёта агрегированных значений, таких как суммы, средние значения, ранги и другие, без необходимости группировки данных. 
Результат сохраняется в рамках каждого документа как новые поля.

Задачи оконного анализа:
- Сумма значений ($sum).
- Ранжирование ($rank).
- Подсчёт ($count).
- Средние значения ($avg).
- Минимум ($min) и максимум ($max).

```
{
  $setWindowFields: {
    partitionBy: <поле или выражение>,       // Опционально: Разделение данных на группы
    sortBy: { <поле>: 1 или -1 },           // Опционально: Сортировка данных в пределах окна
    output: {                               // Обязательное: Указание вычисляемых оконных полей
      <новое_поле>: {
        <агрегатная_функция>: {
          input: <поле или выражение>,      // Поле или значение для анализа
          documents: [<начало>, <конец>]   // Диапазон окна
        }
      }
    }
  }
}
```

## 25. $skip

Пропускает указанное количество документов.

*Пример: Пропустить первые 5 документов.*

```
{
  "$skip": 5
}
```

## 26. $sort

Сортирует документы по указанным полям.

*Пример: Сортировать по возрасту в порядке убывания.*

```
{
  "$sort": { "age": -1 }
}
```

## 27. $sortByCount

Сортирует группы документов по количеству.
- автоматически группирует документы по уникальным значениям указанного поля (в данном случае education).
- подсчитывает количество документов для каждого уникального значения.
- сортирует результаты по полю count в порядке убывания.

*Пример: Подсчитать и отсортировать документы по `education`.*

```
{
  "$sortByCount": "$education"
}
```

## 28. $unionWith

Объединяет результаты агрегации с другой коллекцией.

*Пример: Объединить текущую коллекцию с `US_states`.*
```
{
  "$unionWith": {
    "coll": "US_states"
  }
}
```

## 29. $unset

Удаляет указанные поля.

*Пример: Удалить поле `total`.*
```
{
  "$unset": "total"
}
```

## 30. $unwind

"Разворачивает" массивы, создавая отдельный документ для каждого элемента массива.

*Пример: Поле с массивом, например, `skills`, можно было бы развернуть*
```
{
  "$unwind": "$skills"
}
```
Было:
```
[
  { "_id": 1, "name": "Alice", "skills": ["Python", "JavaScript", "SQL"] },
  { "_id": 2, "name": "Bob", "skills": ["Java", "C++"] },
  { "_id": 3, "name": "Charlie", "skills": [] },
  { "_id": 4, "name": "David", "skills": null }
]
```
Стало:
```
[
  { "_id": 1, "name": "Alice", "skills": "Python" },
  { "_id": 1, "name": "Alice", "skills": "JavaScript" },
  { "_id": 1, "name": "Alice", "skills": "SQL" },
  { "_id": 2, "name": "Bob", "skills": "Java" },
  { "_id": 2, "name": "Bob", "skills": "C++" }
]

```

## Пример полного конвейера

Объединим несколько стадий для примера:

*Цель: Найти всех мужчин старше 30 лет, сгруппировать их по полю `education`, посчитать средний `hours_per_week` и отсортировать по этому значению.*
```
[
  { "$match": { "gender": " Male", "age": { "$gt": 30 } } },
  { "$group": {
      "_id": "$education",
      "average_hours": { "$avg": "$hours_per_week" }
    }
  },
  { "$sort": { "average_hours": -1 } }
]
```