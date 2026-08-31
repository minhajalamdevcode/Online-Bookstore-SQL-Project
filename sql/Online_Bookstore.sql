CREATE DATABASE Online_Bookstore;
DROP TABLE IF EXISTS Books;
CREATE TABLE IF NOT EXISTS Books(
Book_ID INT PRIMARY KEY,
Title VARCHAR(100),
Author VARCHAR(70),
Genre VARCHAR(40),
Published_Year INTEGER,
Price NUMERIC(10,2),
Stock INT
);
SELECT * FROM Books;
SET DATESTYLE=ISO,DMY;
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
FROM'E:\Books.csv'
DELIMITER','
CSV HEADER;

DROP TABLE IF EXISTS Customers;
CREATE TABLE IF NOT EXISTS Customers(
Customer_ID INT PRIMARY KEY,
Name VARCHAR(80),
Email VARCHAR(90),
Phone BIGINT,
City VARCHAR(90),
Country VARCHAR(90)
);
SELECT * FROM Customers;
COPY
Customers(Customer_ID, Name, Email, Phone, City, Country)
FROM'E:\Customers.csv'
DELIMITER','
CSV HEADER;
DROP TABLE IF EXISTS Orders;
CREATE TABLE IF NOT EXISTS Orders(
Order_ID INT PRIMARY KEY,
Customer_ID INT REFERENCES Customers(Customer_ID),
Book_ID INT REFERENCES Books(Book_ID),
Order_Date DATE,
Quantity INT,
Total_Amount NUMERIC(10,2)
);
SELECT * FROM Orders;
COPY
Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM'E:\Orders.csv'
DELIMITER','
CSV HEADER;
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 1) Retrieve all books in the 'fiction' genere:
SELECT * FROM Books
 WHERE genre LIKE'Fiction%';

 -- 2) Find books published after the year 1950:
 SELECT * FROM Books
 WHERE Published_year>1950;

-- 3)List all customers from the canada:
SELECT * FROM Customers
WHERE country Like'Canada%';

-- 4)show orders placed in november 2023:
SELECT * FROM Orders
WHERE order_date>'2023-11-01' AND order_date<='2023-11-30';

-- 5)Retrives the total stock of books available:

SELECT  SUM(stock) AS total_stock FROM Books;

-- 6) find the details of most expensive book:
SELECT * FROM Books 
ORDER BY price desc
limit 1;
-- 7) show all customers who ordered more than 1 quantity of a book
SELECT * FROM  Orders
WHERE Quantity>1;

-- 8)Retrieve all orders where the total amount exceeds $20
SELECT * FROM Orders
WHERE total_amount>20;
-- 9)list all genres available in the books table:
SELECT  DISTINCT genre AS available FROM Books;

-- 10 FIND the book with the lowest stock:

   SELECT * FROM Books 
   ORDER BY Stock;
 -- 11) calculate the total revenue generated from all orders;  
 SELECT SUM(total_amount) AS total_revenue FROM Orders;

-- ADVANCE QUESTION
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 1)Retrieve the total number of books sold for each genre;
SELECT b.genre,SUM(o.quantity) AS Total_number_of_books_Sold FROM Books AS b
INNER JOIN Orders AS o
ON b.book_id=o.order_id
GROUP BY b.genre;

-- 2) find the average price of books in the 'Fantasy' genre;

SELECT genre,ROUND(AVG(Price)::NUMERIC,2) AS Average_price FROM Books
WHERE genre='Fantasy'
GROUP BY genre;


SELECT ROUND(AVG(Price)::NUMERIC,2) AS Average_price FROM Books
WHERE genre='Fantasy'

-- 3 LIST CUSTOMERS WHO have placed at least 2 orders;

SELECT o.Customer_ID, c.name,o.quantity FROM Customers AS c
JOIN  Orders AS o 
ON c.Customer_ID=o.Order_ID
WHERE quantity>2;

SELECT customer_id,count(order_id) from Orders
GROUP BY customer_id
HAVING count(order_id)>2;
-- 4 find the most frequently ordered book
select o.book_id,b.title,count(o.order_id) as order_count from orders  o
inner join Books b on o.book_id=b.book_id
GROUP BY o.book_id,b.title
ORDER BY order_count DESC
LIMIT 1;

-- 5 show the top 3 most expensive book of 'fantasy genre'
SELECT * from Books
WHERE genre='Fantasy'
order by price desc
limit 3;

-- 6 retrieve the total quantity of books sold by each author
SELECT b.author,sum(o.quantity) as total_book_sold FROM Books as b
inner join Orders as o
on b.book_id=o.book_id
GROUP BY b.author;

-- 7 list the cities where customers who spent over $38 are located
    SELECT  DISTINCT c.city,o.total_amount From Customers as c
	join Orders AS o 
	ON c.customer_id=o.customer_id
	WHERE o.total_amount>38;

	-- 8 find the customer who spent the most on orders


SELECT c.name,c.Customer_ID ,sum(O.total_amount) AS TOTAL from customerS as c
join Orders as o
ON C.customer_id=o.customer_id
GROUP BY C.name,c.Customer_ID
ORDER BY TOTAL DESC LIMIT 1;

-- 9 calculate the stock remaining after fulfilling all orders;
 select b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0)AS order_quantity,
 b.stock- COALESCE(SUM(o.quantity),0) AS remaining_quantity
 from Books as b 
 LEFT join Orders as o
 on b.book_id=o.book_id
 GROUP BY b.book_id
 ORDER BY b.book_id;


		