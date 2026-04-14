{{ config(tags=['hourly']) }}

SELECT customer_id,
       customer_unique_id,
       CAST(customer_zip_code_prefix AS VARCHAR(5)) AS customer_zip,
       customer_city,
       customer_state
FROM {{ source('olist_raw', 'olist_customers_dataset') }}