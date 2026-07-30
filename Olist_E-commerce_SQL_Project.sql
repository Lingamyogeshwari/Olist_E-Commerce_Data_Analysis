#Olist E-Commerce Store Analysis

#KPI 1 : Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics


-- finding  weekend/weekday 
select distinct order_id, 
CASE 
WHEN dayname (order_purchase_timestamp) in ("Saturday","Sunday")
THEN "Weekend"
ELSE "Weekday"
END as  Day_Type
FROM olist_orders_dataset;

-- Joining with Payments_table

Select O.day_type, sum(P.payment_value) as Total_Payment
from olist_order_payments_dataset as P
join (select distinct order_id, 
CASE 
      WHEN dayname (order_purchase_timestamp) in ("Saturday","Sunday")
      THEN "Weekend"
      ELSE "Weekday"
      END as  Day_Type
FROM olist_orders_dataset) as O
On P.order_id = O.order_id
group by O.day_type;


-- Finding %

Select O.day_type,
Concat(round((sum(P.payment_value)/(select sum(payment_value) from olist_order_payments_dataset))*100,2), "% " ) as Payment_percentage
from olist_order_payments_dataset as P
join (select distinct order_id, 
CASE 
      WHEN dayname (order_purchase_timestamp) in ("Saturday","Sunday")
      THEN "Weekend"
      ELSE "Weekday"
      END as  Day_Type
FROM olist_orders_dataset) as O
On P.order_id = O.order_id
group by O.day_type;







#KPI 2

-- Number of Orders with review score 5 and payment type as credit card.

select count(distinct R.order_ID) as Total_orders, P.Payment_type, R. Review_score
from olist_order_reviews_dataset as R
join olist_order_payments_dataset as P
on R.order_id= P.order_id
where R.review_score= 5
and P.payment_type = "Credit_card";


#KPI 3

-- Average no. of days taken for order_delivered_customer_date for pet_shop

select round(avg(datediff(order_delivered_customer_date,order_purchase_timestamp)),2)
as Avg_Delivery_Days, product_category_name
from (
select distinct O.order_id, O.order_purchase_timestamp, O.order_delivered_customer_date,P.product_category_name
from olist_orders_dataset as O
join olist_order_items_dataset as I
on o.order_id= I.order_id
join olist_products_dataset as P
on I.product_id=P.product_id
where P.product_category_name= "Pet_shop") as X
GROUP BY product_category_name;



#KPI 4

-- Average price and payment values from customers of sao paulo city

Select 
(
select round(avg(price))
from olist_customer_dataset as C
join olist_orders_dataset as O
on C.Customer_id=o.customer_id
join olist_order_items_dataset as I
on I.order_id= O.order_id
where customer_city="sao paulo") as Avg_price,
(
select round(avg(payment_value))
from olist_customer_dataset as C
join olist_orders_dataset as O
on C.Customer_id=o.customer_id
join olist_order_payments_dataset as P
on p.order_id= o.order_id
where customer_city="sao paulo") as Avg_payment;


#KPI 5

-- Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.


Select R.Review_score,
round(avg(datediff(order_delivered_customer_date,order_purchase_timestamp)),2) as Avg_Shipping_Days
from olist_order_reviews_dataset as R
join olist_orders_dataset as O
on O.order_id= r.order_id
group by review_score
order by review_score;







