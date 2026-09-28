use e_commerce;

-- ============================================================
-- E-COMMERCE CUSTOMER INTELLIGENCE & REVENUE ANALYTICS
-- 01 - DATA QUALITY AUDIT
-- ============================================================
-- Purpose:
-- Identify duplicates, missing values, invalid values,
-- referential-integrity issues, and date-quality problems
-- before performing business analysis.
-- ============================================================

-- ============================================================
-- 1. TABLE ROW COUNTS
-- ============================================================

select "Customers" as Table_name, count(*) as Row_count 
From customers -- Row_count : 9820
union all
select "Orders" As Table_name, count(*) as Row_count
from orders -- Row_count : 49819
union all 
select "Payments" as Table_name, count(*) as Row_Count
from Payments -- Row_count : 50000
union all 
select "Products" as Table_name, count(*) as Row_count
from products; -- Row_count : 20

-- ============================================================
-- 2. DUPLICATE ORDER IDs
-- ============================================================

select orderid,count(*) as Number_of_rows  from orders 
group by orderid 
having count(*) >1
order by Number_of_rows desc;

-- ============================================================
-- 3. NULL VALUE CHECK
-- ============================================================

select
sum(case when orderdate is null then 1 else 0 end)
as missing_orderdate,
sum(case when orderid is null then 1 else 0 end)
as Missing_orderid,
sum(case when customerid is null then 1 else 0 end)
as missing_customerid,
sum(case when productid is null then 1 else 0 end)
as missing_product,
sum(case when status is null then 1 else 0 end)
as missing_status,
sum(case when paymentmethod is null then 1 else 0 end)
as missing_paymentmethod,
sum(case when quantity is null then 1 else 0 end)
as missing_quantity,
sum(case when discount is null then 1 else 0 end)
as missing_discount
from orders;

-- ============================================================
-- 4. INVALID QUANTITY CHECK
-- ============================================================

select status,
case
when quantity < 0 then 'Negative'
when quantity = 0 then 'Zero'
end as quantity_issue,
count(*) as row_count
from orders
where quantity <= 0
group by status,
quantity_issue
order by quantity_issue, status;

-- ============================================================
-- 5. INVALID DISCOUNT CHECK
-- ============================================================

select
count(*) AS invalid_discount_rows,
min(discount) AS minimum_discount,
max(discount) AS maximum_discount
from orders
where discount < 0
or discount > 1;

-- ============================================================
-- 6. INVALID PRODUCT PRICE CHECK
-- ============================================================

select 
count(*) as invalid_price_rows,
min(unitprice) as minimum_price,
max(unitprice) as maximum_price
from products
where unitprice<=0;

-- ============================================================
-- 7. CUSTOMER REFERENTIAL INTEGRITY
-- ============================================================

select 
count(distinct o.customerid) as invalid_customer_id,
count(*) as invalid_order_rows
from orders o 
left join customers c 
on o.customerid=c.customerid
where c.customerid is null;

-- ============================================================
-- 8. PRODUCT REFERENTIAL INTEGRITY
-- ============================================================

select 
count(distinct o.productid) as Invalid_productid,
count(*) as affected_order_rows
from orders o
left join products p
on o.productid=p.productid
where p.productid is null;

-- ============================================================
-- 9. ORDER DATE QUALITY
-- ============================================================

-- Check the data type of orderdate
show columns from orders like 'orderdate';

-- Check blank order dates

select orderdate, count(*) as row_count
from orders
where STR_TO_DATE(orderdate, '%Y-%m-%d') is null
group by orderdate
order by row_count DESC;

-- Check for invalid non-empty date values

select orderdate,
count(*) AS row_count
from orders
where trim(orderdate) <> ''
and STR_TO_DATE(orderdate, '%Y-%m-%d') is null
group by orderdate;

-- Valid order date range

select
min(str_to_date(nullif(trim(orderdate), ''), '%Y-%m-%d'))
as first_order_date,
max(str_to_date(nullif(trim(orderdate), ''), '%Y-%m-%d'))
as last_order_date,
sum(trim(orderdate) = '') as blank_order_dates
from orders;

-- ============================================================
-- 10. EXACT DUPLICATE TRANSACTION RECORDS
-- ============================================================

select
count(*) as duplicate_groups,
sum(duplicate_count - 1) as excess_duplicate_rows
from (
select orderid, customerid,
orderdate, productid,
quantity, discount,
paymentmethod, status,
count(*) as duplicate_count
from orders
group by orderid,
customerid, orderdate,
productid, quantity,
discount, paymentmethod,
status
having count(*) > 1
) x;

-- Audit Summary

select
(select count(*) from customers) as Customers,
(select count(*) from orders) as Orders,
(select count(*) from products) as Products,
(select count(*) from payments) as Payments,

(select count(*) from (
select orderid from orders 
group by orderid
having count(*) > 1) x)
as duplicate_order_groups,

(select count(*) from orders
where quantity <= 0) as invalid_quantity_rows,

(select count(distinct o.customerid)
from orders o 
left join customers c 
on o.customerid=c.customerid
where c.customerid is null)
as invalid_customerids,

(select count(*) from orders
where trim(orderdate) = '') as 
blank_orderdates;
