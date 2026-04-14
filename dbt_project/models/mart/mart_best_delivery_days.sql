{{ config(tags=['daily']) }}

select dayname(order_purchase_timestamp) as purchase_day,
       round(avg(datediff('day', order_purchase_timestamp, order_delivered_customer_date)))
from {{ ref('stg_orders') }} as delivery_duration
    group by purchase_day
order by case purchase_day
    when 'Monday' then 1
    when 'Tuesday' then 2
    when 'Wednesday' then 3
    when 'Thursday' then 4
    when 'Friday' then 5
    when 'Saturday' then 6
    else 7
end
