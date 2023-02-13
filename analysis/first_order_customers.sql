with

orders_by_customer as (
    select
        customer_id
        , min(order_date) as first_order_date
        , count(*) as order_count
    from enablement_data_loader.website.orders
    where order_status <> 'Canceled'
    group by customer_id
)

select
    orders.first_order_date
    , datediff(day, orders.first_order_date, getdate()) as days_since_order
    , customers.id as customer_id
    , customers.email
    , customers.first || ' ' || customers.last as customer_name
from enablement_data_loader.crm.basecustomer__c as customers
join orders_by_customer as orders on customers.id = orders.customer_id
where orders.order_count = 1
