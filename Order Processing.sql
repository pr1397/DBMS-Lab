create database customers;
use customers;

create table if not exists customer(
cust int primary key,
cname char(20),
city varchar(20)
);

create table if not exists orders(
id int primary key,
odate date,
cust int,
order_amt int
);

create table if not exists items(
item int primary key,
unitprice int
);

create table if not exists order_item(
id int,
item int,
qty int,
foreign key (id) references orders(id),
foreign key (item) references items(item)
);

create table if not exists warehouse(
warehouseid int primary key,
city varchar(20)
);

create table if not exists shipment(
id int,
warehouseid int,
ship_date date,
foreign key (id) references orders(id),
foreign key (warehouseid) references warehouse(warehouseid)
);

insert into customer values
(101,'James','Surat'),
(102,'Dean','Ranchi'),
(103,'Jess','Amritsar'),
(104,'Kumar','Surat'),
(105,'Nick','Amritsar');

insert into orders values
(1,'2021-09-29',101,200),
(2,'2020-11-02',102,1100),
(3,'2019-12-17',103,4300),
(4,'2022-01-10',104,90),
(5,'2022-04-11',15,8000);

insert into items values
(123,20),
(234,100),
(345,430),
(456,45),
(567,8000);

insert into order_item values
(1,123,10),
(2,234,11),
(3,345,10),
(4,456,2),
(5,567,1);

insert into warehouse values
(111,'Jaipur'),
(222,'Banglore'),
(333,'Chennai'),
(444,'Hyderabad'),
(555,'Kolkata');

insert into shipment values
(1,222,'2021-10-10'),
(2,555,'2020-11-10'),
(3,222,'2019-12-20'),
(4,111,'2022-01-15'),
(5,333,'2022-04-22');
-- List the Order# and Ship_date for all orders shipped from Warehouse# "W2".
select id,ship_date from shipment where warehouseid=222;

-- List the Warehouse information from which the Customer named "Kumar" was supplied 
-- his orders. Produce a listing of Order#, Warehouse#
select id, warehouseid from warehouse natural join shipment where id = (select id from orders where cust =(Select cust from customer where cname like "%Kumar%"));

-- Delete all orders for customer named "Kumar".
delete from orders where cust = (select cust from customer where cname like "%Kumar%");

-- Find the item with the maximum unit price.
select max(unitprice) from items;

-- Create a view to display orderID and shipment date of all orders shipped from a 
-- warehouse 2.
create view orshipment as select * from orders natural join shipment where warehouseid=222;
select * from orshipment;

-- Produce a listing: Cname, #ofOrders, Avg_Order_Amt, where the middle column is the 
-- total number of orders by the customer and the last column is the average order 
-- amount for that customer. (Use aggregate functions)

select customer.cname, count(distinct orders.id), avg(orders.order_amt) from customer join orders where customer.cust = orders.cust group by orders.id;

DELIMITER $$
CREATE TRIGGER PWDS
	BEFORE DELETE ON Warehouse
    FOR EACH ROW
    BEGIN 
		IF OLD.warehouseid IN (SELECT warehouseid FROM Shipment NATURAL JOIN Warehouse)
			THEN
					SIGNAL SQLSTATE '45000'
					SET MESSAGE_TEXT = 'An item is shipped from this warehouse....!';
		END IF;
	END;
$$
DELIMITER ;

DELETE FROM Warehouse WHERE warehouseid = 222;
