{{ config(tags=['hourly']) }}

SELECT seller_id,
       CAST(seller_zip_code_prefix as VARCHAR(5)) as seller_zip,
       seller_city,
       seller_state
FROM {{ source('olist_raw', 'olist_sellers_dataset') }}