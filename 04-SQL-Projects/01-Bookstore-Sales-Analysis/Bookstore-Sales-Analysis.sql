drop table if exists books;
create table books
(
Book_ID		int 	primary key,
Title		varchar(100),	
Author		varchar(100),	
Genre		varchar(50),	
Published_Year	int,	
Price		float,	
Stock		int 	
);

select * from books;

drop table if exists customer;
create table customers
(
Customer_ID	int	primary key,
Name	varchar(100),	
Email	varchar(100),	
Phone	varchar(100),
City	varchar(100),	
Country	varchar(150)	
);

select * from customers;

drop table if exists Orders;
create table Orders
(
Order_ID	int,
Customer_ID	int,
Book_ID	int,
Order_Date	date,
Quantity	int,
Total_Amount float
);

select * from Orders;

-- 1) RETRIEVE ALL BOOKS IN THE "FICTION" GENRE:

	  SELECT * FROM books
	  where genre ='Fiction';


-- 2) FIND BOOKS PUBLISHED AFTER THE YEAR 1950:

	   select * from books
	   where published_year>1950;
	  

-- 3) LIST ALL CUSTOMERS FROM THE CANADA:

	  select * from customers
	   where country='Canada';
	  

-- 4) SHOW ORDERS PLACED IN NOVEMBER 2023:

	   select * from Orders
	   where to_char(order_date,'yyyy-mm')='2023-11';
	   
-- 5) RETRIEVE THE TOTAL STOCK OF BOOKS AVAILABLE:

	   select sum(stock) TOTAL_STOCKS from books;
	   

-- 6) FIND THE DETAILS OF THE MOST EXPENSIVE BOOK:

	 SELECT * FROM books 
      ORDER BY price DESC 
       LIMIT 1;

-- 7) SHOW ALL CUSTOMERS WHO ORDERED MORE THAN 1 QUANTITY OF A BOOK:

	   select c.*
	   from customers c join Orders o on c.customer_id=o.customer_id
	   where quantity>1;

-- 8) RETRIEVE ALL ORDERS WHERE THE TOTAL AMOUNT EXCEEDS $20:

       select * from Orders;
	   
	   select * from Orders
	   where total_amount>20;

-- 9) LIST ALL GENRES AVAILABLE IN THE BOOKS TABLE:

       select distinct genre from books;

-- 10) FIND THE BOOK WITH THE LOWEST STOCK:

        SELECT * FROM books 
       order by stock asc 
       limit 1;
	   
-- 11) Calculate the total revenue generated from all orders:

        select sum(total_amount) total_revenue from Orders;

-- ADVANCE QUESTIONS : 

-- 1) RETRIEVE THE TOTAL NUMBER OF BOOKS SOLD FOR EACH GENRE:

       select genre,sum(quantity) total_no_books
	   from books b join Orders o on b.book_id=o.book_id
	   group by genre;


-- 2) FIND THE AVERAGE PRICE OF BOOKS IN THE "FANTASY" GENRE:

       select genre,avg(price)
	   from books
	   group by genre
       having genre='Fantasy';
	   
-- 3) LIST CUSTOMERS WHO HAVE PLACED AT LEAST 2 ORDERS:

	  select o.customer_id, c.name, count(o.order_id) order_count
     from Orders o join customers c on o.customer_id=c.customer_id
      group by o.customer_id, c.name
       having count(order_id) >=2;

        
-- 4) FIND THE MOST FREQUENTLY ORDERED BOOK:

	  select * from Orders;
	  select * from books;
	  
      select o.book_id,title, count(order_id) order_count
	  from books b join Orders o on b.book_id=o.book_id
	  group by o.book_id,title
	  order by order_count desc
	  limit 1;
	  
-- 5) SHOW THE TOP 3 MOST EXPENSIVE BOOKS OF 'FANTASY' GENRE :
       
	   select * 
	   from books
	   where genre='Fantasy'
	   order by price desc
	   limit 3;

-- 6) RETRIEVE THE TOTAL QUANTITY OF BOOKS SOLD BY EACH AUTHOR:

       select author ,sum(quantity) total_quantity
	   from books b join Orders o on b.book_id=o.book_id
	   group by author;

-- 7) LIST THE CITIES WHERE CUSTOMERS WHO SPENT OVER $30 ARE LOCATED:

		select * from customers;
		
        select c.customer_id,city
		from customers c join Orders o on c.customer_id=o.customer_id
		group by c.customer_id, city
	    having sum(total_amount)>30;

-- 8) FIND THE CUSTOMER WHO SPENT THE MOST ON ORDERS:

	   select c.customer_id , sum(total_amount) total_spent
        from customers c join Orders o on c.customer_id=o.customer_id
		group by c.customer_id
		order by total_spent desc
		limit 1;

--9) CALCULATE THE STOCK REMAINING AFTER FULFILLING ALL ORDERS:

      select b.book_id,title,stock-coalesce(sum(quantity),0) stock_remaining
	  from books b join Orders o on b.book_id=o.book_id
	  group by b.book_id,title;



