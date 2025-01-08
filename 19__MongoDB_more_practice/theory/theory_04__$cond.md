# Условный оператор $cond

Аналог оператора if else в Python.

Удобен для замены значений в случае выполнения условий.

*Пример:*
*Создаём диапазоны с помощью `$bucket`, которые переименовываем в `$project`*

```
db.collection.aggregate([
  {
    $bucket: {
      groupBy: "$price",
      boundaries: [0, 20000, 30000, Infinity],
      default: "Other",
      output: {
        count: { $sum: 1 }
      }
    }
  },
  {
    $project: {
      _id: {
        $cond: [
          { $lt: ["$_id", 20000] }, "до 20000",
          { $and: [{ $gte: ["$_id", 20000] }, { $lt: ["$_id", 30000] }] }, "от 20000 до 30000",
          { $gte: ["$_id", 30000] }, "свыше 30000"
        ]
      },
      count: 1
    }
  }
])

```

