select product_id,
       price
from {{ ref('stg_items') }}
where price < 0