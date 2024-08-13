CREATE OR REPLACE TABLE business (
    business_id STRING PRIMARY KEY,
    address STRING,
    attributes OBJECT,
    categories STRING,
    city STRING,
    hours VARIANT,
    is_open INT,
    latitude FLOAT,
    longitude FLOAT,
    name STRING,
    postal_code TEXT,
    review_count INT,
    stars INT,
    state STRING
);

CREATE OR REPLACE TABLE checkin (
    checkin_id INT PRIMARY KEY IDENTITY,
    business_id STRING,
    date STRING,
    CONSTRAINT FK_BU_ID FOREIGN KEY (business_id) REFERENCES business(business_id)
);

CREATE OR REPLACE TABLE covid_feature (
    covid_feature_id INT PRIMARY KEY IDENTITY,
    business_id STRING,
    call_to_action_enable STRING,
    covid_banner STRING,
    grubhub_enabled STRING,
    request_a_quote_enabled STRING,
    temporary_closed_until STRING,
    virtual_services_offered STRING,
    delivery_or_takeout STRING,
    highlights STRING,
    CONSTRAINT FK_BU_ID FOREIGN KEY (business_id) REFERENCES business(business_id)
);

CREATE OR REPLACE TABLE user (
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
    yelping_since STRING
);

CREATE OR REPLACE TABLE tip (
    tip_id INT PRIMARY KEY IDENTITY,
    business_id STRING,
    user_id STRING,
    compliment_count INT,
    date STRING,
    text STRING,
    CONSTRAINT FK_BU_ID FOREIGN KEY (business_id) REFERENCES business(business_id),
    CONSTRAINT FK_US_ID FOREIGN KEY (user_id) REFERENCES user(user_id)
);


CREATE OR REPLACE TABLE precipitation (
    date DATE PRIMARY KEY,
    precipitation FLOAT,
    precipitation_normal FLOAT
);

CREATE OR REPLACE TABLE temperature (
    date DATE PRIMARY KEY,
    min FLOAT,
    max FLOAT,
    normal_min FLOAT,
    normal_max FLOAT
);

CREATE OR REPLACE TABLE review (
    review_id STRING PRIMARY KEY,
    business_id STRING,
    user_id STRING,
    cool INT,
    review_date DATE,
    review_time TIMESTAMP,
    funny INT,
    stars INT,
    text STRING,
    useful INT,
    CONSTRAINT FK_BU_ID FOREIGN KEY (business_id) REFERENCES business(business_id),
    CONSTRAINT FK_PR_ID FOREIGN KEY (review_date) REFERENCES precipitation(date),
    CONSTRAINT FK_TE_ID FOREIGN KEY (review_date) REFERENCES temperature(date)
);


TRUNCATE business;
TRUNCATE checkin;
TRUNCATE review;
TRUNCATE tip;
TRUNCATE user;
TRUNCATE covid_feature;
TRUNCATE precipitation;
TRUNCATE temperature;

-- INSERT DATA INTO TABLE

INSERT INTO business(
    business_id,
    address,
    attributes,
    categories,
    city,
    hours,
    is_open,
    latitude,
    longitude,
    name,
    postal_code,
    review_count,
    stars,
    state
)SELECT parse_json($1):business_id,
    parse_json($1):address,
    parse_json($1):attributes,
    parse_json($1):categories,
    parse_json($1):city,
    parse_json($1):hours,
    parse_json($1):is_open,
    parse_json($1):latitude,
    parse_json($1):longitude,
    parse_json($1):name,
    parse_json($1):postal_code,
    parse_json($1):review_count,
    parse_json($1):stars,
    parse_json($1):state
FROM UDACITY_PROJECT_2.STAGING.business_yelp;

INSERT INTO checkin(
    business_id,
    date
) SELECT parse_json($1):business_id,
    parse_json($1):date
FROM UDACITY_PROJECT_2.STAGING.checkin_yelp;

INSERT INTO review(
    review_id,
    business_id,
    user_id,
    cool,
    review_date,
    review_time,
    funny,
    stars,
    text,
    useful
) SELECT parse_json($1):review_id,
    parse_json($1):business_id,
    parse_json($1):user_id,
    parse_json($1):cool,
    TO_DATE(LEFT(parse_json($1):date, 10), 'YYYY-MM-DD') AS review_date,
    TO_TIMESTAMP(parse_json($1):date) AS review_time,
    parse_json($1):funny,
    parse_json($1):stars,
    parse_json($1):text,
    parse_json($1):useful
FROM UDACITY_PROJECT_2.STAGING.review_yelp;

INSERT INTO tip(
    business_id,
    user_id,
    compliment_count,
    date,
    text
) SELECT parse_json($1):business_id,
    parse_json($1):user_id,
    parse_json($1):compliment_count,
    parse_json($1):date,
    parse_json($1):text
FROM UDACITY_PROJECT_2.STAGING.tip_yelp;

INSERT INTO user(
    user_id,
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
    yelping_since
) SELECT parse_json($1):user_id,
    parse_json($1):average_stars,
    parse_json($1):compliment_cool,
    parse_json($1):compliment_cute,
    parse_json($1):compliment_funny,
    parse_json($1):compliment_hot,
    parse_json($1):compliment_list,
    parse_json($1):compliment_more,
    parse_json($1):compliment_note,
    parse_json($1):compliment_photos,
    parse_json($1):compliment_plain,
    parse_json($1):compliment_profile,
    parse_json($1):compliment_writer,
    parse_json($1):cool,
    parse_json($1):elite,
    parse_json($1):fans,
    parse_json($1):friends,
    parse_json($1):funny,
    parse_json($1):name,
    parse_json($1):review_count,
    parse_json($1):useful,
    parse_json($1):yelping_since
FROM UDACITY_PROJECT_2.STAGING.user_yelp;

INSERT INTO covid_feature(
    business_id,
    call_to_action_enable,
    covid_banner,
    grubhub_enabled,
    request_a_quote_enabled,
    temporary_closed_until,
    virtual_services_offered,
    delivery_or_takeout,
    highlights
) SELECT parse_json($1):business_id,
    parse_json($1):"Call To Action enabled",
    parse_json($1):"Covid Banner",
    parse_json($1):"Grubhub enabled",
    parse_json($1):"Request a Quote Enabled",
    parse_json($1):"Temporary Closed Until",
    parse_json($1):"Virtual Services Offered",
    parse_json($1):"delivery or takeout",
    parse_json($1):highlights
FROM UDACITY_PROJECT_2.STAGING.covid_features_yelp;

INSERT INTO precipitation(
    date,
    precipitation,
    precipitation_normal
) SELECT TO_DATE(date, 'YYYYMMDD'),
    TRY_CAST(precipitation AS FLOAT),
    TRY_CAST(precipitation_normal AS FLOAT)
FROM UDACITY_PROJECT_2.STAGING.precipitation_climate;

INSERT INTO temperature(
    date,
    min,
    max,
    normal_min,
    normal_max
) SELECT TO_DATE(date, 'YYYYMMDD'),
    min,
    max,
    normal_min,
    normal_max
FROM UDACITY_PROJECT_2.STAGING.temperature_climate;