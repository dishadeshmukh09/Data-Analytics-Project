select *  from df_orders
alter table df_orders
alter column [order_id] int not null;
alter table df_orders
alter column[order_date] date null;

alter table df_orders
alter column[ship_mode] varchar(20) null

alter table df_orders
alter column[segment] varchar(20) null

alter table df_orders
alter column[city]varchar(20) null

alter table df_orders
alter column [state]varchar(20)
alter table df_orders
alter column [postal_code] varchar(20) null
alter table df_orders
alter column [region] varchar(20) null
alter table df_orders
alter column [sub_category] varchar(20) null
alter table df_orders
alter column [product_id] varchar(50) null
alter table df_orders
alter column [quantity] int  null
alter table df_orders
alter column [discount] decimal(7,2)  null
alter table df_orders
alter column [sale_price]decimal(7,2)  null
alter table df_orders
alter column [profit]decimal(7,2)  null

--find top 10 highest revenue generating products 
select top 10 product_id,sum(sale_price) as sales
from df_orders
group by product_id
order by sales desc

select region, product_id,sum(sale_price) as sales
from df_orders
group by region,product_id
order by region,sales desc



--find top 5 highest selling products in each region
--select distinct region from df_orders
with cte as (
select region,product_id,sum(sale_price) as sales
from df_orders
group by region,product_id)
select * from (
select *
, row_number() over(partition by region order by sales desc) as rn
from cte) A
where rn<=5


select distinct year(order_date)from df_orders
--find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023
with cte as (
select year(order_date) as order_year,month(order_date) as order_month,
sum(sale_price) as sales
from df_orders
group by year(order_date),month(order_date)
--order by year(order_date),month(order_date)
	)
select order_month
, sum(case when order_year=2022 then sales else 0 end) as sales_2022
, sum(case when order_year=2023 then sales else 0 end) as sales_2023
from cte 
group by order_month
order by order_month


--for each category which month had highest sales 
with cte as (
select category,format(order_date,'yyyyMM') as order_year_month
, sum(sale_price) as sales 
from df_orders
group by category,format(order_date,'yyyyMM')
--order by category,format(order_date,'yyyyMM')
)
select * from (
select *,
row_number() over(partition by category order by sales desc) as rn
from cte
) a
where rn=1


--which sub category had highest growth by profit in 2023 compare to 2022
with cte as (
select sub_category,year(order_date) as order_year,
sum(sale_price) as sales
from df_orders
group by sub_category,year(order_date)
--order by year(order_date),month(order_date)
	)
, cte2 as (
select sub_category
, sum(case when order_year=2022 then sales else 0 end) as sales_2022
, sum(case when order_year=2023 then sales else 0 end) as sales_2023
from cte 
group by sub_category
)
select top 1 *
,(sales_2023-sales_2022)
from  cte2
order by (sales_2023-sales_2022) desc
