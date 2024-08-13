INSERT INTO employee (
    emp_id,
    emp_nm,
    email,
    hire_dt
)
SELECT DISTINCT
    p.emp_id,
    p.emp_nm,
    p.email,
    p.hire_dt
FROM proj_stg as p;

INSERT INTO job_title(job_tit_nm)
SELECT DISTINCT (job_title)
FROM proj_stg;

INSERT INTO department(dep_nm)
SELECT DISTINCT (department_nm)
FROM proj_stg;

INSERT INTO education_level(edu_lv_nm)
SELECT DISTINCT (education_lvl)
FROM proj_stg;

INSERT INTO salary(salary)
SELECT DISTINCT (salary)
FROM proj_stg;

INSERT INTO state(state_nm)
SELECT DISTINCT (state)
FROM proj_stg;

INSERT INTO city(city_nm, state_id)
SELECT 
    DISTINCT(p.city),
    st.state_id
FROM proj_stg as p
INNER JOIN state as st
ON p.state = st.state_nm;

INSERT INTO location(
    location_nm,
    address,
    city_id
)
SELECT
    DISTINCT(p.location),
    p.address,
    c.city_id
FROM
    proj_stg as p
INNER JOIN city as c
ON p.city = c.city_nm;

INSERT INTO work_period(
    emp_id,
    job_tit_id,
    salary_id,
    dep_id,
    manager_id,
    start_dt,
    end_dt,
    location_id,
    edu_lv_id
)
SELECT
    p.emp_id,
    j.job_tit_id,
    s.salary_id,
    d.dep_id,
    (
        SELECT emp_id
        FROM employee
        WHERE emp_nm = p.manager
    ),
    p.start_dt,
    p.end_dt,
    l.location_id,
    e.edu_lv_id
FROM
    proj_stg as p
INNER JOIN job_title as j
ON
    j.job_tit_nm = p.job_title
INNER JOIN department as d
ON
    d.dep_nm = p.department_nm
INNER JOIN location as l
ON
    l.location_nm = p.location
INNER JOIN education_level as e
ON 
    e.edu_lv_nm = p.education_lvl
INNER JOIN salary as s
ON
    s.salary = p.salary;