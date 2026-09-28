USE e_commerce;

-- ============================================================
-- E-COMMERCE CUSTOMER INTELLIGENCE
-- 03. REVENUE ANALYSIS
-- ============================================================

drop view if exists Revenue_Analysis;

create View Revenue_Analysis As(
with cRevenue as (
select o.customerid,
count(o.orderid) as Total_orders,
sum(o.quantity) as Total_Pur_Quantity,
sum(o.quantity * p.unitprice * (1 - o.discount))
as Customer_Revenue from Cleaned_orders o join 
products p on 
o.productid=p.productid
where o.quantity > 0
and o.customer_reference_status = 'Valid'
and o.orderdate is not null
group by o.customerid),
Share as (
select customerid, total_orders,
Total_Pur_Quantity, Customer_revenue,
Customer_revenue / Total_orders as avg_order_value,
(Customer_revenue / (select sum(Customer_revenue) from cRevenue)) * 100 as Revenue_Share
from cRevenue)
select customerid, Total_orders,
Total_pur_Quantity, Customer_Revenue,
avg_Order_Value, Revenue_Share,
sum(revenue_Share) over(order by Customer_revenue desc, customerid)
as Cumulative_Rev_Share,
dense_rank() over(order by Customer_revenue desc)
as Revenue_rank from share);

-- call

select * from revenue_analysis;