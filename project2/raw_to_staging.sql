DROP TABLE IF EXISTS business_yelp;
CREATE TABLE business_yelp(business_json VARIANT);

DROP TABLE IF EXISTS checkin_yelp;
CREATE TABLE checkin_yelp(checkin_json VARIANT);

DROP TABLE IF EXISTS review_yelp;
CREATE TABLE review_yelp(review_json VARIANT);

DROP TABLE IF EXISTS tip_yelp;
CREATE TABLE tip_yelp(tip_json VARIANT);

DROP TABLE IF EXISTS user_yelp;
CREATE TABLE user_yelp(user_json VARIANT);

DROP TABLE IF EXISTS covid_features_yelp;
CREATE TABLE covid_features_yelp(covid_feature_json VARIANT);

DROP TABLE IF EXISTS precipitation_climate;
CREATE TABLE precipitation_climate(date STRING, precipitation STRING, precipitation_normal STRING);

DROP TABLE IF EXISTS temperature_climate;
CREATE TABLE temperature_climate(date STRING, min STRING, max STRING, normal_min STRING, normal_max STRING);

CREATE OR REPLACE FILE FORMAT myjsonformat TYPE='JSON';

CREATE OR REPLACE FILE FORMAT mycsvformat TYPE='CSV' FIELD_DELIMITER=',', SKIP_HEADER=1;

CREATE OR REPLACE STAGE my_json_stage file_format=myjsonformat;

CREATE OR REPLACE STAGE my_csv_stage file_format=mycsvformat;

/*
UPLOAD DATA BY SNOWFLAKE CLIENT
PUT file:///D:/udacity/project2/yelp_dataset/yelp_academic_dataset_business.json @my_json_stage auto_compress=true

PUT file:///D:/udacity/project2/yelp_dataset/yelp_academic_dataset_checkin.json @my_json_stage auto_compress=true

PUT file:///D:/udacity/project2/yelp_dataset/yelp_academic_dataset_review.json @my_json_stage auto_compress=true

PUT file:///D:/udacity/project2/yelp_dataset/yelp_academic_dataset_tip.json @my_json_stage auto_compress=true

PUT file:///D:/udacity/project2/yelp_dataset/yelp_academic_dataset_user.json @my_json_stage auto_compress=true

PUT file:///D:/udacity/project2/yelp_dataset/yelp_academic_dataset_covid_fetures.json @my_json_stage auto_compress=true
*/

COPY INTO business_yelp FROM @my_json_stage/yelp_academic_dataset_business.json.gz file_format=myjsonformat;

COPY INTO checkin_yelp FROM @my_json_stage/yelp_academic_dataset_checkin.json.gz file_format=myjsonformat;

COPY INTO review_yelp FROM @my_json_stage/yelp_academic_dataset_review.json.gz file_format=myjsonformat;

COPY INTO tip_yelp FROM @my_json_stage/yelp_academic_dataset_tip.json.gz file_format=myjsonformat;

-- COPY INTO user_yelp FROM @my_json_stage/yelp_academic_dataset_user.json.gz file_format=myjsonformat

COPY INTO covid_features_yelp FROM @my_json_stage/yelp_academic_dataset_covid_features.json.gz file_format=myjsonformat;

COPY INTO precipitation_climate FROM @my_csv_stage/usw00023169-las-vegas-mccarran-intl-ap-precipitation-inch.csv file_format=mycsvformat;

COPY INTO temperature_climate FROM @my_csv_stage/usw00023169-temperature-degreef.csv file_format=mycsvformat;

COPY INTO user_yelp FROM @my_json_stage/yelp_academic_dataset_user.json.gz file_format=myjsonformat
