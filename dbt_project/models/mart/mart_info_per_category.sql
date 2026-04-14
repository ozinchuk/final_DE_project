{{ config(tags=['daily']) }}

WITH items AS (
    SELECT order_id,
           price,
           product_id
    FROM {{ ref('stg_items') }}
),
    products AS (
        SELECT product_id,
               product_category_name
        FROM {{ ref('stg_products') }}
    ),
    translations as (
        select product_category_name,
               product_category_name_eng
        from {{ ref('stg_translations') }}
    ),
    joined as (
        select product_category_name_eng as product_category,
               round(avg(price), 2) as avg_price,
               count(order_id) as items_count
        from items i
        left join products p
        on i.product_id = p.product_id
        inner join translations t
        on t.product_category_name = p.product_category_name
        group by product_category_name_eng
        order by items_count desc
    )
SELECT * FROM joined