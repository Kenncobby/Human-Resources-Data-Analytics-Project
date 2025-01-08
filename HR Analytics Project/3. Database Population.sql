Use thr;

-- 1. Populate the `states` table
INSERT INTO states (state_id, state_name)
WITH state_loc AS (
    SELECT DISTINCT location_state
    FROM hr
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY location_state ASC) AS state_id,
    location_state
FROM state_loc;

-- 2. Populate the `cities` table
INSERT INTO Cities (city_id, city_name, state_id)
SELECT 
    ROW_NUMBER() OVER (ORDER BY location_city) AS city_id,
    location_city AS city_name,
    DENSE_RANK() OVER (ORDER BY location_state) AS state_id
FROM (
    SELECT DISTINCT location_city, location_state
    FROM hr
    WHERE location_city IS NOT NULL AND location_state IS NOT NULL
) AS UniqueCities;

-- 3. Populate the `races` table
INSERT INTO races (race_name, race_id)
WITH DistinctRaces AS (
    SELECT DISTINCT race
    FROM hr
)
SELECT 
    race,
    ROW_NUMBER() OVER (ORDER BY race ASC)
FROM DistinctRaces;

-- 4. Populate the `departments` table
INSERT INTO departments
WITH DistinctDept AS (
    SELECT DISTINCT department
    FROM hr
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY department ASC),
    department
FROM DistinctDept;

-- 5. Populate the `job_titles` table
INSERT INTO job_titles (job_title_id, job_title, department_id)
WITH UniqueDepartments AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY department) AS department_id,
        department
    FROM (
        SELECT DISTINCT department 
        FROM hr
    ) d
),
UniqueJobTitles AS (
    SELECT 
        jobtitle
    FROM (
        SELECT DISTINCT jobtitle 
        FROM hr
    ) j
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY jobtitle) AS job_title_id,
    uj.jobtitle,
    ud.department_id
FROM UniqueJobTitles uj
JOIN hr ON hr.jobtitle = uj.jobtitle
JOIN UniqueDepartments ud ON hr.department = ud.department
GROUP BY 
     uj.jobtitle, ud.department_id, ud.department;

-- 6. Populate the `work_format` table
INSERT INTO work_format (format_id, format)
SELECT
    ROW_NUMBER() OVER (ORDER BY location) AS format_id,
    location AS format
FROM hr
GROUP BY location;

-- 7. Populate the `employees` table
INSERT INTO employees (employee_id, first_name, last_name, gender, birthdate, race_id, hire_date, term_date, city_id, format_id)
WITH part_1 AS (
    SELECT emp_id, first_name, last_name, gender, race,
    location, CASE WHEN location = "Headquarters" THEN "1" ELSE "2" END AS format_id
    FROM hr
),
ToBeInserted AS (
  SELECT 
    emp_id,
    IF(birthdate = '0000-00-00', NULL, birthdate) AS birthdate,
    race,
    IF(hire_date = '0000-00-00', NULL, hire_date) AS hire_date,
    IF(termdate = '0000-00-00', NULL, termdate) AS termdate,
    location_city,
    location_state
  FROM hr
),
cities_table AS (
    SELECT 
        ROW_NUMBER() OVER (PARTITION BY location_state ORDER BY location_city) AS city_id,
        location_city AS city_name,
        location_state,
        DENSE_RANK() OVER (ORDER BY location_state) AS state_id
    FROM (
        SELECT DISTINCT location_city, location_state
        FROM hr
        WHERE location_city IS NOT NULL AND location_state IS NOT NULL
    ) AS UniqueCities
),
race_table AS (
    WITH DistinctRaces AS (
        SELECT DISTINCT race
        FROM hr
    )
    SELECT 
        race,
        ROW_NUMBER() OVER (ORDER BY race ASC) AS race_id
    FROM DistinctRaces
)
SELECT 
    p.emp_id, p.first_name, p.last_name, p.gender,
    t.birthdate,
    r.race_id,
    t.hire_date,
    t.termdate,
    c.city_id, p.format_id
FROM  ToBeInserted AS t
LEFT JOIN part_1 AS p
ON t.emp_id = p.emp_id
LEFT JOIN race_table AS r
ON t.race = r.race
LEFT JOIN cities_table AS c
ON t.location_city = c.city_name
   AND t.location_state = c.location_state;

-- 8. Populate the `employee_job_history` table
INSERT INTO employee_job_history (history_id, employee_id, job_title_id, start_date, end_date)
WITH UniqueDepartments AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY department) AS department_id,
        department
    FROM (
        SELECT DISTINCT department 
        FROM hr
    ) AS d
),
UniqueJobTitles AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY jobtitle) AS job_title_id,
        jobtitle
    FROM (
        SELECT DISTINCT jobtitle 
        FROM hr
    ) AS j
),
EmployeeHistory AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY emp_id) AS history_id,
        emp_id AS emp_id,
        ut.job_title_id,
        emp.hire_date AS start_date,
        CASE 
            WHEN emp.termdate = '0000-00-00' THEN NULL
            ELSE emp.termdate
        END AS end_date
    FROM hr AS emp
    JOIN UniqueJobTitles ut ON emp.jobtitle = ut.jobtitle
)
SELECT 
    history_id,
    emp_id,
    job_title_id,
    start_date,
    end_date
FROM EmployeeHistory;
