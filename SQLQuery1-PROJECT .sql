create database sql_project
use sql_project

--CREATE TRAINEE TABLE
create table trainee (
	   trainee_id int primary key identity(1,1) , trainee_name nvarchar(10),
	   gender nvarchar(8) , email nvarchar(45) , background nvarchar(15)
	   )
select * from trainee

EXEC sp_rename 'trainee.gernder', 'gender', 'COLUMN';

alter table trainee alter column trainee_name nvarchar(30)
alter table trainee alter column background nvarchar(30)


--INSERT VALUES IN TRAINEE TABLE
insert trainee (trainee_name,gender,email,background)
values ('Aisha Al-Harthy', 'Female', 'aisha@example.com', 'Engineering'),
	   ('Sultan Al-Farsi', 'Male', 'sultan@example.com', 'Business'),
	   ('Mariam Al-Saadi', 'Female',' mariam@example.com',' Marketing'),
	   ('Omar Al-Balushi',' Male',' omar@example.com',' Computer Science'),
	   ('Fatma Al-Hinai',' Female',' fatma@example.com',' Data Science') 


--CREATE TRAINER TABLE
create table trainer (
			trainer_id int primary key identity (1,1) , trainer_name nvarchar(30),
			specialty nvarchar(30) , phone int , email nvarchar(45)
			)


select * from trainer

alter table trainer alter column phone nvarchar(15)

--INSERT VALUES IN TRAINER TABLE
insert trainer ( trainer_name , specialty , phone , email)
values ('Khalid Al-Maawali',' Databases', 96891234567,' khalid@example.com'),
	   ('Noura Al-Kindi',' Web Development', 96892345678,' noura@example.com'),
	   ('Salim Al-Harthy',' Data Science', 96893456789,' salim@example.com')


--CREATE COURSE TABLE 
create table course (
		course_id int primary key identity (1,1) , title nvarchar(40),
		category nvarchar(30) , duration_hours int , c_level nvarchar(35)
		)
select * from course
--INSERT VALUES IN COURSE TABLE
insert course (title , category,duration_hours,c_level)
values ('Database Fundamentals',' Databases', 20,' Beginner'),
	   ('Web Development Basics',' Web', 30,' Beginner'),
	   ('Data Science Introduction',' Data Science', 25,' Intermediate'),
	   ('Advanced SQL Queries',' Databases', 15,' Advanced') 


--CREATE SCHEDULE TABLE
create table schedule (
				schedule_id int primary key identity (1,1) ,course_id int ,
				trainer_id int , start_date date , end_date date ,time_slot nvarchar(15),
				foreign key (course_id) references course(course_id),
				foreign key (trainer_id) references trainer(trainer_id)
		)


select * from schedule


--INSERT VALUES IN SCHEDULE TABLE
insert schedule (course_id ,trainer_id,start_date,end_date,time_slot)
values (1, 2, '2025-07-01',' 2025-07-10',' Morning'),
	   (2, 3,' 2025-07-05',' 2025-07-20',' Evening'),
	   (3 ,4,' 2025-07-10 ','2025-07-25 ','Weekend'),
	   (4, 2,' 2025-07-15',' 2025-07-22',' Morning') 

--CREATE ENROLLMENT TABLE
create table enrollemnt (
				enrollment_id int primary key identity(1,1),trainee_id  int,
				course_id int , enrollment_date date ,
				foreign key (trainee_id) references trainee(trainee_id),
				foreign key (course_id) references course(course_id)
				)
select * from enrollemnt

--INSERT VALUES IN ENROLLMENT TABLE
insert enrollemnt(trainee_id,course_id,enrollment_date)
values (6,1,' 2025-06-01'),(7, 1, '2025-06-02'),(8, 2,' 2025-06-03'),
	   (9 , 3,' 2025-06-04'),(10 , 3, '2025-06-05'),(6 , 4,' 2025-06-06') 


--1. Show all available courses (title, level, category) 
select title,c_level as level,category from course

--2. View beginner-level Data Science courses 
select c_level , category from course
where c_level = 'Beginner' and category = 'Data Science'

