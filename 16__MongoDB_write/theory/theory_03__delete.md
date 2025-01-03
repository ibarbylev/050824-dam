# Удаление документов

В MongoDB есть несколько методов для удаления документов из коллекции. Они отличаются по количеству удаляемых документов и способу работы. Вот подробное описание:

## 1. deleteOne

Удаляет первый найденный документ, который соответствует заданному фильтру.

Синтаксис:
```
db.collection.deleteOne(
  { <фильтр> } // Условие для удаления
)
```

Особенности:
  - Удаляет только один документ, даже если фильтру соответствует несколько документов.
  - Если фильтр пустой, удаляет первый документ в коллекции (не рекомендуется использовать без фильтра).

Пример:
```
db.collection.deleteOne({ name: "Alice" });
```
(Удалит первый документ, где name равно "Alice")

## 2. deleteMany

Удаляет все документы, которые соответствуют заданному фильтру.

Синтаксис:
```
db.collection.deleteMany(
  { <фильтр> } // Условие для удаления
)
```

Особенности:
- Удаляет все документы, соответствующие фильтру.
- Если фильтр пустой, удаляет все документы в коллекции (будьте осторожны).

Пример:
```
db.collection.deleteMany({ status: "inactive" });
```
(Удалит все документы, где status равно "inactive")


## 3. findOneAndDelete

Находит и удаляет один документ, возвращая его содержимое.

Синтаксис:

```
db.collection.findOneAndDelete(
  { <фильтр> },          // Условие для удаления
  { sort: { <поле>: 1 } } // (необязательно) Сортировка, чтобы определить, какой документ удалить
)
```

Особенности:
- Удаляет один документ, который первым соответствует фильтру.
- Возвращает удалённый документ.
- Полезен, если нужно получить данные документа перед его удалением.
- Можно указать сортировку, чтобы удалять, например, самый старый или новый документ.

Пример:
```
db.collection.findOneAndDelete(
  { status: "inactive" },
  { sort: { createdAt: -1 } }
);
```
(Удалит последний созданный документ с status равным "inactive" и вернёт его)

Сравнение методов удаления:

| Метод              | Действие                        | Количество удаляемых документов | Возвращает удалённый документ? |
|---------------------|---------------------------------|----------------------------------|--------------------------------|
| `deleteOne`         | Удаляет первый документ         | 1                                | Нет                            |
| `deleteMany`        | Удаляет все соответствующие     | Все                             | Нет                            |
| `findOneAndDelete`  | Удаляет один документ           | 1                                | Да                             |

Примеры работы:
Удалить документ по ID
```
db.collection.deleteOne({ _id: ObjectId("64d1b770f0e1ad3b7c0e2a6a") });
```

Удалить все документы с определённым значением поля
```
db.collection.deleteMany({ category: "archived" });
```

Удалить документ и вернуть его содержимое
```
const deletedDoc = db.collection.findOneAndDelete({ status: "inactive" });
console.log("Удалённый документ:", deletedDoc);
```

Важные замечания
- Пустой фильтр: Использование пустого фильтра ({}) может удалить все документы в коллекции, что необратимо. Применяйте это с осторожностью.
- Ограничение памяти: Методы удаления не возвращают данные всех удалённых документов. Если нужно работать с данными перед удалением, используйте `find` для выборки, а затем `deleteOne` или `deleteMany`.
- Скорость работы:
  - `deleteMany` быстрее, если нужно удалить много документов.
  - `findOneAndDelete` полезен для атомарных операций.