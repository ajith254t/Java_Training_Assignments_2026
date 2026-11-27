USE lms_db;
--- 1ST HALF ---
DESC contact;
INSERT INTO user (username, password, role, isActive)
VALUES ('harry.potter', 'pass123', 'LEARNER', '1');

INSERT INTO contact (primary_contact, alternate_contact, main_email, secondary_mail)
VALUES ('9876543210', NULL, 'harry@example.com', NULL);

INSERT INTO learner (name, user_id, contact_id, address_id)
VALUES ('Harry Potter', 1, 1, 1);
select*from learner;
select*from address;

insert into learner (name, user_id,contact_id,address_id) 
values ("Ronald Weasley", 1, 1,1);
select*from learner;

desc instructor;
INSERT INTO user (username, password, role, isActive)
VALUES ('bruce.wayne', 'batpass123', 'INSTRUCTOR', '1'),('tony.stark', 'ironpass123', 'INSTRUCTOR', '1');

INSERT INTO contact (primary_contact, alternate_contact, main_email, secondary_mail)
VALUES ('9876543211', NULL, 'bruce@wayneenterprises.com', NULL),('9876543212', NULL, 'tony@starkindustries.com', NULL);
  
INSERT INTO address (city, state, pincode)VALUES ('Mumbai', 'Maharashtra', '400001'),('Bengaluru', 'Karnataka', '560001');

INSERT INTO instructor (name, salary, user_id, contact_id, address_id)VALUES ('Bruce Wayne', 150000.00, 2, 2, 2), ('Tony Stark', 200000.00, 3, 3, 3);


alter table learner drop primary key ,  add primary key (id),add unique(user_id);

-- FK Nullable => make Delete Isolation --
UPDATE learner
SET address_id = NULL
WHERE id = 2;
select l.id,l.name,c.primary_contact,c.main_email,u.username,u.isActive,a.city from learner l join user u on l.user_id = u.id join contact c on l.contact_id =c.id left join address a on l.address_id =a.id;

---- 2ND HALF --


insert into department(name) values('Programming'),('Product Management');

insert into course(name,fee,instructor_id,department_id)values('SQL Learning',5000000,2,1);


 SELECT c.id, c.name, c.fee, i.name AS instructor, d.name AS department FROM course c
JOIN instructor i ON c.instructor_id = i.id 
JOIN department d ON c.department_id = d.id;

insert into user (username, password, role) 
values ('Albus Dumbledore', "albus@123", "INSTRUCTOR"); 
 update user set username = 'albus' where id = 3;
insert into contact(primary_contact,  main_email)
values("85968978567", "albus@gmail.com");

insert into address(city, pincode) values ('MUMBAI', '400092');

insert into instructor(name, salary, contact_id, user_id, address_id) 
values ("Albus Dumbledore", "250000", 3,3,2); 

insert into department(name) values ('programming'),('product management');  -- multiple inserts 

insert into course (name, fee, instructor_id, department_id) 
values ('SQL programming', 3500, 1, 1);


select c.id as course_id,
c.name as course_name,
c.fee,
i.name as instructor_name,
d.name as department_name
from course c 
JOIN instructor i ON c.instructor_id = i.id 
JOIN department d ON c.department_id = d.id;
---- GROUP BY ----------------------------------------------------------------------------------------------------------
insert into user(username,password,role,isActive)values('Hirani','hirani1234','INSTRUCTOR',1);
insert into contact(primary_contact,main_email)values('7418529630','hirani@yaaho.in');
insert into address(city,state,pincode)values('Chennai','TamilNadu',600028);

--- Instructor with Assigned course-----(INNER JOIN)
select i.name as Total_Instructors ,count(c.id) as numberOfCourses from instructor i inner join course c on i.id=c.instructor_id group by i.id,i.name order by numberOfCourses desc;


--- All Instructors-----(LEFT JOIN)
select i.name as Total_Instructors ,count(c.id) as numberOfCourses from instructor i left join course c on i.id=c.instructor_id group by i.id,i.name order by numberOfCourses desc;
  
