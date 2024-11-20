# Логические операции в MongoDB

В MongoDB для выполнения логических операций используются операторы, такие как `$and`, `$or`, `$not`, и `$nor`. Эти операторы позволяют комбинировать условия фильтрации для выполнения сложных запросов. Рассмотрим каждый из них с примерами.
## 1. $and — логическое И

Оператор `$and` позволяет объединить несколько условий, и документ должен удовлетворять всем этим условиям одновременно.

*Пример: Найдем все документы, где age больше 25 и city равен "New York".*
```
db.collection.find({
  $and: [
    { age: { $gt: 25 } },        // возраст больше 25
    { city: "New York" }          // город равен "New York"
  ]
});
```
## 2. $or — логическое ИЛИ

Оператор `$or` позволяет выполнить запрос, если хотя бы одно из условий выполняется.

*Пример: Найдем все документы, где age меньше 18 или city равен "Los Angeles".*

```
db.collection.find({
  $or: [
    { age: { $lt: 18 } },         // возраст меньше 18
    { city: "Los Angeles" }       // город равен "Los Angeles"
  ]
});
```

## 3. $not — логическое НЕ

Оператор `$not` инвертирует условие, то есть возвращает документы, которые не соответствуют указанному условию.

* Пример: Найдем все документы, где age не меньше 30.*

```
db.collection.find({
  age: { $not: { $lt: 30 } }     // возраст не меньше 30
});
```
## 4. $nor — логическое НЕ ИЛИ

Оператор `$nor` комбинирует несколько условий и возвращает документы, которые не соответствуют любому из условий. Это эквивалентно логическому отрицанию оператора $or.

Пример: Найдем все документы, где age не меньше 18 и city не равен "Los Angeles".*

```
db.collection.find({
  $nor: [
    { age: { $lt: 18 } },         // возраст не меньше 18
    { city: "Los Angeles" }       // город не равен "Los Angeles"
  ]
});
```

## 5. $eq — равно

Оператор `$eq` проверяет, равен ли элемент заданному значению.

*Пример: Найдем все документы, где status равен "active".*

```
db.collection.find({
  status: { $eq: "active" }
});
```

## 6. $ne — не равно

Оператор `$ne` проверяет, не равно ли значение заданному.

*Пример: Найдем все документы, где status не равен "inactive".*

```
db.collection.find({
  status: { $ne: "inactive" }
});
```

## 7. $gt — больше

Оператор `$gt` проверяет, больше ли значение заданного поля.

*Пример: Найдем все документы, где age больше 25.*

```
db.collection.find({
  age: { $gt: 25 }
});
```

## 8. $lt — меньше

Оператор `$lt` проверяет, меньше ли значение заданного поля.

*Пример: Найдем все документы, где age меньше 18.*

```
db.collection.find({
  age: { $lt: 18 }
});
```

## 9. $gte — больше или равно

Оператор `$gte` проверяет, больше или равно ли значение заданному.

*Пример: Найдем все документы, где age больше или равно 30.*

```
db.collection.find({
  age: { $gte: 30 }
});
```

## 10. $lte — меньше или равно

Оператор `$lte` проверяет, меньше или равно ли значение заданному.

*Пример: Найдем все документы, где age меньше или равно 65.

```
db.collection.find({
  age: { $lte: 65 }
});
```

## 11. $in — в списке

Оператор `$in` проверяет, находится ли значение в указанном массиве.

*Пример: Найдем все документы, где city является одним из значений в списке "New York", "Los Angeles", "Chicago".*

```
db.collection.find({
  city: { $in: ["New York", "Los Angeles", "Chicago"] }
});
```

## 12. $nin — не в списке

Оператор `$nin` проверяет, не находится ли значение в указанном массиве.

*Пример: Найдем все документы, где city не является одним из значений "New York", "Los Angeles", "Chicago".*

```
db.collection.find({
  city: { $nin: ["New York", "Los Angeles", "Chicago"] }
});
```

## 13. $exists — существование поля

Оператор `$exists` проверяет, существует ли поле в документе.

*Пример: Найдем все документы, где поле age существует.*

```
db.collection.find({
  age: { $exists: true }
});
```

## Пример комбинированного запроса:

Можно комбинировать логические операторы с другими условиями. Например, найти все документы, где age больше 25 и status не равен "inactive", но city может быть любым из списка:

```
db.collection.find({
  $and: [
    { age: { $gt: 25 } },       // возраст больше 25
    { status: { $ne: "inactive" } },  // статус не равен "inactive"
    { city: { $in: ["New York", "Los Angeles"] } }  // город в списке
  ]
});
```

Эти операторы и их комбинации позволяют гибко создавать запросы для выборки данных из MongoDB.