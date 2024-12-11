# Виды индексов в MongoDB

## 1. Первичный индекс (primary index)

Это индекс по полю _id. Создаётся автоматически для каждой коллекции при её создании и является единственным обязательным индексом в MongoDB.

Особенности первичного индекса (_id):

- Уникальность: 
    - Все значения в поле _id должны быть уникальными в пределах коллекции.
- Не требует явного создания: 
    - MongoDB автоматически создает индекс для поля _id при создании коллекции.
- Используется для быстрого поиска: 
    - MongoDB всегда использует этот индекс для поиска документов по _id, и это самый быстрый способ получения документа в коллекции.
- Невозможно удалить: 
    - Индекс по _id нельзя удалить или отключить (если только не использовать альтернативные решения, такие как создание пользовательских индексов).

## 2. Вторичные индексы (Secondary Indexes)

Вторичные индексы в MongoDB — это любые индексы, которые создаются дополнительно к первичному индексу, существующему по умолчанию.

Вторичные индексы создаются вручную для ускорения операций поиска, сортировки, или других запросов по полям, отличным от _id. Имеют смысл для полей, по которым чаще всего осуществляется поиск.

```
db.users.createIndex({ username: 1 });
```

Теперь MongoDB сможет использовать этот индекс для поиска документов с указанным username, вместо выполнения полного сканирования коллекции (COLLSCAN).

Что даёт применение вторичных индексов?

- Ускорение поиска: 
    - Позволяют быстро находить документы по указанным полям.
- Ускорение сортировки: 
    - Если запрос включает сортировку, индекс может помочь MongoDB выполнять её более эффективно.
- Обеспечение уникальности: 
    - Вторичный индекс может быть создан с уникальным ограничением.
- Поддержка сложных запросов: 
    - Например, составные индексы или индексы для массивов.