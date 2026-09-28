use e_commerce;

-- ============================================================
-- E-COMMERCE CUSTOMER INTELLIGENCE
-- 04. PURCHASE BEHAVIOR ANALYSIS
-- ============================================================
drop view if exists purhcase_behavior;

create view Purchase_Behavior as(
with valid_orders as (
select * from cleaned_orders
where quantity > 0
and customer_reference_status = 'Valid'
and orderdate is not null),
summary as (
select customerid, count(*) as Total_orders,
sum(Quantity) as Total_quantity,
min(orderdate) as First_orderdate,
max(orderdate) as Latest_orderdate
from valid_orders
group by customerid),
Days1 as (
select customerid, orderdate,
lead(orderdate) over(partition by customerid
order by orderdate) as Next_orderdate
from valid_orders),
Days as (
select customerid, datediff(Next_orderdate, orderdate)
as Days_between_orders,
avg(datediff(Next_orderdate,orderdate)) over(
partition by customerid)
as Average_Days_Between_orders,
Max(datediff(Next_orderdate, orderdate))
over(partition by customerid) as Longest_Days_gap
from days1),
Days2 as (
select distinct customerid , Average_days_Between_orders,
Longest_Days_gap from days),
classification as (
select s.customerid, s.total_orders,
s.total_quantity, s.First_orderdate,
s.latest_orderdate,d.average_days_between_orders,
d.longest_Days_gap
from summary s left join days2 d 
on s.customerid=d.customerid
order by customerid)
select customerid,total_orders,
case
when total_orders > 1 then 'Repeat Customer'
else 'One-Time Customer'
end as Classification ,
total_quantity, first_orderdate,
latest_orderdate, Average_days_Between_orders, 
Longest_days_gap, 
datediff((select max(orderdate) 
from valid_orders) ,latest_orderdate) 
as Recency,
case
when datediff((select max(orderdate) from valid_orders),latest_orderdate) >= 181 then "Inactive"
when datediff((select max(orderdate) from valid_orders),latest_orderdate) >= 91 then "At Risk"
when datediff((select max(orderdate) from valid_orders),latest_orderdate) >= 31 then "Active"
else "Recently Active"
end as Recency_Segment
from Classification);

-- call

select Recency_Segment,
Classification,
count(*) AS customer_count
from Purchase_Behavior
group by Recency_Segment, Classification
order by
case Recency_Segment
when 'Recently Active' then 1
when 'Active' then 2
when 'At Risk' then 3
when 'Inactive' then 4
end,
Classification;

