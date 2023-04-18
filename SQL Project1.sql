
drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 


INSERT INTO goldusers_signup(userid,gold_signup_date) 
 VALUES (1,'2017-09-22'),         
(3,'2017-04-21');

drop table if exists users;
CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES (1,'2014-02-09'),
(2,'2015-01-03'),
(3,'2014-11-04');

drop table if exists sales;
CREATE TABLE sales(userid integer,created_date date,product_id integer); 
 
 
INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'2017-06-02',2),
(3,'2019-12-18',1),
(2,'2020-07-20',3),
(1,'2019-10-23',2),
(1,'2018-03-19',3),
(3,'2016-12-20',2),
(1,'2016-11-09',1),
(1,'2016-05-20',3),
(2,'2017-09-24',1),
(1,'2017-03-11',2),
(1,'2016-03-11',1),
(3,'2016-11-10',1),
(3,'2017-12-07',2),
(3,'2016-12-15',2),
(2,'2017-11-08',2),
(2,'2018-09-10',3);


drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);

select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;

 1Q: What is the total amount each customer spent on zomato?
 select s.userid, sum(p.price) as total_amnt_spent from sales s
 inner join product p on s.product_id=p.product_id
 group by s.userid
 
 2Q: How many days has each customer visited zomato
 select userid, count(distinct created_date) as days_visited from sales
 group by userid
 
 3Q: What was the first product purchased by each customer?
 select * from
 (select *, rank() over(partition by userid order by created_date) as rnk from sales) s where rnk=1

  4Q: What is the most purchased item on the menu and how many times was it purchased by all customers?
  select userid,p.product_name,count(*) as most_purchased, s.userid from product p 
  inner join sales s on p.product_id=s.product_id
  group by product_name
    
  5Q: Which item was the most popular for each customer
  
  select * from
  (select *, rank() over(partition by userid order by cnt desc) as rnk from
  (select userid,product_id,count(product_id) as cnt from sales  group by userid,product_id)a)b
  where rnk=1
 
6Q: Which item was purchased first by the customer after they became a member
select * from 
(select c. *, rank() over(partition by userid order by created_date) as rnk from
(select s.userid,s.product_id, s.created_date, g.gold_signup_date from sales s
inner join goldusers_signup g on s.userid=g.userid and 
created_date>=gold_signup_date) c)d where rnk=1

7Q: What item was purchased just before the customer became a member

select * from 
(select c. *, rank() over(partition by userid order by created_date desc) as rnk from
(select s.userid,s.product_id, s.created_date, g.gold_signup_date from sales s
inner join goldusers_signup g on s.userid=g.userid and 
created_date<=gold_signup_date) c)d where rnk=1

8Q: What is the total orders and amount spent for each member before they became a member?

select s.userid,s.product_id,count(s.created_date) as orders_purchased, sum(p.price) as total_amnt_spent,g.gold_signup_date
from sales s inner join goldusers_signup g on s.userid=g.userid
inner join product p on s.product_id=p.product_id and 
created_date<=gold_signup_date 
group by userid