select d.name, avg(i.salary) as 'AVG Salary'
from instructor i 
JOIN course c ON i.id = c.instructor_id 
JOIN department d ON c.department_id = d.id
group by d.name;


----- All courses (including courses with 0 enrolled learners)---
SELECT c.id AS course_id, c.name AS course_name, COUNT(lc.learner_id) AS total_enrolled_learners
FROM course c
LEFT JOIN learner_course lc
ON c.id = lc.course_id
GROUP BY c.id, c.name;


SELECT c.id AS course_id, c.name 'course_name' , COUNT(lc.learner_id)  'total_enrolled_learners'
FROM course c
LEFT JOIN learner_course lc
ON c.id = lc.course_id
GROUP BY c.id, c.name
having count(lc.learner_id)>=2 
order by count(lc.learner_id)>=2 asc;

---- SELF JOIN --------------------------------------------------------------------------------------------------------------------------
ALTER TABLE instructor ADD COLUMN lead_id INT NULL, ADD CONSTRAINT fk_instructor_lead FOREIGN KEY (lead_id) REFERENCES instructor(id);
update instructor set lead_id=1 where id=2;
update instructor set lead_id=2 where id=3;
update instructor set lead_id=2 where id=4;

select i.name 'Instructors', coalesce(l.name,'No Lead') 'Lead'
from instructor i left join instructor l on i.id=l.lead_id;

select l.name, count(i.id) as 'No_of_Instrcutors' from instructor i  join instructor l on l.id = i.lead_id group by l.id, l.name; 
---- SUB QUERY-------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Nested Query / Subquery 
-- You write sub query, when you need something pre-calculated. 
-- Never replace normal join queries with sub-queries. 

-- Display all instructors whose salary is greater than average salary of instructors working in programming department
-- Fan-out issue


select i.name -- we display those instructors whose salary is greater than avg salary computed
from instructor i
where i.salary > (select i.name from instructor i   -- once we get instructors from programming department, we compute their avg(salary). here we avoid duplicates
					WHERE EXISTS (select i.name from instructor i  
								JOIN course c ON i.id = c.instructor_id
								JOIN department d ON c.department_id = d.id 
								where d.name='programming')); -- where exits is used to avoid fan-out problem i.e. duplicate records getting added for computing avg 

 -- where exits is used to avoid fan-out problem i.e. duplicate records getting added for computing avg 
 -- once we get instructors from programming department, we compute their avg(salary). here we avoid duplicates
 -- we display those instructors whose salary is greater than avg salary computed


-- step 1: fetch all instructors that are teaching in department=programming via course 

select i.id from instructor i  
JOIN course c ON i.id = c.instructor_id
JOIN department d ON c.department_id = d.id 
where d.name='programming';

-- o/p: 1 1 2  

-- step 2 - to fix this we use IN
select i.name
from instructor i
where i.salary >
				(select avg(i.salary)
				from instructor i
				WHERE i.id IN (select i.id from instructor i  
								JOIN course c ON i.id = c.instructor_id
								JOIN department d ON c.department_id = d.id 
								where d.name='programming'));
-- Nested - Sub-Queries 
/*
IN 
where exists 
ALL 
ANY
=
*/

------ ALL <=> Max() and ANY <=> Min()---------------------------------------------------------

-- display instructors earning more than ALL the instructor working in 'programming' department 
select i.name
from instructor i 
where i.salary > ALL (select i.salary from instructor i 
						JOIN course c ON i.id = c.instructor_id
						JOIN department d ON c.department_id = d.id 
						where d.name='programming');
-- we don't usually use this ALL as this is similar to using max grouping Fn 
select i.name
from instructor i 
where i.salary >  (select max(i.salary) from instructor i 
						JOIN course c ON i.id = c.instructor_id
						JOIN department d ON c.department_id = d.id 
						where d.name='programming');

-- display instructors earning more than atleast one instructor from 'product management' department 
select i.name
from instructor i 
where i.salary > ANY (select i.salary from instructor i 
						JOIN course c ON i.id = c.instructor_id
						JOIN department d ON c.department_id = d.id 
						where d.name='product management');
 -- OR                       
