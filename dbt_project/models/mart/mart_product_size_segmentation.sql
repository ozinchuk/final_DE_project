{{ config(tags=['daily']) }}

with product_volumes as (
    select
        i.product_id,
        price,
        (product_length_cm * product_height_cm * product_width_cm) as volume_cm3,
        product_weight_g
    from {{ ref('stg_products') }} p
    join {{ ref('stg_items') }} i
    on p.product_id = i.product_id
),
product_categories as (
    select
        *,
        case
            when volume_cm3 < 5000 then 'Small'
            when volume_cm3 between 5000 and 20000 then 'Medium'
            else 'Large'
        end as size_category
    from product_volumes
)
select
    size_category,
    count(product_id) as products_count,
    round(avg(price), 2) as avg_price,
    round(avg(product_weight_g), 2) as avg_weight_g
from product_categories
group by size_category
order by avg_price desc