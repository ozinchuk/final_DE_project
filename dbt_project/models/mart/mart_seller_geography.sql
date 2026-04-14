{{ config(tags=['daily']) }}

with sellers as (
    select seller_id,
           seller_city,
           seller_state
    from {{ ref('stg_sellers') }}
)
select seller_state,
       seller_city,
       count(distinct seller_id) as seller_count
from sellers
group by 1, 2
order by seller_state, seller_city desc