select i.name
from instructor i 
where i.salary >  (select min(i.salary) from instructor i 
						JOIN course c ON i.id = c.instructor_id
						JOIN department d ON c.department_id = d.id 
						where d.name='product management');
                         
------------------------  USING IN --------------------------------                         


-- IN 
-- display all learners living in following cities ['london', 'mumbai']

select l.name
from learner l JOIN address a ON l.address_id = a.id
where a.city IN ('london', 'mumbai');

-- using subquery 
select l.name
from learner l
where l.address_id IN (select a.id 
						from address a 
						where a.city IN ('london', 'mumbai')); 
-- 7 = [8,9,1,2]

-- display learner that have enrolled in course name as Java Programming. do this using sub query 

select l.name
from learner l
where l.id IN 
			(select lc.learner_id 
            from learner_course lc 
            where lc.course_id = (select c.id -- '=' here works because we r guarateed to get single id as c.name is unique
								  from course c 
                                   where c.name="java programming")); 

select l.name
from learner l
where l.id IN 
			(select lc.learner_id 
            from learner_course lc 
            where lc.course_id IN ( select c.id 
									from course c 
									where c.name="java programming"));
                                    
-- window functions : rank(), dense_rank(), row_number() 
/*
+----+--------------------+------+---------------+---------------+
| id | name               | fee  | instructor_id | department_id |
+----+--------------------+------+---------------+---------------+
|  1 | SQL programming    | 3500 |             1 |             1 |
|  2 | JAVA programming   | 6500 |             1 |             1 |
|  3 | SPRING Framework   | 8500 |             2 |             1 |
|  4 | Product Management | 9500 |             3 |             2 |
|  5 | ITA cert 1         | 2345 |             4 |             2 |
|  6 | Scrum A-Z          | 6000 |             3 |             2 |
+----+--------------------+------+---------------+---------------+
*/
-- display the courses and their ranks as per the fee 
select c.name, c.fee , RANK() OVER (order by fee DESC) as rnk
from course c;

/*
Product Management	9500	1
SPRING Framework	8500	2
JAVA programming	6500	3
Scrum A-Z			6500	3
SQL programming		3500	5
ITA cert 1			2345	6
*/
update course SET fee=6500 where id=6;
-- rank() skips the sequence -- above it has skipped rank 4

select c.name, c.fee , DENSE_RANK() OVER (order by fee DESC) as rnk
from course c;

/*
Product Management	9500	1
SPRING Framework	8500	2
JAVA programming	6500	3
Scrum A-Z			6500	3
SQL programming		3500	4
ITA cert 1			2345	5
*/
-- dense rank does not skip seq. 

select c.name ,
row_number() OVER (order by c.fee ASC) as row_num ,
RANK() OVER (order by fee DESC) as rnk, 
DENSE_RANK() OVER (order by fee DESC) as dense_rnk
from course c; 


-- TODO: compute ranks by instructor salaries. ASC & DESC

 select name,fee,department_id,dense_rank() over(partition by department_id order by fee desc) from course;
 
 
 ----------------------- PROCEDURES -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 DELIMITER $$
create procedure all_courses() 
BEGIN
	select * from course;
END;
 $$
show procedure status where db='lms_db_nov_2026';
CALL all_courses();
-- procedues can be called from Java app directly. which means, the java programmer would not know what logic is 
-- inside the procedure. 
-- it only sees theresult procedure give 
-- THIS ENSURES LOGIC SECURITY 

-- display all courses that belong to particular department 

DELIMITER $$
create procedure courses_by_dept_id(IN p_deptId INT) -- p_deptId = 1
BEGIN
	select c.id,c.name
	from course c
	where c.department_id = p_deptId;
END;
$$

call courses_by_dept_id(2);


-- Give the total fee of all courses that belong to particular track (id)
DELIMITER $$
create procedure sum_course_fee_by_track_id(IN p_trackId INT, OUT p_sum int)
BEGIN
	-- sql
	select SUM(c.fee) into p_sum
	from course c 
	JOIN course_track ct ON c.id = ct.course_id
	where ct.track_id = p_trackId;
