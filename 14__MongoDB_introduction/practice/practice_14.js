use sample_data;

// 1. Из коллекции sample_training.companies: найти компании, основанные в период с 2005 года.
db.companies.find({founded_year: {$gte: 2005}});
db.companies.countDocuments({founded_year: {$gte: 2005}}); // 4028


// 2. Выяснить, сколько из них:
// 2.0 Без сотрудников                       54
db.companies.countDocuments({
  $and: [
    { founded_year: { $gte: 2005 } },
    { number_of_employees: { $lt: 0 }
  ]
});

// 2.1. Стартапы (от 1 до 30 сотрудников)        2451
db.companies.countDocuments({
  $and: [
    { founded_year: { $gte: 2005 } },
    { number_of_employees: { $lt: 0, $lte: 30 }}
  ]
});

// 2.2 Средние компании (30-100 сотрудников)    162
db.companies.countDocuments({
  $and: [
    { founded_year: { $gte: 2005 } },
    { number_of_employees: { $gt: 30 , $lte: 50 }}
  ]
});

// 2.3. Крупные компании (100-1000 сотрудников)  // 92
db.companies.countDocuments({
  $and: [
    { founded_year: { $gte: 2005 } },
    { number_of_employees: { $gt: 100 , $lte: 1000 }}
  ]
});

// 2.4. Очень большие компании (свыше 1000 сотрудников)  // 8
db.companies.countDocuments({
  $and: [
    { founded_year: { $gte: 2005 } },
    { number_of_employees: { $gt: 1000 }}
  ]
});

// 3. Составьте список из 5 самых больших поглощений (acquisition) компаний по цене.
db.companies.find(
  { "acquisition.price_amount": { $exists: true }}, { "acquisition.price_amount": 1 }
).sort(
  { "acquisition.price_amount": -1 }
).limit(5);

// { "acquisition.price_amount": { $exists: true }} - нужно, чтобы исключить компании, где это поле отсутствует

/* 4. Для 5 самых больших поглощений (acquisition) найдите:
 - списки подтверждающих материалов (source_url)
 - укажите имя компании
 - и участников сделки
 - и сумму сделки */

db.companies.find({
  "acquisition.price_amount": { $exists: true }
}, {
  _id: 0,
  "Поглотившая компания": "$acquisition.acquired_company.name",
  "Поглощённая компания": "$name",
  "Сумма сделки": "$acquisition.price_amount",
  "Источник": "$acquisition.source_url"
}).sort(
  { "acquisition.price_amount": -1 }
).limit(5);



 
// 5. Составьте список компаний, которые привлекли  инвестиции (total_money_raised).




// 6. Узнайте, сколько их?


// 7. Составьте список компаний, инвестиции которых оценены в долларах на сумму более миллиона.


// 8. Сколько таких компаний?

// 9. Коллекция  sample_data.trips: сколько длилась сама долгая аренда велосипеда?



// 10. Какой велосипед брали наибольшее количество раз?

// 11. Коллекция  sample_data.restaurants: посчитать количество ресторанов по районам (borough).


