create database students;
use students;

create table student(
regno varchar(20) primary key,
name varchar(20),
major varchar(20),
bdate date
);

create table courses(
course int primary key,
cname varchar(20),
dept varchar(20)
);

create table enroll (
regno varchar(20),
course int,
sem int,
marks int,
foreign key (course) references courses(course) on delete cascade,
foreign key (regno) references student(regno) on delete cascade

);
create table book_adoption(
course int,
sem int,
bookISBN int,
foreign key (course) references courses(course) on delete cascade
);

create table textbook(
bookISBN int primary key,
book_title text,
publisher varchar(20),
author varchar(20)
);

alter table book_adoption add constraint FK foreign key (bookISBN) references textbook(bookISBN);

INSERT INTO student VALUES
("01HF235", "Student_1", "Computer Engineering", "2001-05-15"),
("01HF354", "Student_2", "Literature", "2002-06-10"),
("01HF254", "Student_3", "Philosophy", "2000-04-04"),
("01HF653", "Student_4", "History", "2003-10-12"),
("01HF234", "Student_5", "Economics", "2001-10-10");

INSERT INTO courses VALUES
(001, "Computer Engineering", "CS"),
(002, "Literature", "English"),
(003, "Philosophy", "Philosphy"),
(004, "History", "Social Science"),
(005, "Economics", "Social Science");

INSERT INTO enroll VALUES
("01HF235", 001, 5, 85),
("01HF354", 002, 6, 87),
("01HF254", 003, 3, 95),
("01HF653", 004, 3, 80),
("01HF234", 005, 5, 75);

INSERT INTO book_adoption VALUES
(001, 5, 241563),
(002, 6, 532678),
(003, 3, 453723),
(004, 3, 278345),
(001, 6, 426784);

INSERT INTO textbook VALUES
(241563, "Operating Systems", "McGraw Hill", "Silberschatz"),
(532678, "Complete Works of Shakesphere", "Oxford", "Shakesphere"),
(453723, "Immanuel Kant", "Delphi Classics", "Immanuel Kant"),
(278345, "History of the world", "The Times", "Richard Overy"),
(426784, "Behavioural Economics", "Hot Science", "David Orrel");

-- 1. Demonstrate how you add a new text book to the database and make this book be 
-- adopted by some department. 
insert into textbook values (254211,'The Great Conversation','OUP','Norman Melchert');
insert into book_adoption values (003,5,254211);
select * from textbook natural join book_adoption natural join courses;
-- 2. Produce a list of text books (include Course #, Book-ISBN, Book-title) in the alphabetical 
-- order for courses offered by the ‘CS’ department that use more than two books. 
select b.bookISBN,count(b.bookISBN) from book_adoption b,courses c where b.course=c.course and c.dept="CS" group by b.bookISBN;
-- 3. List any department that has all its adopted books published by a specific publisher.
select courses.dept from courses,textbook,book_adoption where textbook.publisher = " " and courses.course = book_adoption.course and book_adoption.bookISBN=textbook.bookISBN group by courses.dept having count(distinct bookISBN)=(select count(*) from book_adoption where book_adoption.course in (select course from courses where dept = course.dept));   
-- 4. List the students who have scored maximum marks in ‘DBMS’ course.
select student.name from student,enroll,courses where courses.course = enroll.course and major='Economics' and enroll.marks = (select max(marks) from enroll where enroll.course = courses.course) ;
-- 5. Create a view to display all the courses opted by a student along with marks obtained.
create view student_courses as select courses.cname, student.name, enroll.marks from courses natural join student natural join enroll;
select * from student_courses;
-- 6. Create a trigger such that it Deletes all records from enroll table when course is deleted 
delimiter //
create trigger delete_record after delete on course for each row
begin
if courses.course = enroll.course then
delete from enroll where enroll.course = courses.course;
end if;
end;
delimiter ;

delete from courses where course=001;
select * from courses;
select * from enroll;