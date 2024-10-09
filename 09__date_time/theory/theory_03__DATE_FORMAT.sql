/*
DATE_FORMAT - функция, обратная функции STR_TO_DATE

STR_TO_DATE - преобразует формат строки в формат даты/времени
STR_TO_DATE - наоборот, преобразует дату/время в строку
*/


SELECT DATE_FORMAT(NOW(), '%d %m %Y %H:%i:%s');	 -- '08 10 2024 17:13:06'


SELECT DATE_FORMAT(NOW(), '%d %M %Y %H:%i:%s');  -- 08 October 2024 17:12:42

-- Можно также изменить настойки, чтобы учитывался локальный язык
SET lc_time_names = 'ru_RU';

SELECT DATE_FORMAT(NOW(), '%d %M %Y %H:%i:%s');  -- 08 Октября 2024 17:12:42

-- И опять всё вернуть обратно
SET lc_time_names = 'en_US';

SELECT DATE_FORMAT(NOW(), '%d %M %Y %H:%i:%s');  -- 08 October 2024 17:12:42

-- Если необходимо вывести название месяца
SELECT MONTHNAME(NOW());  -- October