END;
$$

drop procedure sum_course_fee_by_track_id; 

CALL sum_course_fee_by_track_id(2, @sum);
select @sum;

-- INOUT 
DELIMITER $$
create procedure sum_course_fee_by_track_id_inout(INOUT p_val INT)
BEGIN
	-- sql
	select SUM(c.fee) into p_val
	from course c 
	JOIN course_track ct ON c.id = ct.course_id
	where ct.track_id = p_val;
END;
$$
SET @val = 2;
CALL sum_course_fee_by_track_id_inout(@val);
select @val
-- create a login procedure for LMS system --------------------------------------------------------------------------------------------------------------------------------------
-- in: username, password 
-- out: role 
DELIMITER $$

DROP PROCEDURE IF EXISTS login $$

CREATE PROCEDURE login(
    IN p_username VARCHAR(255),
    IN p_password VARCHAR(255),
    OUT p_role VARCHAR(255)
)
BEGIN
    DECLARE v_password VARCHAR(255);
    DECLARE v_role VARCHAR(255);
    DECLARE v_isactive BOOLEAN;
    DECLARE v_found INT DEFAULT 0;

    SELECT COUNT(*)
    INTO v_found
    FROM `user` u
    WHERE u.username = p_username;

    IF v_found = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid credentials';
    END IF;

    IF v_found > 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Duplicate username found';
    END IF;

    SELECT u.password, u.role, u.isActive
    INTO v_password, v_role, v_isactive
    FROM `user` u
    WHERE u.username = p_username;

    IF v_password IS NULL OR p_password <> v_password THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid credentials';
    END IF;

    IF COALESCE(v_isactive, FALSE) = FALSE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User is disabled';
    END IF;

    SET p_role = v_role;
END $$
DELIMITER ;

-- SIGN UP FOR LEARNER ---------------------------------------------------------------------------------------------------------
-- make contact_id NULL
-- ask for name,username,password
-- assign rolw as LEARNER, is_active as true
-- check if username exits already is yes then throw exception
-- do a simple insert
use lms_db;
desc learner;
DELIMITER $$
create procedure signup_learner(
    in p_name varchar(255),
    in p_username varchar(255),
    in p_password varchar(255)
)
begin
    declare v_user_count int default 0;
    declare v_new_user_id int;

    -- Check if username already exists
    select COUNT(*)
    into v_user_count
    from `user`
    where username = p_username;

    if v_user_count > 0 then
        signal sqlstate '45000'
            set message_text = 'Username already exists';
    end if;

    start transaction;

    -- Insert into user table
    insert into `user` (username, password, role, isActive)
    values (p_username, p_password, 'LEARNER', true);

    set v_new_user_id = LAST_INSERT_ID();

    -- Insert into learner table with contact_id as NULL
    insert into learner (name, user_id, contact_id, address_id)
    values (p_name, v_new_user_id, null, null);

    commit;
end $$

DELIMITER ;
-- sign up TESTING----------
USE lms_db;
ALTER TABLE learner
MODIFY COLUMN contact_id INT NULL;
SELECT * FROM `user` WHERE username = 'haljordan@green';
SELECT * FROM learner WHERE user_id IN (SELECT id FROM `user` WHERE username = 'haljordan@green');
DELETE FROM learner WHERE user_id IN (SELECT id FROM `user` WHERE username = 'haljordan@green');
DELETE FROM `user` WHERE username = 'haljordan@green';

CALL signup_learner('Hal Jordan', 'haljordan@green', 'greenlantern');

SELECT id FROM `user` WHERE username = 'haljordan@green';

CALL signup_learner('Hal Jordan', 'haljordan@green', 'greenlantern');
CALL signup_learner('Barry Allen ', 'allen@flash', 'flash');


