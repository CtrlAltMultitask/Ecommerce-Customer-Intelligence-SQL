USE e_commerce;

-- ============================================================
-- CLEANED ORDERS VIEW
-- 02 CLEANED_ORDERS
-- ============================================================

drop view if exists cleaned_orders;

create view Cleaned_orders as (
select distinct
o.orderid, o.customerid,
str_to_date(
nullif(trim(o.orderdate), ''),
'%Y-%m-%d') as orderdate,
o.productid, o.quantity,
o.discount, o.paymentmethod,
o.status,
case
when o.quantity < 0 then 'Invalid - Negative'
when o.quantity = 0 then 'Invalid - Zero'
else 'Valid'
end as quantity_status,
case
when c.customerid is null then 'Invalid'
else 'Valid'
end as customer_reference_status
from orders o
left join customers c on 
o.customerid = c.customerid);

-- summary 

select
count(*) as total_rows,
sum(quantity_status <> 'Valid') as invalid_quantity_rows,
sum(customer_reference_status <> 'Valid') as invalid_customer_rows,
sum(orderdate is null) as missing_order_dates
from cleaned_orders;

-- call

select * from cleaned_orders;