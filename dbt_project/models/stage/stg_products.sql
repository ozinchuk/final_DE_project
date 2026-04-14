{{ config(tags=['hourly']) }}

SELECT product_id,
       TRIM(product_category_name) as product_category_name,
       product_name_lenght,
       product_description_lenght,
       product_photos_qty,
       product_weight_g,
       product_length_cm,
       product_height_cm,
       product_width_cm
FROM {{ source('olist_raw', 'olist_products_dataset') }}