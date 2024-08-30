SELECT 
    department_id, AVG(salary) AS avg_salary
FROM
    hr.employees
WHERE
    department_id IN (60 , 90, 100);
