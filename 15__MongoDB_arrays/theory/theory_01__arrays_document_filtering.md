# Операторы для фильтрации документов в массиве

## 1. $all — поиск документов по указанному набору элементов

Оператор `$all` в MongoDB применяется только к массивам. Он используется для проверки, содержит ли массив все указанные значения, независимо от порядка элементов в массиве.

Пример:

В коллекции products, значения поля tags является массивом.
```
db.products.insertMany([
    { name: "Laptop", tags: ["electronics", "computer", "portable"] },
    { name: "Smartphone", tags: ["electronics", "mobile", "portable"] },
    { name: "Desk", tags: ["furniture", "wood", "office"] },
    { name: "Chair", tags: ["furniture", "wood"] }
]);
```
Необходимо найти продукты, у которых в массиве tags одновременно присутствуют "electronics" и "portable".
```
db.products.find({
    tags: { $all: ["electronics", "portable"] }
});
```

Ожидаемый результат:
```
[{
  _id: ObjectId('6746172fc9bca7bc6f2363bc'),
  name: 'Laptop',
  tags: [ 'electronics', 'computer', 'portable' ]
},
{
  _id: ObjectId('6746172fc9bca7bc6f2363bd'),
  name: 'Smartphone',
  tags: [ 'electronics', 'mobile', 'portable' ]
}]
```

## 2. $size — поиск по указанному числу элементов в массиве

Оператор `$size` проверяет количество элементов в массиве.

*Пример: выбрать документы, где массив в tag содержит элемента*
```
db.collection.find({ 
    tags: { $size: 3 } 
});
```

Ожидаемый результат:
```
[{
  _id: ObjectId("67461aa23f054cc437def0fd"),
  name: "Laptop",
  tags: [ "electronics", "computer", "portable" ]
},
{
  _id: ObjectId("67461aa23f054cc437def0fe"),
  name: "Smartphone",
  tags: [ "electronics", "mobile", "portable" ]
},
{
  _id: ObjectId(:67461aa23f054cc437def0ff"),
  name: "Desk",
  tags: [ "furniture", "wood", "office" ]
}]
```
## 3. $in - проверка наличия указанного элемента в массиве

Оператор `$in` проверяет, содержит ли массив хотя бы одно из указанных значений.

*Пример:  Найти товары, у которых в массиве tags есть хотя бы один из тегов "portable" или "mobile"*

```
db.collection.find({ 
    tags: { $in: ["portable", "mobile"] } 
});
```

Ожидаемый результат:
```
[{
  _id: ObjectId("67461aa23f054cc437def0fd"),
  name: "Laptop",
  tags: [ "electronics", "computer", "portable" ]
},
{
  _id: ObjectId("67461aa23f054cc437def0fe"),
  name: "Smartphone",
  tags: [ "electronics", "mobile", "portable" ]
},
```

## 4. $nin - проверка отсутствия указанного элемента в массиве

Оператор `$nin` проверяет, не содержит ли массив ни одно из указанных значений.

*Пример:  Найти товары, у которых в массиве tags не ни тега "portable" ни тега "wood"*

```
db.collection.find({ 
    tags: { $nin: ["portable", "wood"] } 
});
```

Ожидаемый результат: (пустое значение)