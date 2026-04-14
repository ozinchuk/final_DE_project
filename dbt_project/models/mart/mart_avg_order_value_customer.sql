{{ config(tags=['daily']) }}

with orders as (
    select order_id,
           customer_id,
           order_status
    from {{ ref('stg_orders') }}
),
    items as (
        select order_id,
               price
        from {{ ref('stg_items') }}
    ),
order_totals as (
    select
        o.order_id,
        o.customer_id,
        sum(price) as total_price
    from orders o
    join items i
    on o.order_id = i.order_id
    where order_status = 'delivered'
    group by 1, 2
),
    customer_added as (
        select
            customer_unique_id,
            count(o.order_id) as orders_count,
            sum(total_price) as total_spent,
            avg(total_price) as avg_order_price
        from {{ ref('stg_customers') }} c
        join order_totals o
        on c.customer_id = o.customer_id
        group by 1
)

select
    customer_unique_id,
    orders_count,
    round(total_spent, 2) as total_spent,
    round(avg_order_price, 2) as avg_order_price
from customer_added
order by total_spent desc