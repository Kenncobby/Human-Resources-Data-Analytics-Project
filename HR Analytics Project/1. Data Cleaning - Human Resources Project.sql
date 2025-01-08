-- Create a new database for THR.
CREATE DATABASE thr;

-- Switch to using the THR database.
USE thr;

-- Create the Human Resouces table
CREATE TABLE HR (
emp_id varchar(20), 
first_name text ,
last_name text ,
birthdate varchar(20), 
gender text ,
race text ,
department text, 
jobtitle text ,
location text ,
hire_date varchar(20), 
termdate varchar(20),
location_city text, 
location_state text, 
age int
)

-- Load the human recouces dataset in to the above created Human Resources table. (Using the table data import wizard)

-- Select all records from the HR table to inspect the dataset.
SELECT 
    *
FROM
    hr;

-- Rename the column 'ï»¿id' to 'emp_id' and set its data type to VARCHAR(20).
ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

-- Describe the HR table to check the structure of the columns after changes.
DESCRIBE hr;

-- Select the 'birthdate' column to inspect the current format of the data.
SELECT birthdate FROM hr;

-- Disable SQL safe updates to allow updating the table without strict conditions.
SET sql_safe_updates = 0;

-- Update the 'birthdate' column to a consistent 'YYYY-MM-DD' format.
UPDATE hr
SET birthdate = CASE
    WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
    END;


-- Update the 'hire_date' column to a consistent 'YYYY-MM-DD' format.
UPDATE hr
SET hire_date = CASE
    WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
    END;



-- Update the 'termdate' column to a consistent format and handle empty values.
UPDATE hr
SET termdate = CASE
    WHEN TRIM(termdate) = '' THEN '0000-00-00'
    WHEN STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC') IS NOT NULL THEN DATE(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC'))
    ELSE '0000-00-00'
END;

-- Check if the termdates are up to date
SELECT * 
FROM hr
WHERE termdate <= '2024-12-31'
ORDER BY termdate;


-- Add a new column 'age' to the HR table to store the calculated age of employees.
ALTER TABLE hr ADD COLUMN age INT;

-- Calculate and update the 'age' column based on the 'birthdate' column.
UPDATE hr
SET age = TIMESTAMPDIFF(YEAR, birthdate, CURDATE());

-- Find the youngest and oldest ages in the HR table to inspect age the extremes.
SELECT 
    min(age) AS youngest,
    max(age) AS oldest
FROM hr;

-- Check for values that are negative in the Age column and count the number of employees with negative ages.
SELECT count(*) FROM hr WHERE age < 0;

-- Delete entries where termdate is greater than 2024 and age is less than zero
Delete
FROM employees
WHERE term_date <= '2024-12-31' and age < 0
ORDER BY term_date;
