{{ config(tags=['hourly']) }}

WITH items AS (
    SELECT order_id,
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
    reviews as (
        select order_id,
               review_score
        from {{ ref('stg_reviews') }}
    ),
    joined as (
        select product_category_name_eng,
               round(avg(review_score), 2) as avg_score
        from items i
        left join products p
        on i.product_id = p.product_id
        left join reviews r
        on r.order_id = i.order_id
        left join translations t
        on t.product_category_name = p.product_category_name
        group by product_category_name_eng
        order by avg_score desc
    )
select * from joined