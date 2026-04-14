{{ config(tags=['hourly']) }}

SELECT order_id,
       shipping_limit_date,
       product_id,
       seller_id,
       CAST(price AS DECIMAL(18, 2)) AS price,
       freight_value
FROM {{ source('olist_raw', 'olist_order_items_dataset') }}