-- Enroll procedure 
-- a learner(learner_id) enrolls in a course(course_id)  
-- check id given p_learner_id is present in learner table - if NO then say leanrer id invalid
-- check if given p_course_id is present in course table - if no then say course id invalid 
-- check if combo of p_learner_id,p_course_id is present in learner_course, if yes then say Already enrolled 
-- read amount_paid , coupon 
-- discount = course.fee - amount_paid 
-- insert in learner_course 

DELIMITER $$
create procedure enroll(
IN p_learner_id INT,
IN p_course_id INT,
IN p_amount_paid double,
IN p_coupon varchar(255))
BEGIN
declare v_discount double;
declare v_fee double;

-- validate learner_id
IF NOT EXISTS (select 1 from learner where id=p_learner_id) THEN
	SIGNAL SQLSTATE '45000' SET message_text = 'Leearner id invalid';
END IF; 

-- validate course_id
IF NOT EXISTS (select 1 from course where id=p_course_id) THEN
	SIGNAL SQLSTATE '45000' SET message_text = 'Course id invalid';
END IF; 

-- validate if already enrolled 
IF EXISTS (select 1 from learner_course where learner_id = p_learner_id AND course_id = p_course_id) THEN
	SIGNAL SQLSTATE '45000' set message_text = 'Learner already enrolled in the course'; 
END IF; 

-- compute discount given 
select fee into v_fee
from course 
where id = p_course_id; 

SET v_discount = v_fee - p_amount_paid; 

-- insert for enroll 
insert into learner_course(learner_id, course_id, date_of_enroll, amount_paid, coupon, discount)
values 
(p_learner_id, p_course_id, current_date(), p_amount_paid, p_coupon, v_discount); 
END;
$$

CALL enroll(11, 1, 3200, 'DISCOUNT300'); -- works
CALL enroll(11, 1, 3200, 'DISCOUNT300'); -- Error Code: 1644. Learner already enrolled in the course

CALL enroll(110, 1, 3200, 'DISCOUNT300'); -- Error Code: 1644. Leearner id invalid
CALL enroll(11, 100, 3200, 'DISCOUNT300'); -- Error Code: 1644. Course id invalid

-- Views 
select * 
from learner l 
LEFT JOIN user u ON l.user_id = u.id 
LEFT JOIN contact c ON l.contact_id = c.id 
LEFT JOIN address a ON l.address_id = a.id; 

-- learner info to be given : Template 
-- id, name, username, is_active , primary_contact, main_email, city

create view learner_view AS
select l.id as 'learner_id', l.name as 'learner_name', u.username as 'username', u.is_active , 
c.primary_contact as 'contact' , c.main_email as 'email' , coalesce(a.city, "Not given") as 'City' 
from learner l 
LEFT JOIN user u ON l.user_id = u.id 
LEFT JOIN contact c ON l.contact_id = c.id 
LEFT JOIN address a ON l.address_id = a.id; 

select * from learner_view; 


/*
Views
1. Horizontal view : hide attributes ex. learner_view 
2. Vertical view : hide tuples/records ex. active_learner_view
*/

create view active_learner_view AS
select l.id as 'learner_id', l.name as 'learner_name', u.username as 'username', u.is_active , 
c.primary_contact as 'contact' , c.main_email as 'email' , coalesce(a.city, "Not given") as 'City' 
from learner l 
LEFT JOIN user u ON l.user_id = u.id 
LEFT JOIN contact c ON l.contact_id = c.id 
LEFT JOIN address a ON l.address_id = a.id
where u.is_active=true; 

-- create a view of stats for courses having learners  
/*
course name | instructor name | number_of_learners 
*/
create view course_learner_stats AS
select c.name as 'course name', i.name as 'instructor name', count(l.id) as 'number_of_learners'
from learner l 
JOIN learner_course lc ON l.id = lc.learner_id
JOIN course c ON lc.course_id = c.id
JOIN instructor i ON i.id = c.instructor_id
group by c.id,c.name, i.name;

/*
View vs. procedure

View is created on select statement
Procedure is usually created for insert/update/delete ops 

View cannnot take any i/p from end user
Procedure can take i/p via IN parameter / INOUT parameter 
*/