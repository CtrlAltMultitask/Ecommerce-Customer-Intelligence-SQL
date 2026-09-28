use e_commerce;

-- ============================================================
-- E-COMMERCE CUSTOMER INTELLIGENCE
-- 06. RECENCY FREQUENCY MONTARY ANALYSIS
-- ============================================================

drop view if exists Recency_Frequency_Monetary;

create View Recency_Frequency_Monetary as(
with summary as (
select p.customerid, p.Recency,
p.Total_orders, r.customer_revenue
from purchase_behavior p join
revenue_analysis r on
r.customerid=p.customerid),
RFM as (
select customerid, recency,
ntile(5) over (order by recency desc) as Recency_rate,
total_orders, 
ntile(5) over(order by total_orders ) as Frequency_Rate,
customer_revenue,
ntile(5) over(order by customer_revenue) as Monetary_Rate
from summary)
select customerid, recency,
 Recency_rate, total_orders,
 Frequency_rate, customer_revenue,
 Monetary_rate,
case 
when Recency_rate >= 4 and Frequency_rate >=4 and Monetary_rate >=4 
then 'Champions'
when Recency_rate >= 3 and Frequency_rate >= 4 and Monetary_rate >= 3
then 'Loyal Customers'
when recency_rate >= 3 and Frequency_rate between 2 and 3 and Monetary_rate >= 4
then 'High Value/Potential'
when Recency_rate >= 4 and Frequency_rate between 2 and 3 and Monetary_rate between 2 and 3
then "Potential Loyalists"
when  Recency_rate between 1 and 2 and Frequency_rate >= 3 and Monetary_rate >= 3
then "At Risk"
when  Recency_rate between 2 and 3 and Frequency_rate between 2 and 3 and Monetary_rate between 2 and 3
then "Need Attention"
when recency_rate between 1 and 2 and frequency_rate between 1 and 2 and monetary_rate between 1 and 2
then 'Low Value'
else 'Mixed Value'
end as RFM_Category
from RFM
order by customerid);   

-- call

select RFM_category,
count(customerid) as Customer_count,
round(sum(customer_revenue),2) as Total_revenue
from recency_frequency_monetary
group by RFM_category
order by Total_revenue desc;