--3. Show courses this trainee is enrolled in 
select e.trainee_id , t.trainee_name, e.course_id , c.title
from  enrollemnt e , trainee t , course c
group by e.trainee_id , t.trainee_name , e.course_id , c.title
order by e.trainee_id
select * from schedule
select * from enrollemnt
select * from trainee
select * from course
select * from trainer
--4. View the schedule (start_date, time_slot) for the trainee's enrolled courses 
--(select e.course_id , s.start_date , s.time_slot from schedule s , enrollemnt e group by e.course_id , s.start_date , s.time_slot order by e.course_id select t.trainee_name ,  e.trainee_id from enrollemnt e join trainee t on t.trainee_id = e.trainee_id select c.title , e.course_id from enrollemnt e join course c on c.course_id = e.course_id)

select distinct t.trainee_name , c.title as course_name ,s.start_date , s.time_slot
from trainee t 
join enrollemnt e on t.trainee_id = e.trainee_id 
join course c  on e.course_id = c.course_id
join schedule s on c.course_id = s.course_id

--5. Count how many courses the trainee is enrolled in 
select  t.trainee_name,count(distinct s.course_id) as no_course
from trainee t 
join enrollemnt e on t.trainee_id = e.trainee_id
join schedule s on s.course_id = e.course_id
group by t.trainee_name

--6. Show course titles, trainer names, and time slots the trainee is attending 
select tr.trainer_name ,c.title as course_title , t.trainee_name , s.time_slot
from trainee t
join enrollemnt e on t.trainee_id = e.trainee_id
join schedule s on s.course_id = e.course_id
join course c on e.course_id = c.course_id
join trainer tr on s.trainer_id = tr.trainer_id
group by t.trainee_name,c.title,tr.trainer_name,s.time_slot
order by tr.trainer_name


--1. List all courses the trainer is assigned to 
select tr.trainer_name , course.title as course_name
from trainer tr 
join schedule s on tr.trainer_id = s.trainer_id
join course  on course.course_id = s.course_id


--2. Show upcoming sessions (with dates and time slots) 
select tr.trainer_name,c.title as course_name , s.start_date,s.end_date,s.time_slot
from trainer tr
join schedule s on tr.trainer_id = s.trainer_id
join course c on s.course_id = c.course_id


--3. See how many trainees are enrolled in each of your courses
select tr.trainer_name , count(distinct e.trainee_id) as trainee_num
from enrollemnt e

join schedule s on e.course_id = s.course_id
join trainer tr on s.trainer_id = tr.trainer_id
group by tr.trainer_name

--4. List names and emails of trainees in each of your courses 
select t.trainee_name, tr.trainer_name, t.email, c.title as course_name
from trainee t
join enrollemnt e on t.trainee_id = e.trainee_id
join course c on e.course_id = c.course_id
join schedule s on e.course_id = s.course_id
join trainer tr on s.trainer_id = tr.trainer_id

--5. Show the trainer's contact info and assigned courses 
select distinct(t.trainer_name), t.email , t.phone, c.title as course_name
from trainer t
join schedule s on t.trainer_id = s.trainer_id
join course c on s.course_id = c.course_id

--6. Count the number of courses the trainer teaches 

select  tr.trainer_name , count(distinct course.title) as num_cousrses
from trainer tr 
join schedule s on tr.trainer_id = s.trainer_id
join course  on course.course_id = s.course_id
group by tr.trainer_name

--1. Add a new course (INSERT statement) 
insert course (title , category,duration_hours,c_level) 
values ('Python for Beginners', 'Programming', 20, 'Beginner')

--2. Create a new schedule for a trainer 
insert schedule (course_id, trainer_id, start_date, end_date, time_slot)
values (5, 3, '2025-08-01', '2025-08-15', 'Evening')

--3. View all trainee enrollments with course title and schedule info 
select t.trainee_name , c.title , s.* 
from enrollemnt e
join trainee t on e.trainee_id = t.trainee_id
join course c on e.course_id = c.course_id
join schedule s on e.course_id = s.course_id

--4. Show how many courses each trainer is assigned to 
select tr.trainer_name , count(c.course_id) as courses_num
from trainer tr
join schedule s on tr.trainer_id = s.trainer_id
join  course c on s.course_id = c.course_id
group by tr.trainer_name

--5. List all trainees enrolled in "Data Basics" 
select t.trainee_name , c.title 
from enrollemnt e
join trainee t on e.trainee_id = t.trainee_id
join course c on e.course_id = c.course_id
where c.title = 'Data Basics'

--6. Identify the course with the highest number of enrollments 

select top 1 c.title as high_inroll, count(*) as enrollment_count
from enrollemnt e
join course c on e.course_id = c.course_id
group by c.title
order by enrollment_count desc;

--7. Display all schedules sorted by start date 
select * from schedule
order by start_date 
