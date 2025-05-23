/* Давайте немного усложним оба запроса:
1. Вывести сотрудников, чья ЗП больше, чем средняя ЗП по фирме */

SET @avg_salary_compamy = (SELECT AVG(salary) FROM hr.employees);

SELECT 
    first_name, last_name, salary, @avg_salary_compamy
FROM
    hr.employees
WHERE
    salary > @avg_salary_compamy;   
    
/*
2. Вывести департаменты, где средняя ЗП по департаменту больше, чем средняя ЗП по фирме */

SELECT 
    department_id, AVG(salary) AS avg_salary_depart
FROM
    hr.employees
GROUP BY department_id
HAVING avg_salary_depart > @avg_salary_compamy; 

