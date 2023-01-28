create database student;
use student;
create table stu(
sid int primary key,
name varchar(30),
branch varchar(30),
sem int,
addr text,
phone varchar(20),
email varchar(20)
);
drop table stu;
insert into stu values
(001,'Dan','CSE',2,'Kuvempunagar',9392028038,'dan@yahoo.com'),
(005,'Varnia','CSE',6,'Rajarajeshwari',755654889,'var@gmail.com'),
(004,'Manya','EEE',3,'Vijaynagar',987575245,'manya@yahoo.com'),
(003,'Ranjit','ECE',2,'Kuvempunagar',7587125555,'ranjit@gmail.com'),
(007,'Kiran','CSE',3,'Vani Vilas Mohalla',633544863,'kiran11@yahoo.com');

update stu set addr = 'Manasa Gangothri' where sid = 003;
select * from stu;

select * from stu where branch = 'CSE';
select * from stu where branch = 'CSE' and addr='Kuvempunagar';

delete from stu where sid = 001;
