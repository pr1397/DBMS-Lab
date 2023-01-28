create database insurance;
-- drop database insurance;
use insurance;

create table if not exists person(
id varchar(10) primary key,
name varchar(20),
addr text
);

create table if not exists car(
regno varchar(10) primary key,
model char(20),
year int
);

create table if not exists accident(
repno int,
accdate date,
location varchar(20)
);

create table owns(
id varchar(20),
regno varchar(10),
foreign key (id) references person(id),
foreign key (regno) references car(regno)
);

create table if not exists participated(
id varchar(20),
regno varchar(10),
repno int,
damageamt int,
foreign key (id) references person(id),
foreign key (regno) references car(regno)
);

insert into person values 
('101','John Smith','101 Kartavya Path'),
('124','Jason Manoj','729 Cuffe Parade'),
('143','Kavya Rautela','2 Candolim'),
('121','Sharon Daniels','4th AVenue, Banglore'),
('432','Roberta Kingsley','6 MG Road');

insert into car values
('KA09MA1234','Swift',2009),
('AP19JA3421','Alto',2012),
('TN03HR2319','Mazda',2020),
('MA07TH9278','WagonR',2017),
('PB12HG7654','i10',2016);

insert into accident values
(8948,'2020-09-28','Delhi'),
(2463,'2015-06-08','Mumbai'),
(4592,'2022-10-11','Goa'),
(8420,'2019-01-01','Banglore'),
(6820,'2020-07-21','Delhi');

insert into owns values
('101','AP19JA3421'),
('124','TN03HR2319'),
('143','MA07TH9278'),
('121','PB12HG7654'),
('432','KA09MA1234');

insert into participated values
('101','AP19JA3421',8948,30000),
('124','TN03HR2319',2463,30000),
('143','MA07TH9278',4592,30000),
('121','PB12HG7654',8420,30000),
('432','KA09MA1234',6820,30000);

-- 1. Find the total number of people who owned cars that were involved in accidents in 2021.
select count(distinct name) from person,accident,participated where person.id = participated.id and accident.repno = participated.repno and  accdate like "%2020%";
-- 2. Find the number of accidents in which the cars belonging to “Smith” were involved. 
select count(*) from accident,person,participated where accident.repno = participated.repno and participated.id = person.id and person.name like "%Smith%";

-- 3. Add a new accident to the database; assume any values for required attributes. 
insert into accident values (6821,'2021-08-22','Delhi');
-- 4. Delete the Mazda belonging to “Smith”. 
delete from car where regno = (select regno from owns natural join person where person.name like '%Smith%') and model = 'Mazda';
select * from car;
-- 5. Update the damage amount for the car with license number “KA09MA1234” in the accident 
-- with report.
update participated set damageamt = 789000 where regno = 'KA09MA1234';
select * from participated;
-- 6. A view that shows models and year of cars that are involved in accident.
create view newview as select car.model, accident.accdate from car natural join accident;
select * from newview;
-- 7. A trigger that prevents driver with total damage amount >rs.50,000 from owning a car.
DELIMITER $$
CREATE TRIGGER PDOC
	BEFORE INSERT ON Owns
    FOR EACH ROW
    BEGIN
		IF NEW.id IN (SELECT id FROM Participated WHERE damageamt > 50000)
        THEN 
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Person cannot own a car....!';
		END IF;
	END;
$$
DELIMITER ;

INSERT INTO Owns(id, regno) VALUES ('D444', 'KA20AB4223');




-- select count(*) from accident where accdate like "%2021%";
-- select count(*) from accident natural join participated natural join person where person.name like "%Smith%";
-- delete from owns where id = (select id from person where name = "%Smith%") and regno = (select regno from car where model="Mazda");
-- select * from owns;

-- update participated set damageamt = 50000 where regno='KA09MA1234';

-- create view cars_involved as select car.model, car.regno, accident.accdate from car natural join accident;
-- select * from cars_involved;
-- DELIMITER //
-- create trigger damage_check before insert  on participated for each row
-- begin
-- if damageamt > 50000 then
-- set new.regno = NULL;
-- end if;
-- end;
-- DELIMITER ;

-- insert into participated values
-- ('111','KA54RE4145',8948,130000);
-- select * from participated;