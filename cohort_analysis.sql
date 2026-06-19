--Дослідження даних
SELECT * 
FROM project.cohort_users_raw 
LIMIT 10; 

SELECT * 
FROM project.cohort_events_raw 
LIMIT 10; 

--Створення CTE для очищення дат cohort_users_raw

WITH cleaned_users AS (
    SELECT
        user_id,
        full_name,
        email,
        country,
        signup_source,
        signup_device,
        promo_signup_flag,
        signup_datetime,
        REPLACE(REPLACE(SPLIT_PART(TRIM(signup_datetime),' ', 1),'.', '-'),'/', '-') AS date_clean
    FROM project.cohort_users_raw
    ),
final_users AS (
    SELECT *,
        CASE
             WHEN LENGTH(SPLIT_PART(date_clean, '-', 3)) = 4
                THEN TO_DATE(date_clean, 'DD-MM-YYYY')::timestamp
             WHEN LENGTH(SPLIT_PART(date_clean, '-', 3)) = 2
                THEN TO_DATE(date_clean, 'DD-MM-YY')::timestamp
             ELSE NULL
        END AS signup_ts
    FROM cleaned_users
)
SELECT *
FROM final_users;

--Створення CTE для очищення дат у cohort_events_raw
WITH cleaned_events AS (
    select event_id,
        user_id,
        event_type,
        revenue,
        event_datetime,
        REPLACE(REPLACE(SPLIT_PART(TRIM(event_datetime),' ', 1),'.', '-'),'/', '-') AS date_clean
    FROM project.cohort_events_raw
    ),
final_events AS (
    SELECT *,
        CASE
                WHEN LENGTH(SPLIT_PART(date_clean, '-', 3)) = 4
                THEN TO_DATE(date_clean, 'DD-MM-YYYY')::timestamp
                WHEN LENGTH(SPLIT_PART(date_clean, '-', 3)) = 2
                THEN TO_DATE(date_clean, 'DD-MM-YY')::timestamp
            ELSE NULL
        END AS event_ts
    FROM cleaned_events
)
SELECT *
FROM final_events;

--Об'єднання очищених таблиць
WITH cleaned_users AS (
    select user_id,
           full_name,
           email,
           country,
           signup_source,
           signup_device,
           promo_signup_flag,
           signup_datetime,
           REPLACE(REPLACE(SPLIT_PART(TRIM(signup_datetime),' ', 1),'.', '-'),'/', '-') AS date_clean
    FROM project.cohort_users_raw
    ),
final_users AS (
    SELECT *,
        CASE
             WHEN LENGTH(SPLIT_PART(date_clean, '-', 3)) = 4
                THEN TO_DATE(date_clean, 'DD-MM-YYYY')::timestamp
             WHEN LENGTH(SPLIT_PART(date_clean, '-', 3)) = 2
                THEN TO_DATE(date_clean, 'DD-MM-YY')::timestamp
             ELSE NULL
        END AS signup_ts
    FROM cleaned_users
),
 cleaned_events AS (
    select event_id,
        user_id,
        event_type,
        revenue,
        event_datetime,
        REPLACE(REPLACE(SPLIT_PART(TRIM(event_datetime),' ', 1),'.', '-'),'/', '-') AS date_clean
    FROM project.cohort_events_raw
    ),
final_events AS (
    SELECT *,
        CASE
                WHEN LENGTH(SPLIT_PART(date_clean, '-', 3)) = 4
                THEN TO_DATE(date_clean, 'DD-MM-YYYY')::timestamp
                WHEN LENGTH(SPLIT_PART(date_clean, '-', 3)) = 2
                THEN TO_DATE(date_clean, 'DD-MM-YY')::timestamp
            ELSE NULL
        END AS event_ts
    FROM cleaned_events
),
joined_data as(
SELECT  u.user_id, u.promo_signup_flag, u.signup_ts, e.event_ts, e.event_id,
                e.event_type,
       DATE_TRUNC('month', u.signup_ts)::date AS cohort_month,
        DATE_TRUNC('month', e.event_ts)::date AS event_month, 
        (
   EXTRACT(YEAR FROM AGE(e.event_ts, u.signup_ts)) * 12 +
   EXTRACT(MONTH FROM AGE(e.event_ts, u.signup_ts))
   ) AS month_offset
  FROM final_users u
join final_events e
on u.user_id=e.user_id
WHERE 
    u.signup_ts IS NOT NULL
    AND e.event_ts IS NOT NULL
    AND e.event_type IS NOT NULL
    AND e.event_type <> 'test_event'
    )
  SELECT
    promo_signup_flag,
    cohort_month,
    month_offset,
    COUNT(DISTINCT user_id) AS users_total
FROM joined_data
WHERE event_ts >= DATE '2025-01-01'
  AND event_ts < DATE '2025-07-01'
GROUP BY
    promo_signup_flag,
    cohort_month,
    month_offset
ORDER BY
    promo_signup_flag,
    cohort_month,
    month_offset;


