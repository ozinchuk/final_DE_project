{{ config(tags=['daily']) }}

with sellers as (
    select seller_id,
    seller_city
    from {{ ref('stg_sellers') }}
),
items as (
        select order_id,
            seller_id,
            shipping_limit_date
            from {{ ref('stg_items') }}
),
    orders as (
        select order_id,
            order_delivered_carrier_date
            from {{ ref('stg_orders') }}
    )
select
    i.seller_id,
    seller_city,
    count(i.order_id) as total_items_shipped,
    count(case when order_delivered_carrier_date > shipping_limit_date then 1 end) as delay_count,
    concat(round((delay_count / total_items_shipped) * 100, 2), '%') as delay_rate
from sellers s
join items i
on s.seller_id = i.seller_id
join orders o
on i.order_id = o.order_id
group by 1, 2
order by delay_rate desc