-- 1) SELECT clause. // Return all products, name, unit_price, New price(unit_price*1.1) --
SELECT name, 
      unit_price,
      unit_price*1.1 AS new_price
FROM products;


-- 2)WHERE Clause //Gets order place this year 2019 --
SELECT * FROM orders
WHERE orders_date >= '2019-01-01' ;


-- 3)AND operator. // From order_items table, Get items for order #6 and where total price>30--
SELECT * FROM order_items
WHERE order_id=6 AND unit_price*quantity>30 ;


-- 4)IN operator. //Return products with quantity in stocks equal to one of the 49,38,72--
SELECT * FROM products
WHERE quantity_in_stock IN (49,38,72);


-- 5) BETWEEN operator. //Return customer born between 1990 and 2000--
SELECT* FROM customers
WHERE birth_date BETWEEN '1990-01-01' AND '2000-01-01' ;


-- 6)LIKE Operator--
-- Get customers whose address contains TRIAL or AVENUE--
-- Phone number ends with 9--
SELECT * FROM customers
WHERE address LIKE '%TRAIL%' OR
      address LIKE '%AVENUE%' ;

SELECT * FROM customers
WHERE phone LIKE '%9' ;


-- 7)REGEXP operator. //Get customers whose --
-- First name are ELKA or AMBUR--
-- Last name end with EY or ON--
-- Last name starts with MY or contain SE-
-- Last name contain B followed by R or U-
SELECT * FROM customers
WHERE first_name REGEXP 'elka|ambur' ;

SELECT * FROM customers
WHERE last_name REGEXP 'ey$|on$' ;

SELECT * FROM customers
WHERE last_name REGEXP '^my|se' ;

SELECT * FROM customers
WHERE last_name REGEXP 'b[ru];


-- 8) IS NULL operator. // Get orders that are NOT shipped--
SELECT * FROM orders
WHERE shipper_id IS NULL;


-- 9)ORDER BY Operator. //Select all items with id =2 and Sort them by Total price in descending order --
SELECT * FROM order_items
WHERE order_id = 2
ORDER BY quantity*unit_price DESC;


-- 10) LIMIT operator. //Get the top Three loyal customers--
SELECT * FROM customers
ORDER BY points DESC
LIMIT 3;


-- 11) INNER JOIN. //Join order table with Product table giving columns of product_id and Product name for each order_id followed quantity & unit_price--
SELECT order_id,
      oi.product_id,
      quantity,
      oi.unit_price
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id ;


-- 12) Joining across Databases.--
-- Join payment with payment_methods as well as Client_id table --
-- produce a Report that shows the Payment, with more details such as the Name of clients & payment method--
USE sql_invoicing;
SELECT p.date,
       p.invoice_id,
       p.amount,
       c.name,
       pm.name
FROM payments p
JOIN clients c
     ON p.client_id = c.client_id
JOIN payment_methods pm
     ON p.payment_method = pm.payment_method_id ;


-- 13) OUTER joins.  //Join products with order_items, giving product_id, Name & Quantity--
SELECT p.product_id,
       p.name,
       oi.quantity
FROM products p
LEFT JOIN order_items oi
         ON p.product_id = oi.product_id;


-- 14) Outer Join between Multiple tables--
-- Write a Query to get order_date, order_id, first_name, shipper(including null values) & Status--
SELECT o.order_id,
       o.order_date,
       c first_name AS customer,
       sh.name AS shipper,
       os.name AS status
FROM orders o
JOIN customsrs c
    ON o.customer_id = c.customer_id
LEFT JOIN shippers sh
    ON o.shipper_id = sh.shipper_id
JOIN order_statuses os
    ON o.status = os.order_status_id;


-- 15) USING clause.  //Find out, on What date, Who has paid, How much amount through, Which payment method?--
USE sql_invoicing;
SELECT p.date
       c.name AS client,
       p.amount,
       pm.name AS payment_method
FROM payment p
JOIN clients c 
     USING (client_id)
JOIN payment_methods pm
     ON p.payment_method = pm.payment_method_id ;


-- 16) CROSS joins. //Do a cross join between Shippers & Products, using implicit Syntax, Then using Explicit syntax--
SELECT sh.name AS shipper,
       p.name AS product
FROM shippers sh, products p
ORDER BY sh.name;

SELECT sh.name AS shipper,
       p.name AS product
FROM shippers sh
CROSS JOIN products p
ORDER BY sh.name;


-- 17) UNIONS.  // Selecting customer_id, first_name & points. Then create another Column named "Type" such that--
-- if customers points< 2000 then call him "Bronze"--
-- if points> 2000 then call him "Silver"--
-- if points> 3000 then call him "Gold"--
SELECT customer_id,
       first_name,
       points,
       'Bronze' AS type
FROM customers
WHERE points <2000 
UNION
SELECT customer_id,
       first_name,
       points,
       'Silver' AS type
FROM customers
WHERE points BETWEEN 2000 AND 3000
UNION
SELECT customer_id,
       first_name,
       points,
       'Goldl' AS type
FROM customers
WHERE points >3000 ;


-- 18) Inserting Multiple Rows.  //Insert three rows in product table--
INSERT INTO products (name, quantity_in_stock, unit_price)
VALUES ('Product1', 10, 1.95)
       ('Product2', 11, 1.96)
       ('Product3', 12, 1.97);


-- 19) Creating a Copy of a Table--
-- Copy invoice table into New table invoice_archived in which we need client_name column instead of client_id--
-- Only copy invoice who do have payment --
USE sql_invoicing;
CREATE TABLE invoice_archived AS
SELECT i.invoice_id,
       i.number,
       c.name AS client,
       i.payment_total,
       i.invoice_date,
       i.payment_date,
       i.due_date
FROM invoice i
JOIN clients c
     USING(client_id)
WHERE payment_date IS NOT NULL;


-- 20) Updating Multiple Rows.  // Write a SQL statement to give any Customers born before 1990, the 50 extra points--
USE sql_store;
UPDATE customers
SET points= points + 50
WHERE birth_date < '1990-01-01' ;


-- 21) Using Subqueries in Updates--
-- Update "comments" column of Orders table in sql_store database--
-- such that Customers having greater than 3000 points regard them as "Gold-customers" --
-- find their orders if they have placed an order--
USE sql_store;
UPDATE orders
SET comments= 'Gold customer'
WHERE customer_id IN
      (SELECT customer_id FROM customers WHERE points> 3000);