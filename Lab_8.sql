use LAB5_UNIVER;

go
create view [�������������]
	as select TEACHER [���], 
	   TEACHER_NAME [��� �������������], 
	   GENDER [���], 
	   PULPIT[��� �������]
	from TEACHER;

go
create view [���������� ������]
	as select FACULTY.FACULTY_NAME [���������],
			  count(PULPIT) [���������� ������]
		from FACULTY join PULPIT
			on FACULTY.FACULTY=PULPIT.FACULTY
			group by FACULTY.FACULTY_NAME

go
create view [���������]([���],[������������ ���������])
	as select AUDITORIUM [���],
			  AUDITORIUM_NAME [������������ ���������]
		from AUDITORIUM
			where AUDITORIUM_TYPE like '��%'

go
create view [���������� ���������]([���],[������������ ���������])
	as select AUDITORIUM,
			  AUDITORIUM_NAME
		from AUDITORIUM
			where AUDITORIUM_TYPE like '��%' with check option

go
create view [����������]([���], [������������ ����������], [��� �������])
	as select top 100 [SUBJECT],
			  SUBJECT_NAME,
			  PULPIT
	from [SUBJECT]
	order by [SUBJECT]

	go
	alter view [���������� ������] with schemabinding
		as select f.FACULTY_NAME [���������],
			  count(PULPIT) [���������� ������]
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