{{ config(tags=['hourly']) }}

WITH items AS (
    SELECT order_id,
           seller_id
    FROM {{ ref('stg_items') }}
),
    sellers as (
        select seller_id,
               seller_city
        from {{ ref('stg_sellers') }}
    ),
    reviews as (
        select order_id,
               review_score
        from {{ ref('stg_reviews') }}
    ),
    joined as (
        select i.seller_id,
               seller_city,
               round(avg(review_score), 2) as avg_score
        from items i
        left join sellers s
        on i.seller_id = s.seller_id
        left join reviews r
        on r.order_id = i.order_id
        group by i.seller_id, seller_city
        order by avg_score desc
    )
select * from joined