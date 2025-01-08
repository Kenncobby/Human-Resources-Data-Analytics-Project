Use thre;
                                       -- QUESTIONS
-- 1. Gender Distribution by Department: Count the number of male and female employees in each department to understand gender representation.
SELECT 
    dp.department_name, emp.gender, COUNT(gender) AS gender_count
FROM
    employees emp
        LEFT JOIN
    employee_job_history AS jh ON emp.employee_id = jh.employee_id
        LEFT JOIN
    job_titles AS jt ON jh.job_title_id = jt.job_title_id
        LEFT JOIN
    departments AS dp ON jt.department_id = dp.department_id
GROUP BY dp.department_name , gender
ORDER BY  dp.department_name, gender_count;

-- 2. Employee Tenure: Calculate the average tenure of employees (difference between hire_date and termdate for terminated employees or the current date for active employees)
SELECT
    first_name,
    last_name,
    TIMESTAMPDIFF(YEAR, hire_date, IF(term_date IS NULL, CURDATE(), term_date)) AS Tenure,
    IF(term_date IS NOT NULL, "Terminated", "Working Here") AS Employee_status
FROM
    employees;

-- 3. Departmental Turnover Rates: Compute turnover rates by department to identify areas with higher employee exits.
Select 
	dp.department_name,
	count(*) as total_employees,
    count(case when emp.term_date IS NOT NULL THEN 1 ELSE 0 END) AS Total_exits,
    Round(sum(case when emp.term_date IS NOT NULL THEN 1 ELSE 0 END)/count(*)*100, 2) as Turnover_rate
from 
employees emp
        LEFT JOIN
    employee_job_history AS jh ON emp.employee_id = jh.employee_id
        LEFT JOIN
    job_titles AS jt ON jh.job_title_id = jt.job_title_id
        LEFT JOIN
    departments AS dp ON jt.department_id = dp.department_id
    GROUP BY dp.department_name 
	ORDER BY  dp.department_name, total_employees, Turnover_rate desc;
    
-- 4. Job Titles by Location: Analyze the frequency of job titles in each location to see where specific roles are more concentrated.
SELECT 
    c.city_name,
    s.state_name,
    jt.job_title,
    COUNT(*) AS frequency
FROM 
    employees e
JOIN 
    cities as c ON e.city_id = c.city_id
JOIN 
    states as s ON c.state_id = s.state_id
JOIN 
    employee_job_history as ejh ON e.employee_id = ejh.employee_id
JOIN 
    job_titles as jt ON ejh.job_title_id = jt.job_title_id
GROUP BY 
    c.city_name, s.state_name, jt.job_title
ORDER BY 
    c.city_name, s.state_name, frequency DESC;
    
-- 5. Diversity Analysis: Count employees by race and department to understand racial diversity within teams.
select
	r.race_name,
    dp.department_name,
    count(*) as Number_of_Employees
FROM 
    employees as e
JOIN 
    cities as c ON e.city_id = c.city_id
JOIN 
    states as s ON c.state_id = s.state_id
JOIN 
    employee_job_history as ejh ON e.employee_id = ejh.employee_id
JOIN 
    job_titles as jt ON ejh.job_title_id = jt.job_title_id
JOIN
	departments as dp on jt.department_id=dp.department_id
JOIN 
	races as r on e.race_id=r.race_id
GROUP BY 
    r.race_name,
    dp.department_name
ORDER BY 
    r.race_name,
    dp.department_name, Number_of_Employees DESC;