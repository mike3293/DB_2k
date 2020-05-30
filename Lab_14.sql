use LAB5_UNIVER;

--1 Скалярная функция подсчета количества студентов по заданному факультету
--(ед.знач.)
go
create function COUNT_STUDENTS(@faculty nvarchar(20)) returns int
as begin
declare @rc int = 0;
set @rc = (
SELECT count(IDSTUDENT) from STUDENT join GROUPS
    on STUDENT.IDGROUP = GROUPS.IDGROUP
	join FACULTY
	    on GROUPS.FACULTY = FACULTY.FACULTY
		    where FACULTY.FACULTY = @faculty);
return @rc;
end; 
go
declare @n int = dbo.COUNT_STUDENTS('ПИМ');
print 'Количество студентов: ' + cast(@n as varchar(4));



-- + @prof
go
alter function COUNT_STUDENTS(@faculty varchar(20) = null, @prof varchar(20) = null) returns int
as begin
declare @rc int = 0;
set @rc = (
SELECT count(IDSTUDENT) from FACULTY inner join GROUPS
	on FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT
		on GROUPS.IDGROUP = STUDENT.IDGROUP
			where FACULTY.FACULTY = @faculty and GROUPS.PROFESSION = ISNULL(@prof, GROUPS.PROFESSION));
return @rc;
end;
go
declare @n int = dbo.COUNT_STUDENTS('ПИМ', '1-36 06 01');
print 'Количество студентов: ' + cast(@n as varchar(4));





--2. Скалярную функцию FSUBJECTS, парам. @p (код кафедры = SUBJECT.PULPIT)
-- возвр. строку с пеерчнем дисциплин
go
create function FSUBJECTS(@p varchar(20)) returns varchar(300)
as begin
declare @sb varchar(10), @s varchar(100) = '';
declare sbj cursor local static
    for select distinct SUBJECT from SUBJECT 
	    where PULPIT like @p;
open sbj;
fetch sbj into @sb;
while @@FETCH_STATUS = 0
begin
	set @s = @s + RTRIM(@sb) + ', ';
	fetch sbj into @sb;
end;
return @s
end;

go 
select distinct PULPIT, dbo.FSUBJECTS(PULPIT)[Дисциплины] from SUBJECT;




--3. Табличная ф., парам: код фак + код кафедры
-- если оба парам NULL, возвр. список всех кафедр на фак
-- если второй NULL, возвр. все кафедры зад. фак
-- если первый NULL, возвр. строку, соотв-щую зад. кафедре
-- если оба не NULL, возвр. строку, соотв-щую зад. кафедре на зад. фак
-- если нельзя сформир. строки, возвр. пустой рез.набор
go
create function FFACPUL(@f varchar(20), @p varchar(20)) returns table
as return
select FACULTY.FACULTY, PULPIT.PULPIT from FACULTY left outer join PULPIT
  on FACULTY.FACULTY = PULPIT.FACULTY
   where FACULTY.FACULTY = ISNULL(@f, FACULTY.FACULTY) and --первое значение, не равное null
    PULPIT.PULPIT = ISNULL(@p, PULPIT.PULPIT);

go
select * from dbo.FFACPUL(null, null);
select * from dbo.FFACPUL('ТТЛП', null);
select * from dbo.FFACPUL(null, 'ТДП');
select * from dbo.FFACPUL('ТТЛП', 'ТДП');





--4. Скалярная ф., один парам (код кафедры)
-- возвр. кол-во преподов на зад.кафедре
-- если (NULL), возвр. общее кол-во преподавов
go
create function FCTEACHER(@p varchar(20)) returns int
as begin
declare @rc int = (select count(TEACHER) from TEACHER where PULPIT = ISNULL(@p, PULPIT));
return @rc;
end;

go 
select PULPIT, dbo.FCTEACHER(PULPIT)[Количество преподавателей] from TEACHER;
select dbo.FCTEACHER(null)[Общее количество преподавателей];

go
alter function FACULTY_REPORT(@c int) returns @fr table
	                        ( [Факультет] varchar(50), [Количество кафедр] int, [Количество групп]  int, 
	                                                                 [Количество студентов] int, [Количество специальностей] int )
	as begin 
                 declare cc CURSOR static for 
	       select FACULTY from FACULTY where dbo.COUNT_STUDENTS(FACULTY, NULL) > @c; 
	       declare @f varchar(30);
	       open cc;  
                 fetch cc into @f;
	       while @@fetch_status = 0
	       begin
	            insert @fr values( @f,  (select count(PULPIT) from PULPIT where FACULTY = @f),
	            (select count(IDGROUP) from GROUPS where FACULTY = @f),  dbo.COUNT_STUDENTS(@f, NULL),
	            (select count(PROFESSION) from PROFESSION where FACULTY = @f)   ); 
	            fetch cc into @f;  
	       end;   
                 return; 
	end;
go
	select* from  dbo.FACULTY_REPORT(20);

use G_MyBase
go

go
create function GET_BY_UNIVERSITY(@u varchar(20)) returns table
as return
SELECT * FROM Deliveries FULL OUTER JOIN Customers
on Customers.firm_name = Deliveries.customer
where Customers.firm_name = @u

go
select * from dbo.GET_BY_UNIVERSITY('BSU');