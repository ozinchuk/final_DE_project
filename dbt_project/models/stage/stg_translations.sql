{{ config(tags=['hourly']) }}

SELECT REPLACE(product_category_name, '_', ' ') as product_category_name,
       REPLACE(product_category_name_english, '_', ' ') as product_category_name_eng
FROM {{ ref('product_category_name_translation') }}