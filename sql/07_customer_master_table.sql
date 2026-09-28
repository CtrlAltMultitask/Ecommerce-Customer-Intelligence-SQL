use e_commerce;

-- ============================================================
-- E-COMMERCE CUSTOMER INTELLIGENCE
-- 07. CUSTOMER MASTER TABLE
-- ============================================================

drop view if exists Customer_Master;

create view Customer_Master as (
select r.customerid,

-- Revenue
r.total_orders, r.total_pur_quantity,
r.customer_revenue, r.avg_order_value,
r.revenue_share, r.revenue_rank,

-- Purchase Behavior
p.Classification, p.first_orderdate,
p.latest_orderdate, p.average_days_between_orders,
p.longest_days_gap,
p.recency, p.recency_segment,

-- Product Behavior
pb.productid, pb.productname,
pb.total_product_quantity,
pb.revenue_by_that_product,

-- Recency Frequency Monetary
rf.Recency_rate, rf.Frequency_rate,
rf.Monetary_rate, rf.RFM_Category

from revenue_analysis r
left join Purchase_behavior p
on r.customerid=p.customerid
left join product_behavior pb
on r.customerid=pb.customerid
left join Recency_Frequency_Monetary rf
on r.customerid=rf.customerid);

-- call

select customerid,
total_orders, 
round(customer_revenue, 2),
round(avg_order_value, 2 ), 
Classification,
Recency, Recency_Segment,
Productname, RFM_category
from customer_master
order by customer_revenue desc;