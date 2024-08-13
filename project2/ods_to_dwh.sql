CREATE OR REPLACE TABLE dim_business (
    business_id STRING PRIMARY KEY,
    address STRING,
    attributes OBJECT,
    categories STRING,
    city STRING,
    hours VARIANT,
    is_open BOOLEAN,
    latitude FLOAT,
    longitude FLOAT,
    name STRING,
    postal_code TEXT,
    review_count INT,
    stars INT,
    state STRING
);

CREATE OR REPLACE TABLE dim_checkin (
    checkin_id INT PRIMARY KEY,
    business_id VARCHAR,
    date STRING
);

CREATE OR REPLACE TABLE dim_tip (
    tip_id INT PRIMARY KEY,
    business_id STRING,
    user_id STRING,
    compliment_count INT,
    date TIMESTAMP,
    text STRING
);

CREATE OR REPLACE TABLE dim_covid_feature (
    covid_feature_id INT PRIMARY KEY,
    business_id STRING,
    call_to_action_enable STRING,
    covid_banner STRING,
    grubhub_enabled STRING,
    request_a_quote_enabled STRING,
    temporary_closed_until STRING,
    virtual_services_offered STRING,
    delivery_or_takeout STRING,
    highlights STRING
);

CREATE OR REPLACE TABLE dim_user (
    user_id STRING PRIMARY KEY,
    average_stars FLOAT,
    compliment_cool INT,
    compliment_cute INT,
    compliment_funny INT,
    compliment_hot INT,
    compliment_list INT,
    compliment_more INT,
    compliment_note INT,
    compliment_photos INT,
    compliment_plain INT,
    compliment_profile INT,
    compliment_writer INT,
    cool INT,
    elite STRING,
    fans INT,
    friends STRING,
    funny INT,
    name STRING,
    review_count INT,
    useful INT,
    yelping_since TIMESTAMP
);

CREATE OR REPLACE TABLE dim_precipitation (
    date DATE PRIMARY KEY,
    precipitation FLOAT,
    precipitation_normal FLOAT
);

CREATE OR REPLACE TABLE dim_temperature (
    date DATE PRIMARY KEY,
    min FLOAT,
    max FLOAT,
    normal_min FLOAT,
    normal_max FLOAT
);

CREATE OR REPLACE TABLE fact_review (
    review_id STRING PRIMARY KEY,
    business_id STRING,
    user_id STRING,
    checkin_id INT,
    tip_id INT,
    covid_feature_id INT,
    review_date DATE,
    review_time TIMESTAMP,
    cool INT,
    funny INT,
    stars INT,
    text STRING,
    useful INT,
    CONSTRAINT FK_BU_ID FOREIGN KEY (business_id) REFERENCES dim_business(business_id),
    CONSTRAINT FK_US_ID FOREIGN KEY (user_id) REFERENCES dim_user(user_id),
    CONSTRAINT FK_CI_ID FOREIGN KEY (checkin_id) REFERENCES dim_checkin(checkin_id),
    CONSTRAINT FK_TI_ID FOREIGN KEY (tip_id) REFERENCES dim_tip(tip_id),
    CONSTRAINT FK_CV_ID FOREIGN KEY (covid_feature_id) REFERENCES dim_covid_feature(covid_feature_id),
    CONSTRAINT FK_PR_ID FOREIGN KEY (review_date) REFERENCES dim_precipitation(date),
    CONSTRAINT FK_TE_ID FOREIGN KEY (review_date) REFERENCES dim_temperature(date)
);

TRUNCATE dim_business;
TRUNCATE dim_checkin;
TRUNCATE fact_review;
TRUNCATE dim_tip;
TRUNCATE dim_user;
TRUNCATE dim_covid_feature;
TRUNCATE dim_precipitation;
TRUNCATE dim_temperature;

-- INSERT DATA INTO TABLE

INSERT INTO dim_business
SELECT business_id,
    address,
    attributes,
    categories,
    city,
    hours,
    (is_open = 1) AS is_open,
    latitude,
    longitude,
    name,
    postal_code,
    review_count,
    stars,
    state
FROM UDACITY_PROJECT_2.ODS.business;

INSERT INTO dim_checkin
SELECT *
FROM UDACITY_PROJECT_2.ODS.checkin;

INSERT INTO dim_tip
SELECT tip_id,
    business_id,
    user_id,
    compliment_count,
    TO_TIMESTAMP(date, 'YYYY-MM-DD HH24:MI:SS') AS date,
    text
FROM UDACITY_PROJECT_2.ODS.tip;

INSERT INTO dim_covid_feature
SELECT *
FROM UDACITY_PROJECT_2.ODS.covid_feature;

INSERT INTO dim_user
SELECT user_id,
    average_stars,
    compliment_cool,
    compliment_cute,
    compliment_funny,
    compliment_hot,
    compliment_list,
    compliment_more,
    compliment_note,
    compliment_photos,
    compliment_plain,
    compliment_profile,
    compliment_writer,
    cool,
    elite,
    fans,
    friends,
    funny,
    name,
    review_count,
    useful,
    TO_TIMESTAMP(yelping_since, 'YYYY-MM-DD HH24:MI:SS') AS yelping_since
FROM UDACITY_PROJECT_2.ODS.user;

INSERT INTO dim_precipitation
SELECT date,
    precipitation,
    precipitation_normal
FROM UDACITY_PROJECT_2.ODS.precipitation;

INSERT INTO dim_temperature
SELECT date,
    min,
    max,
    normal_min,
    normal_max
FROM UDACITY_PROJECT_2.ODS.temperature;

INSERT INTO fact_review
SELECT
    r.review_id,
    b.business_id,
    u.user_id,
    c.checkin_id,
    t.tip_id,
    cv.covid_feature_id,
    p.date,
    review_time,
    r.cool,
    r.funny,
    r.stars,
    r.text,
    r.useful,
FROM UDACITY_PROJECT_2.ODS.review as r,
    UDACITY_PROJECT_2.ODS.business as b,
    UDACITY_PROJECT_2.ODS.user as u,
    UDACITY_PROJECT_2.ODS.checkin as c,
    UDACITY_PROJECT_2.ODS.tip as t,
    UDACITY_PROJECT_2.ODS.covid_feature as cv,
    UDACITY_PROJECT_2.ODS.precipitation as p,
    UDACITY_PROJECT_2.ODS.temperature as te
WHERE (r.business_id = b.business_id)
AND (r.review_date = p.date)
AND (r.review_date = te.date)
AND (r.user_id = u.user_id)
AND (t.user_id = u.user_id)
AND (b.business_id = cv.business_id)
AND (b.business_id = c.business_id);

