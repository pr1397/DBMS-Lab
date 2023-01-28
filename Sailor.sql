create database sailors;
use sailors;
drop table sailor;
drop table boat;
drop table rservers;
create table sailor(
sid int,
sname varchar(30),
rating int,
age int
);

create table boat(
bid int,
bname varchar(20),
color char(10)
);

create table if not exists rservers(
sid int,
bid int,
dates date
);

alter table sailor add constraint primary key PK (sid);
alter table boat add constraint primary key PK1 (bid);
alter table rservers add constraint FK foreign key (sid) references sailor(sid) on delete cascade;
alter table rservers add constraint FK1 foreign key (bid) references boat(bid) on delete cascade;

alter table rservers drop constraint FK;
alter table rservers drop constraint FK1;

insert into sailor values 
(1,'Ram',5,20),
(2,'Sham',3,22),
(3,'Tam',1,26),
(4,'Cam',4,32),
(5,'Liam',5,25);

insert into boat values
(101,'Bill','Red'),
(102,'Will','Blue'),
(103,'Jill','Green'),
(104,'Sill','White'),
(111,'Till','Yellow');

insert into rservers values 
(1,103,'2020-09-08'),
(2,104,'2021-02-18'),
(5,102,'2022-07-30'),
(3,101,'2020-02-28'),
(4,111,'2019-12-12');

show tables;
select * from sailor;
select * from boat;
select * from rservers;

alter table sailor modify rating integer not NULL;   
alter table boat add column capacity integer default 3;

delete from sailor where sid = 3;
update boat set color='Purple' where bid = 111;
select * from sailor where sname like "%am" order by rating desc;

select sailor.sid, sailor.sname, rservers.bid from sailor inner join rservers on sailor.sid = rservers.sid; 

select * from sailor where rating >=(select avg(rating) from sailor);

create view newv as select sailor.sname, boat.bname, rservers.dates from sailor natural join rservers natural join boat;
select * from newv;

insert into sailor values
(7,'Albert',4,21);

insert into rservers values 
(7,103,'2022-10-05'),
(7,111,'2020-01-22');

select boat.color from boat natural join rservers natural join sailor where sname like "%Albert%";

insert into sailor values
(10,'Charles',10,21),
(8,'James',7,23),
(9,'Harry',9,24),
(6,'Daniel',8,21);


-- 1. Find the colours of boats reserved by Albert
select boat.color from boat, sailor, rservers where boat.bid = rservers.bid and rservers.sid = sailor.sid and sailor.sname="Albert";
-- 2. Find all sailor id’s of sailors who have a rating of at least 8 or reserved boat 103
select sid from sailor where rating >= 8 union select sid from rservers where bid = 103 order by sid;
-- 3. Find the names of sailors who have not reserved a boat whose name contains the string 
-- “storm”. Order the names in ascending order.
select sid from sailor where sid not in (select sid from rservers) and sname like '%storm%' order by sname;
-- 4. Find the names of sailors who have reserved all boats.
select sname from sailor, rservers where sailor.sid = rservers.sid;
-- 5. Find the name and age of the oldest sailor.
select sname, age from sailor where age = (select max(age) from sailor);
-- 6. For each boat which was reserved by at least 5 sailors with age >= 40, find the boat id and 
-- the average age of such sailors.
select boat.bid, avg(sailor.age) from boat,rservers,sailor where sailor.sid = rservers.sid and boat.bid = rservers.bid and age >= 20 group by boat.bid having count(rservers.bid) >= 2;
-- 7. A view that shows names and ratings of all sailors sorted by rating in descending order.
create view sailor_view as select sname, rating from sailor order by rating desc;
select * from sailor_view;
-- 8. A trigger that prevents boats from being deleted If they have active reservations.
DELIMITER $$
CREATE TRIGGER ARB
	BEFORE DELETE ON Boat
    FOR EACH ROW
    BEGIN 
		IF OLD.bid IN (SELECT bid FROM Rserves NATURAL JOIN Boat)
        THEN 
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'The boat details you want to delete has active reservations....!';
		END IF;
	END;
$$
DELIMITER ;

SHOW TRIGGERS;

DELETE FROM Boat WHERE bid = 101;

DELETE FROM Rservers WHERE bid = 101;

DELETE FROM Boat WHERE bid = 101;
-- select sid from sailor where rating >= 8 union select sid from rservers where bid = 103 order by sid;

-- select sname from sailor where sid not in (select sailor.sid from sailor natural join rservers natural join boat where bname like "%storm%") order by sname;

-- select sname from sailor where sid not in (select sailor.sid from sailor natural join rservers) and sname='%storm' order by sname;
-- select sname from sailor where sid in (select sailor.sid from sailor natural join rservers);
-- select sname, sid from sailor where age = (select max(age) from sailor);

-- select boat.bid, avg(sailor.age) from boat, rservers, sailor where boat.bid = rservers.bid and sailor.sid = rservers.sid and sailor.age > 20 group by boat.bid having count(distinct rservers.sid) >=2;
-- create view names_rating as select sname, rating from sailor order by rating desc;
-- select * from names_rating;
-- drop trigger active_reservation;
-- -- DELIMITER //
-- -- create trigger active_reservation before delete on boat for each row
-- -- begin
-- -- if bid in (select bid from boat natural join rservers) then
-- -- SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'table boat does not support deletion';
-- -- end if;
-- -- end;
-- -- //
-- -- DELIMITER ;
-- delimiter //
-- create trigger CheckAndDelete
-- before delete on Boat
-- for each row
-- BEGIN
-- 	IF EXISTS (select * from reserved where bid=OLD.bid) THEN
-- 		SIGNAL SQLSTATE '45000';
-- 	END IF;
-- END //

-- delimiter ;

-- delete from boat where bid=103;
-- select * from boat;