use e_commerce;

-- ============================================================
-- E-COMMERCE CUSTOMER INTELLIGENCE
-- 05. PURCHASE BEHAVIOR ANALYSIS
-- ============================================================

drop view if exists product_behavior;

create view Product_behavior as(
with valid_orders as(
select * from cleaned_orders
where quantity > 0 
and customer_reference_status = 'Valid'
and orderdate is not null
and status = 'Completed'),
Prod_Quantity as (
select o.customerid, p.productid, sum(o.quantity)
as Total_Product_Quantity, p.productname
from valid_orders o join products p
on o.productid=p.productid
group by o.customerid,p.productid,p.productname
order by customerid),
Rankings as (
select customerid, productid,
total_product_quantity, productname,
row_number() over (partition by customerid 
order by total_product_quantity desc)
as Ranking 
from prod_Quantity),
rev as(
select r.customerid, r.productid,
r.total_product_quantity, r.productname, ranking,
sum(p.unitprice * o.quantity * (1- o.discount))
as Revenue_By_that_Product
from rankings r join products p
on r.productid=p.productid 
join valid_orders o on o.customerid=r.customerid
and o.productid=r.productid
group by r.customerid, r.productid, r.productname)
select customerid, productid,
total_product_quantity,productname,
revenue_by_that_product from rev 
where ranking =1 
order by customerid);

-- call 

select productid,
productname,
count(*) AS customers,
sum(total_product_quantity) as total_units,
sum(revenue_by_that_product) as total_revenue
from Product_Behavior
group by productid, productname
order by total_revenue desc;
