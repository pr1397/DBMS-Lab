create database company;
use company;

create table employee(
ssn varchar(10) primary key,
ename varchar(20),
address text,
sex varchar(7),
salary int,
superSSN varchar(10),
dno int
);

create table department(
dno int primary key,
dname varchar(20),
mgrSSN varchar(10),
mgrStartDate date
);

alter table employee add constraint FK foreign key (dno) references department(dno);

create table dlocation(
dno int,
dloc varchar(20),
foreign key (dno) references department(dno) on delete cascade
);

create table project(
pno int primary key,
pname char(30),
plocation char(30),
dno int,
foreign key (dno) references department(dno)
);
drop table project;
create table works_on(
ssn varchar(10),
pno int,
hours int,
foreign key (pno) references project(pno) on delete cascade,
foreign key (ssn) references employee(ssn)
);
drop table works_on;
INSERT INTO department VALUES
(001, "Human Resources", "473DS322", "2020-10-21"),
(002, "Quality Assesment", "473DS584", "2020-10-19"),
(003, "Technical", "473DS635", "2020-10-20"),
(004, "Quality Control", "473DS684", "2020-10-18"),
(005, "R & D", "473DS475", "2020-10-17");

INSERT INTO employee VALUES
("01NB235", "Employee_1","Siddartha Nagar, Mysuru", "Male", 1500000, "2001BD05", 5),
("01NB354", "Employee_2", "Lakshmipuram, Mysuru", "Female", 1200000,"2001BD08", 2),
("02NB254", "Employee_3", "Pune, Maharashtra", "Male", 1000000,"2002BD04", 4),
("03NB653", "Employee_4", "Hyderabad, Telangana", "Male", 2500000, "2003BD10", 5),
("04NB234", "Employee_5", "JP Nagar, Bengaluru", "Female", 1700000, "2004BD01", 1);

INSERT INTO dlocation VALUES
(001, "Jaynagar, Bengaluru"),
(002, "Vijaynagar, Mysuru"),
(003, "Chennai, Tamil Nadu"),
(004, "Mumbai, Maharashtra"),
(005, "Kuvempunagar, Mysuru");

INSERT INTO project VALUES
(241563, "System Testing", "Mumbai, Maharashtra", 004),
(532678, "Cost Mangement", "JP Nagar, Bengaluru", 001),
(453723, "Product Optimization", "Hyderabad, Telangana", 005),
(278345, "Yeild Increase", "Kuvempunagar, Mysuru", 005),
(426784, "Product Refinement", "Saraswatipuram, Mysuru", 002);

INSERT INTO works_on VALUES
("01NB235", 278345, 5),
("01NB354", 426784, 6),
("04NB234", 532678, 3),
("02NB254", 241563, 3),
("03NB653", 453723, 6);

-- 1. Make a list of all project numbers for projects that involve an employee whose last name 
-- is ‘Scott’, either as a worker or as a manager of the department that controls the project. 
select project.pname from project,works_on, employee where project.pno = works_on.pno and works_on.ssn = employee.ssn and employee.ename like "%Smith%";

-- 2. Show the resulting salaries if every employee working on the ‘IoT’ project is given a 10 
-- percent raise. 
select employee.ename, employee.salary*1.1 as Salary from employee natural join works_on natural join project where project.pname = 'Yeild Increase';
-- 3. Find the sum of the salaries of all employees of the ‘Accounts’ department, as well as 
-- the maximum salary, the minimum salary, and the average salary in this department 
select sum(salary), max(salary),min(salary),avg(salary) from employee where employee.dno = (select dno from department where dname = "Human Resources");
-- 4. Retrieve the name of each employee who works on all the projects controlled by 
-- department number 5 (use NOT EXISTS operator).
select ename from employee where not exists (Select * from project where dno = 3 and project.pno not in (select pno from works_on where works_on.ssn = employee.ssn));
-- 5. For each department that has more than five employees, retrieve the department 
-- number and the number of its employees who are making more than Rs. 6,00,000.
select dno, count(ssn) as NumOfEmp from employee natural join department where employee.salary>60000 group by dno having count(employee.ssn)>2;
-- 6. Create a view that shows name, dept name and location of all employees.
create view details as select employee.ename, department.dname, dlocation.dloc from employee,department, dlocation where employee.dno = department.dno and department.dno = dlocation.dno;
select * from details;
-- 7. A trigger that automatically updates manager’s start date when he is assigned 
delimiter //
create trigger UpdateManagerStartDate
before insert on department
for each row
begin
	set new.mgrStartDate=curdate();
end;
//
delimiter ;

insert into department (dno,dname,mgrSSN) values (012,'Electrical',3321);
select * from department;