-- Create the database
create database thr;

-- Set the systen to us the new_hr database
Use thr;

                                                   -- TABLES CREATION
-- Create races table
CREATE TABLE races (
    race_id INT PRIMARY KEY,
    race_name VARCHAR(100)
);

-- Create states table
CREATE TABLE states (
    state_id INT PRIMARY KEY,
    state_name VARCHAR(100)
);

-- Create cities table
CREATE TABLE cities (
    city_id INT PRIMARY KEY,
    city_name VARCHAR(60),
    state_id INT,
    FOREIGN KEY (state_id) REFERENCES states(state_id)
);

-- Create work_format table
CREATE TABLE work_format (
    format_id INT PRIMARY KEY,
    format VARCHAR(12)
);

-- Create departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

-- Create job_titles table
CREATE TABLE job_titles (
    job_title_id INT PRIMARY KEY,
    job_title VARCHAR(100),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Create employees table
CREATE TABLE employees (
    employee_id VARCHAR(20) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender TEXT,
    birthdate DATE,
    race_id INT,
    hire_date DATE,
    term_date DATE,
    city_id INT,
    format_id INT,
    FOREIGN KEY (race_id) REFERENCES races(race_id),
    FOREIGN KEY (city_id) REFERENCES cities(city_id),
    FOREIGN KEY (format_id) REFERENCES work_format(format_id)
);

-- Create employee_job_history table
CREATE TABLE employee_job_history (
    history_id INT PRIMARY KEY,
    employee_id VARCHAR(20),
    job_title_id INT,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (job_title_id) REFERENCES job_titles(job_title_id)
);
