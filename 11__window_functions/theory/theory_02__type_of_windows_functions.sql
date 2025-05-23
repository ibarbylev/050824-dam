/* Оконные функции в SQL можно разделить на несколько категорий
в зависимости от того, какие задачи они решают.
Вот основные виды оконных функций:

1. АГРЕГАТНЫЕ оконные функции

    Эти функции выполняют агрегатные операции (суммирование, подсчёт среднего и т.д.)
    по окну строк, которое вы задаёте с помощью OVER(). В отличие от обычных
    агрегатных функций, здесь результат сохраняется для каждой строки.

Примеры:

    SUM() — сумма значений
    AVG() — среднее значение
    MIN() — минимальное значение
    MAX() — максимальное значение
    COUNT() — количество строк

Пример: */

SELECT first_name, last_name, department_id, salary,
       SUM(salary) OVER (PARTITION BY department_id) AS department_salary_sum
FROM hr.employees;

/*
2. РАНЖИРУЮЩИЕ (ranking) функции

    Ранжирующие функции присваивают каждой строке номер или ранг
    в зависимости от её положения в окне.

Примеры:

    ROW_NUMBER() — порядковый номер строки в окне.
    RANK() — присваивает ранг строкам в окне, при этом одинаковые значения
           получают одинаковый ранг, а следующий ранг пропускается
           (например, 1, 2, 2, 4).
    DENSE_RANK() — аналогично RANK(), но без пропусков (например, 1, 2, 2, 3).
    NTILE(n) — делит строки окна на n равных частей и присваивает номер "корзины"
            каждой строке (например, если n = 4, строки будут распределены
            по четырём частям).

Пример: */

-- ранжирование зарплат по всей таблице
SELECT first_name, last_name, salary,
       RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM hr.employees;

-- тоже самое с разбивкой по каждому департаменту в отдельности
SELECT first_name, last_name, department_id, salary,
       DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
FROM hr.employees;

-- весь диапазон окна разбит на 4 (приблизительно) равные части
SELECT first_name, last_name, department_id, salary,
       NTILE(4) OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_quartile
FROM hr.employees;


/*
3. Функции СМЕЩЕНИЯ (аналоги лагов и лидов)

    Эти функции позволяют получать значения строк, которые находятся
    на определённой позиции относительно текущей строки.

Примеры:

    LAG() — возвращает значение предыдущей строки в окне.
    LEAD() — возвращает значение следующей строки в окне.
    FIRST_VALUE() — возвращает первое значение в окне.
    LAST_VALUE() — возвращает последнее значение в окне.

Пример:*/

SELECT first_name, last_name, salary,
       LAG(salary, 1) OVER (ORDER BY salary) AS previous_salary
FROM hr.employees;

/*
4. ФРЕЙМЫ (frames)

    Фреймы позволяют задавать конкретные диапазоны строк в пределах окна,
    для которых будет выполняться вычисление. Эти функции более тонко
    настраиваются с помощью ключевых слов, таких как ROWS и RANGE,
    и позволяют ограничить количество строк, учитываемых для расчёта.

    ROWS BETWEEN — указывает диапазон строк относительно текущей строки.
    RANGE BETWEEN — похож на ROWS, но работает с диапазоном значений,
                    а не с конкретными строками.

    Для указания диапазона строк окна возможны следующие варианты:
    UNBOUNDED PRECEDING	    - Все строки от начала набора данных
    N PRECEDING	            - N строк до текущей строки (или значение)
    CURRENT ROW	            - Текущая строка (значение текущей строки)
    N FOLLOWING	            - N строк после текущей строки (или значение)
    UNBOUNDED FOLLOWING	    - Все строки от текущей строки до конца набора данных


Пример:*/

