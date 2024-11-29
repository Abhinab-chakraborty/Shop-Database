use orders;
# Display entire data from product table
select * from product;
# Display only address id, city, pincode and state columns from address table
select ADDRESS_ID, CITY, STATE,  PINCODE from address;
# Display unique cities in the address table
select distinct(CITY) from address;
# Delete all the records from product table whose product id is 99999
delete from product where PRODUCT_ID= 99999;
# Update the price of all products in the product table to a 25% lesser values
set sql_safe_updates = 0; # safe update mode off
update product set PRODUCT_PRICE = PRODUCT_PRICE - (PRODUCT_PRICE *(25/100));
set sql_safe_updates = 1; # safe update mode on
# Display the top 10 rows from address table
select * from address limit 10;
# Display all the records from address table where state = 'NY'
select * from address where STATE = 'NY';
# Fetch the records from address table for NY, CT, and AL states
select * from address where STATE in ('NY','CT','AL');
# Fetch the record from address table where state is not null
select * from address where STATE is not null; 
# Fetch the record from address table where city name starts with letter B 
select * from address where CITY like 'B%';
# Fetch the record from the address where city name contain exactly 5 letters
select * from address where CITY like '_____';
# Fetch all the record from the product table whose price is betwwen 5000 and 10000
select * from product where PRODUCT_PRICE between 5000  and 10000;
select * from product where PRODUCT_PRICE > 5000 and PRODUCT_PRICE < 10000;
# Fetch all the price from the product table where product price is less than 1000 and quantity available is more than 100
select * from product where PRODUCT_PRICE < 1000 and PRODUCT_QUANTITY_AVAIL > 100;
# Fetch all the price from the product table where product price is less than 1000 or quantity available is less than 50
select * from product where PRODUCT_PRICE < 1000 or PRODUCT_QUANTITY_AVAIL < 50;
# Find the total numbers of records in the product table
select count(*) from product;
# Fetch sum of product price and average product price for each product class code
select PRODUCT_CLASS_CODE, sum(PRODUCT_PRICE) as Total_product_price,  avg(PRODUCT_PRICE) as Average_product_price 
from product 
group by PRODUCT_CLASS_CODE;
# select only product class that have an average price >= 4000
select PRODUCT_CLASS_CODE, sum(PRODUCT_PRICE) as Total_product_price,  avg(PRODUCT_PRICE) as Average_product_price 
from product 
group by PRODUCT_CLASS_CODE 
having  Average_product_price >= 4000;
# Fetch Total number of male and female customer
select CUSTOMER_GENDER, count(*) as customer_count 
from online_customer 
group by CUSTOMER_GENDER;
 # Display the count of unique city in the address table
 select count(distinct CITY) 
 from address;
 /* Check your inventory stock:
 - If quantity is less than or equal to 50, call it low stock
 - If quantity is greater than 50 and less than or eual to 150, claa it medium stock
 - If quantity is greater than 150, call it high stock */
 select PRODUCT_ID, PRODUCT_DESC, PRODUCT_CLASS_CODE, PRODUCT_PRICE, PRODUCT_QUANTITY_AVAIL,
	case
		when PRODUCT_QUANTITY_AVAIL <= 50 then 'LOW STOCK'
        when PRODUCT_QUANTITY_AVAIL > 50 and PRODUCT_QUANTITY_AVAIL <= 150 then 'MEDIUM STOCK'
        when PRODUCT_QUANTITY_AVAIL> 150 then 'HIGH STOCK'
	end as STOCK_Available
from product;
# Fetch all the products which falls under the electronic category 
select * 
from product as pro 
	inner join product_class as pc
		on pro.PRODUCT_CLASS_CODE = pc.PRODUCT_CLASS_CODE
	where PRODUCT_CLASS_DESC = 'ELECTRONICS';
# Query customer_ID, customer full name, order id, product quantity of customers who bought more than 10 items
select oc.CUSTOMER_ID, 
	concat(oc.CUSTOMER_FNAME, ' ', oc.CUSTOMER_LNAME) as full_name,
	oh.ORDER_ID,
	sum(oi.PRODUCT_QUANTITY) as Total_purchase
from online_customer oc
	inner join order_header oh 
		on oc.CUSTOMER_ID = oh.CUSTOMER_ID
	inner join order_items oi
		on oh.ORDER_ID = oi.ORDER_ID
group by
	oc.CUSTOMER_ID,
    oh.ORDER_ID, 
    full_name
having 
	Total_purchase >= 10;
# Fetch all the product that has not been ordered yet
select
	pro.PRODUCT_ID, pro.PRODUCT_DESC, pro.PRODUCT_PRICE, 
    oi.PRODUCT_QUANTITY 
from product pro
	left join order_items oi 
    on pro.PRODUCT_ID = oi.PRODUCT_ID
where oi.PRODUCT_QUANTITY is null; 
# OR
select
	PRODUCT_ID, PRODUCT_DESC, PRODUCT_PRICE, 
    oi.PRODUCT_QUANTITY 
from product 
	left join order_items oi using(PRODUCT_ID)
where oi.PRODUCT_QUANTITY is null; 
# Fetch all the product caregory description whose agerage price is greater than 5000
select 
	pc.PRODUCT_CLASS_CODE, pc.PRODUCT_CLASS_DESC,
    avg(pro.PRODUCT_PRICE) as AVG_product_price
from product_class pc
left join product pro
	on pc.PRODUCT_CLASS_CODE = pro.PRODUCT_CLASS_CODE
group by PRODUCT_CLASS_CODE
	having AVG_product_price > 5000; 
# OR
select 
	pro.PRODUCT_CLASS_CODE, pc.PRODUCT_CLASS_DESC, avg(pro.PRODUCT_PRICE) as AVG_product_price
from product pro
inner join product_class pc using (PRODUCT_CLASS_CODE)
group by
	PRODUCT_CLASS_CODE
having
	AVG_product_price > 5000; 
#Fetch all the columns and rows from oeder header and order items
select *
from order_header oh 
left join order_items oi using (ORDER_ID)
union
select *
from order_header oh 
right join order_items oi using (ORDER_ID);