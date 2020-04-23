--CREATE database G_UNIVER;

use G_UNIVER
create table STUDENT
(
student_id real primary key,
surname nvarchar(50) not null,
group_num real check(group_num IN(1,2,3,4)),
)

alter table STUDENT add [start_date] date default '01/01/2020';

alter table STUDENT drop CONSTRAINT DF__STUDENT__start_d__4AB81AF0;
alter table STUDENT drop column [start_date];

INSERT into STUDENT
 values (131, 'Quadro3', 4),
 (351, 'Uno3', 2),
 (681, 'Samuel4', 3)

 SELECT * From STUDENT;
 SELECT surname, group_num FROM STUDENT;
 SELECT count(*) From STUDENT; 
 SELECT DISTINCT group_num FROM STUDENT;
 SELECT Top(2) * FROM STUDENT WHERE group_num=2;

 UPDATE STUDENT set group_num = 1;
 DELETE from STUDENT Where student_id = 13;

 SELECT * FROM STUDENT WHERE surname like 'Uno%'
 SELECT * FROM STUDENT WHERE surname 
 between'Samuel1' and 'Samuel5' 
  SELECT * FROM STUDENT WHERE surname 
 IN('Samuel', 'Samuel2') 

 --DROP TABLE STUDENT

 CREATE Table RESULTS
(  
	ID int   primary key   identity(1, 1),
	STUDENT_NAME nvarchar(20),
    AVER_VALUE as ID*ID
)

use G_MyBase

insert into Deliveries values (6F9629FF-8B86-D011-B42D-00CF4FC964F1,'BSU','exams',1, 10, getdate(), 'fast')