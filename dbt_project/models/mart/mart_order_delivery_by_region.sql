{{ config(tags=['daily']) }}

WITH orders AS (
        SELECT order_id,
               customer_id,
               order_delivered_carrier_date,
               order_delivered_customer_date
        FROM {{ ref('stg_orders') }}
    ),
    customers as (
        SELECT customer_id,
               customer_city
        FROM {{ ref('stg_customers') }}
    ),
    joined as (
        select customer_city,
               round(avg(date_diff('day', order_delivered_carrier_date, order_delivered_customer_date))) as avg_delivery_duration
        from orders o
        inner join customers c
        on c.customer_id = o.customer_id
        group by customer_city
        order by avg_delivery_duration desc
    )
select * from joined