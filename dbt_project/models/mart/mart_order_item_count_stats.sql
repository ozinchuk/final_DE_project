{{ config(tags=['daily']) }}

with order_counts as (
    select order_id,
           count(product_id) as items_in_order
    from {{ ref('stg_items') }}
    group by 1
),
    order_segments as (
    select
        order_id,
        items_in_order,
        case
            when items_in_order = 1 then 'Single Item'
            when items_in_order between 2 and 3 then 'Small Bundle (2-3)'
            else 'Large Bundle (4+)'
        end as order_type
    from order_counts
)
select
    order_type,
    count(order_id) as total_orders,
    concat(round(count(order_id) * 100.0 / sum(count(order_id)) over(), 2), '%') as percentage
from order_segments
group by 1
order by total_orders desc