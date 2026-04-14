{{ config(tags=['daily']) }}

WITH items AS (
    SELECT order_id,
           price
    FROM {{ ref('stg_items') }}
),
    orders AS (
        SELECT order_id,
               customer_id
        FROM {{ ref('stg_orders') }}
    ),
    customers as (
        SELECT customer_id,
               customer_state
        FROM {{ ref('stg_customers') }}
    ),
    joined as (
        select customer_state,
               round(sum(price)/1000000, 1) as revenue_million
        from items i
        left join orders o
        on 1
        inner join customers c
        on c.customer_id = o.customer_id
        group by customer_state
        order by revenue_million desc
    )
select * from joined