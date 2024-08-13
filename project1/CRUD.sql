SELECT
    p.emp_id,
    p.emp_nm,
    p.job_title,
    p.department_nm
FROM
    proj_stg as p;
    

INSERT INTO job_title(job_tit_nm)
VALUES('Web Programmer');
SELECT * FROM job_title as j;


UPDATE job_title
SET job_tit_nm = 'Web Developer'
WHERE job_tit_nm = 'Web Programmer';
SELECT *
FROM job_title;


DELETE
FROM job_title
WHERE job_tit_nm = 'Web Developer';
SELECT *
FROM job_title;


SELECT
    d.dep_id,
    d.dep_nm,
    count(w.*)
FROM
    work_period as w
INNER JOIN department as d
ON d.dep_id = w.dep_id
GROUP By
    d.dep_id;
    
SELECT 
    e.emp_nm,
    j.job_tit_nm,
    d.dep_nm,
    (
        SELECT
            m.emp_nm as manager_nm
        FROM
            employee as m
        WHERE
            m.emp_id = w.manager_id
    ),
    w.start_dt,
    w.end_dt
FROM
    work_period as w
INNER JOIN employee as e
ON e.emp_id = w.emp_id
INNER JOIN job_title as j
ON  j.job_tit_id = w.job_tit_id
INNER JOIN department as d
ON d.dep_id = w.dep_id
WHERE e.emp_nm = 'Toni Lembeck';