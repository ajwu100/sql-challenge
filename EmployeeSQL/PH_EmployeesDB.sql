-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/x2nCFJ
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

-- Modify this code to update the DB schema diagram.
-- To reset the sample schema, replace everything with
-- two dots ('..' - without quotes).

CREATE TABLE "departments" (
    "dept_no" VARCHAR(4)   NOT NULL,
    "dept_name" VARCHAR(30)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR(4)   NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR(4)   NOT NULL,
    "emp_no" INT   NOT NULL
);

CREATE TABLE "employees" (
    "emp_no" INT   NOT NULL,
    "emp_title_id" VARCHAR(5)   NOT NULL,
    "birth_date" VARCHAR(10)   NOT NULL,
    "first_name" VARCHAR(30)   NOT NULL,
    "last_name" VARCHAR(30)   NOT NULL,
    "sex" VARCHAR(1)   NOT NULL,
    "hire_date" VARCHAR(10)   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no","emp_title_id"
     )
);

CREATE TABLE "salaries" (
    "emp_no" INT   NOT NULL,
    "salary" INT   NOT NULL
);

CREATE TABLE "titles" (
    "title_id" VARCHAR(5)   NOT NULL,
    "title" VARCHAR(30)   NOT NULL
);

-- Rename employee table column from emp_title_id to title_id.  Match titles table.  
ALTER TABLE employees
	RENAME COLUMN emp_title_id TO title_id;
SELECT *
FROM employees;

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "titles" ADD CONSTRAINT "fk_titles_title_id" FOREIGN KEY("title_id")
REFERENCES "employees" ("title_id");

-- List the following details of each employee: employee number, last name, first name, sex and salary.
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees as e
JOIN salaries as s
	ON e.emp_no = s.emp_no;

-- List the first name, last name, and hire date for employees who were hired in 1986.
SELECT e.first_name, e.last_name, e.hire_date
FROM employees as e
WHERE hire_date 
LIKE '__/__/1986';

-- List the Manager of each department with the following information: department number, department name, the manager's employee number, last name
-- and first name.
SELECT dm.emp_no, e.last_name, e.first_name, dm.dept_no, d.dept_name  
FROM dept_manager as dm
	RIGHT JOIN departments as d
	ON dm.dept_no = d.dept_no
	LEFT JOIN employees as e
	ON dm.emp_no = e.emp_no;

-- List the department of each employee with the following information: employee number, last name, first name and department name.
SELECT de.emp_no, e.last_name, e.first_name, de.dept_no, d.dept_name  
FROM dept_emp as de
	RIGHT JOIN departments as d
	ON de.dept_no = d.dept_no
	LEFT JOIN employees as e
	ON de.emp_no = e.emp_no;

-- List first name, last name, and sex for employees whose first name is "Hercules" and last name begin with "B".
SELECT e.first_name, e.last_name, e.sex
FROM employees as e
WHERE first_name = 'Hercules' AND last_name LIKE 'B%'; 

-- List all employees in the Sales department, including their employee number, last name, first name and department name.
-- 1) Create a view by combining dept managers with employees.
CREATE VIEW dept_manager_emp AS
SELECT dm.dept_no, dm.emp_no
FROM dept_manager AS dm
UNION ALL
SELECT de.dept_no, de.emp_no
FROM dept_emp AS de;
-- 2) Join the combined view of managers and employees with departments and employee data and then search for Sales department.
SELECT dme.emp_no, e.last_name, e.first_name, dme.dept_no, d.dept_name  
FROM dept_manager_emp as dme
	RIGHT JOIN departments as d
	ON dme.dept_no = d.dept_no
	LEFT JOIN employees as e
	ON dme.emp_no = e.emp_no
	WHERE d.dept_name = 'Sales'; 

-- List all employees in the Sales and Development departments, including their employee number, last name, first name and department name.
-- Take same code from 2) and make the search for both Sales and Development departments. 
SELECT dme.emp_no, e.last_name, e.first_name, dme.dept_no, d.dept_name  
FROM dept_manager_emp as dme
	RIGHT JOIN departments as d
	ON dme.dept_no = d.dept_no
	LEFT JOIN employees as e
	ON dme.emp_no = e.emp_no
	WHERE d.dept_name = 'Sales' OR d.dept_name = 'Development';

-- In descending order, list the frequency count of employees last names.
SELECT last_name, COUNT (last_name)
FROM employees
GROUP BY last_name
ORDER BY COUNT (last_name) DESC;

-- See Jupyter notebook for bonus analyses.







