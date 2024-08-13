CREATE TABLE employee (
    emp_id varchar(6) primary key,
    emp_nm varchar(50),
    email varchar(50),
    hire_dt date
);

CREATE TABLE job_title (
    job_tit_id SERIAL primary key,
    job_tit_nm varchar(50)
);

CREATE TABLE department (
    dep_id SERIAL primary key,
    dep_nm varchar(50)
);

CREATE TABLE education_level (
    edu_lv_id SERIAL primary key,
    edu_lv_nm varchar(50)
);

CREATE TABLE work_period (
    work_period_id SERIAL primary key,
    emp_id varchar(6),
    job_tit_id int,
    salary_id int,
    dep_id int,
    manager_id varchar(6),
    start_dt date,
    end_dt date,
    location_id varchar(50),
    edu_lv_id varchar(50)
);

CREATE TABLE salary (
    salary_id SERIAL primary key,
    salary int
);

CREATE TABLE location (
    location_id SERIAL primary key,
    location_nm varchar(50),
    address varchar(50),
    city_id int
);

CREATE TABLE city (
    city_id SERIAL primary key,
    city_nm varchar(50),
    state_id int
);


CREATE TABLE state (
    state_id SERIAL primary key,
    state_nm varchar(50)
);