use LAB5_UNIVER;

go
create view [Преподаватель]
	as select TEACHER [код], 
	   TEACHER_NAME [имя преподавателя], 
	   GENDER [пол], 
	   PULPIT[код кафедры]
	from TEACHER;

go
create view [Количесвто кафедр]
	as select FACULTY.FACULTY_NAME [факультет],
			  count(PULPIT) [количество кафедр]
		from FACULTY join PULPIT
			on FACULTY.FACULTY=PULPIT.FACULTY
			group by FACULTY.FACULTY_NAME

go
create view [Аудитории]([код],[наименование аудитории])
	as select AUDITORIUM [код],
			  AUDITORIUM_NAME [наименование аудитории]
		from AUDITORIUM
			where AUDITORIUM_TYPE like 'лк%'

go
create view [Лекционные аудитории]([код],[наименование аудитории])
	as select AUDITORIUM,
			  AUDITORIUM_NAME
		from AUDITORIUM
			where AUDITORIUM_TYPE like 'лк%' with check option

go
create view [Дисциплины]([код], [наименование дисциплины], [код кафедры])
	as select top 100 [SUBJECT],
			  SUBJECT_NAME,
			  PULPIT
	from [SUBJECT]
	order by [SUBJECT]

	go
	alter view [Количесвто кафедр] with schemabinding
		as select f.FACULTY_NAME [факультет],
			  count(PULPIT) [количество кафедр]
		from dbo.FACULTY f join dbo.PULPIT p
			on f.FACULTY=p.FACULTY
			group by f.FACULTY_NAME 


use G_MyBase;

go
create view [Prod not BSU]
	as SELECT Products.product_name
	FROM Products
	WHERE Products.product_name not IN ( 
		SELECT Deliveries.product
		FROM Deliveries
		WHERE Deliveries.customer = 'BSU'
);