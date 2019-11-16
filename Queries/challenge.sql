-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Create new table to hold current employees
SELECT ri.emp_no, ri.first_name, ri.last_name, de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_employees as de ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');
-- Check the table
SELECT * FROM current_emp;

-- Challenge queries
-- Create new table containing titles of possible retirees
SELECT ce.emp_no, ce.first_name, ce.last_name, titles.title, titles.from_date, salaries.salary
INTO retiring_titles
FROM titles
RIGHT JOIN current_emp AS ce ON titles.emp_no = ce.emp_no
LEFT JOIN salaries ON ce.emp_no = salaries.emp_no;
SELECT * FROM retiring_titles;


-- Exclude rows of data containing duplicate names to get most recent title
SELECT emp_no, first_name, last_name, title, from_date, salary 
INTO recent_titles
	FROM(
	SELECT
		emp_no,
		first_name,
		last_name,
		title,
		from_date,
		salary,
	ROW_NUMBER() OVER (PARTITION BY (emp_no) ORDER BY from_date DESC)
	FROM retiring_titles) AS tmp
WHERE row_number = 1;
SELECT * FROM recent_titles;

-- How many employees share the same title?
SELECT
	title,
	count(*)
INTO ret_title_count
FROM recent_titles
GROUP BY title
HAVING count(*) > 1;
SELECT * FROM ret_title_count;

-- Who's Ready for a Mentor? Create a new table with employees with birth date between 1/1/65-12/31/65
SELECT e.emp_no, e.first_name, e.last_name, titles.title, titles.from_date, titles.to_date
INTO mentors
FROM employees as e
INNER JOIN titles ON e.emp_no = titles.emp_no
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (titles.to_date = '9999-01-01')
ORDER BY e.emp_no;
SELECT * FROM mentors;