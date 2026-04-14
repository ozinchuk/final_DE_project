{{ config(tags=['hourly']) }}

with orders as (
    SELECT order_id,
           order_status
from {{ ref('stg_orders') }}
),
    order_stat_count as (
        SELECT order_status,
       count(distinct order_id) as order_count
        from orders
        group by order_status
        order by
            case order_status
        when 'created' then 1
        when 'approved' then 2
        when 'invoiced' then 3
        when 'processing' then 4
        when 'shipped' then 5
        when 'unavailable' then 6
        when 'delivered' then 7
        else 8
        end
        )
select concat(round(sum(case when order_status = 'canceled' then order_count else 0 end) * 100/sum(order_count), 2), '%') as cancellation_rate from order_stat_count