-- В этом запросе вычисляется сумма зарплаты между одно предыдущей строкой и одной следующей
SELECT first_name, last_name, salary,
       SUM(salary) OVER (ORDER BY salary ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS moving_sum
FROM hr.employees;

/* А здесь считается кумулятивная (накопительная) сумма возрастающим итогом по каждой строке
   в таблице, предварительно отсортированной по зарплате */

SELECT first_name, last_name, salary,
       SUM(salary) OVER (ORDER BY salary ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_sum
FROM hr.employees;

    Следует обращать внимание, что ROWS учитывает строки относительно текущей,
    а RANGE - значения строк относительно значения текущей.

Например:

SELECT
	salary,
	SUM(salary) OVER(ORDER BY salary RANGE BETWEEN CURRENT ROW AND 3000 FOLLOWING)
FROM (
	SELECT * FROM hr.employees LIMIT 5) AS t;

/* RANGE означает:
   суммировать строки, где ЗП в диапазоне от текущей до текущая + 3000
  salary    SUM(salary)     ДИАПАЗОН salary RANGE BETWEEN CURRENT ROW AND 3000 FOLLOWING означает
'6000.00',  '15000.00'      от 6 000 до 9 000
'9000.00',  '9000.00'       от 9 000 до 12 000
'17000.00', '34000.00'      от 17 000 до 20 000
'17000.00', '34000.00'      от 17 000 до 20 000
'24000.00', '24000.00'      от 24 000 до 24 000
 */


SELECT
	salary,
	SUM(salary) OVER(ORDER BY salary ROWS BETWEEN CURRENT ROW AND 3000 FOLLOWING)
FROM (
	SELECT * FROM hr.employees LIMIT 5) AS t;

/*
  salary     SUM(salary)    ДИАПАЗОН salary ROWS BETWEEN CURRENT ROW AND 3000 FOLLOWING означает:
'6000.00',  '73000.00'      от текущей строки до 3000 последующих строк
'9000.00',  '67000.00'      от текущей строки до 3000 последующих строк
'17000.00', '58000.00'      от текущей строки до 3000 последующих строк
'17000.00', '41000.00'      от текущей строки до 3000 последующих строк
'24000.00', '24000.00'      от текущей строки до 3000 последующих строк */

/*
RANGE очень удобно использовать для дат, когда требуется получить "скользящий" итог.
В следующем примере мы получаем итог продаж за каждые 2 месяца: текущий и предшествующий: */

SELECT DISTINCT
    MONTH(ODATE) AS month_,
    SUM(AMT) OVER(PARTITION BY MONTH(ODATE)) AS month_sales,
    SUM(AMT) OVER (
        ORDER BY ODATE
        RANGE BETWEEN INTERVAL 1 MONTH PRECEDING AND CURRENT ROW
    ) AS rolling_2_month_sales
FROM
    shop.ORDERS
ORDER BY
    ODATE;
/*

month,  month_sales,    rolling_2_month_sales
3       12944.59,       12944.59
4        1788.98,       14733.57
5        4723.00,        6511.98
6       11201.83,       15924.83


5. СУММАРНЫЕ и КУМУЛЯТИВНЫЕ функции

    Эти функции вычисляют агрегатные значения для строки и всех предыдущих строк в рамках окна.

Примеры:

    CUME_DIST() — вычисляет кумулятивное распределение строки в пределах окна.
    PERCENT_RANK() — вычисляет процентный ранг строки в окне.

Пример:*/

SELECT first_name, last_name, salary,
       CUME_DIST() OVER (ORDER BY salary) AS salary_distribution
FROM hr.employees;


SELECT first_name, last_name, salary,
       NTH_VALUE(salary, 3) OVER (ORDER BY salary) AS salary_distribution
FROM hr.employees;

/*
Заключение:

    Агрегатные оконные функции — для вычисления суммы, среднего, количества
        и других агрегатов.
    Ранжирующие функции — для присвоения строкам номеров или рангов.
    Функции смещения — для доступа к соседним строкам.
    Функции фреймов — для более гибкой работы с диапазонами строк.
    Кумулятивные функции — для вычисления накопительных и процентных значений.

Эти оконные функции позволяют решать широкий круг задач,
связанных с аналитикой данных, без необходимости группировать строки
и тем самым терять исходные данные. */
