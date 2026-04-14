{{ config(tags=['daily']) }}

WITH items AS (
    SELECT order_id,
           price
    FROM {{ ref('stg_items') }}
),
    orders AS (
        SELECT order_id,
               order_status,
               order_delivered_customer_date
        FROM {{ ref('stg_orders') }}
    ),
    joined as (
        select date_trunc('month', order_delivered_customer_date) as delivery_month,
               sum(price) as total_revenue
        from orders o
        left join items i
        on 1
        where order_status = 'delivered'
        group by delivery_month
    ),
    run_total as (
        select delivery_month,
       sum(total_revenue) over(order by delivery_month) as running_total
        from joined
    ),
    prev_profit as (
        select delivery_month,
               running_total,
               lag(running_total, 1, null) over(order by delivery_month) as prev_month,
                running_total - prev_month as diff
from run_total
    )
select delivery_month, round(running_total, 0) as running_total, round(diff, 0) as diff from prev_profit
