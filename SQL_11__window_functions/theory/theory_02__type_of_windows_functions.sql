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

/*
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
