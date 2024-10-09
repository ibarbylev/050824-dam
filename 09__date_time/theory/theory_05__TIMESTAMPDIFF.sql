/*
Функция TIMESTAMPDIFF в MySQL используется для вычисления разницы между
двумя временными метками (датами или временем) в выбранной единице измерения,
такой как секунды, минуты, часы, дни и т.д.

В отличие от функции DATEDIFF, которая возвращает разницу только в днях,
TIMESTAMPDIFF более гибкая и позволяет указывать единицы измерения.


TIMESTAMPDIFF(unit, datetime1, datetime2)

где:
    - unit: Единица измерения, в которой будет вычислена разница
            (например, секунды, минуты, часы и т.д.).
    - datetime1: Первая дата/время (эта дата считается более поздней).
    - datetime2: Вторая дата/время (эта дата считается более ранней).

Единицы измерения:

    SECOND: секунды.
    MINUTE: минуты.
    HOUR: часы.
    DAY: дни.
    WEEK: недели.
    MONTH: месяцы.
    QUARTER: кварталы.
    YEAR: годы.
 */


SELECT TIMESTAMPDIFF(MINUTE, '2023-10-01 12:00:00', '2024-10-01 12:00:00');  -- 527085

SELECT TIMESTAMPDIFF(MINUTE, '2024-10-01 12:00:00', '2023-10-01 12:00:00');  -- -527085


SELECT TIMESTAMPDIFF(DAY, '2023-10-01 12:00:00', '2024-10-01 12:00:00');  -- 366

SELECT TIMESTAMPDIFF(DAY, '2024-10-01 12:00:00', '2023-10-01 12:00:00');  -- -366