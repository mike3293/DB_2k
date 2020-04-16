USE LAB5_UNIVER

declare @c char='c',
		@v varchar='char',
		@d datetime,
		@time time,
		@time2 time;
	set	@d=getdate();
	set	@time=SYSDATETIME();
	set	@time2 = GETDATE();


declare @numeric numeric(12,5)=(select CAST(SUM(NOTE) as numeric(12,5)) from PROGRESS)
declare @int int = (select cast(AVG(AUDITORIUM_CAPACITY) as int) from AUDITORIUM)
declare @tinyint tinyint = (select CAST(COUNT(*) as tinyint) from FACULTY)
declare @smallint smallint = (select CAST(COUNT(*) as smallint) from PULPIT)

select @numeric,@c, @v,@d,@time;
print 'time2=' +cast(@time2 as varchar(10));
print 'int=' +cast(@int as varchar(10));
print 'tinyint=' +cast(@tinyint as varchar(10));
print 'smallint=' +cast(@smallint as varchar(10));


--------------------

declare @y1 numeric(8,3)=(select CAST(SUM(AUDITORIUM_CAPACITY)as numeric) from AUDITORIUM), @y2 int, @y3 real, @y4 int, @y5 real
if @y1>200
begin
	select @y2 = (select CAST(COUNT(*) as numeric(8,3)) from AUDITORIUM),
		   @y3 = (select CAST(AVG(AUDITORIUM_CAPACITY) as numeric(8,3)) from AUDITORIUM)
	   set @y4 = (select CAST(COUNT(*) as numeric(8,3)) from AUDITORIUM where AUDITORIUM_CAPACITY<@y3);
	   set @y5 = (select cast(100*@y4/@y2 as nvarchar(10)))
	select @y1 '����� �����������', @y2 '���������� ���������', @y3 '������� �����������', @y4 '����������� ������ �������', @y5 '�������'
end
else print '����� ����������� '+cast(@y1 as nvarchar(10))


------------------------

 print '����� ������������ �����          : '+ cast(@@rowcount as varchar(12)); 
 print '������ SQL Server         : '+ cast(@@version as varchar(12));
 print '��������� ������������� ��������, ����������� �������� �������� �����������: '+ 
		cast(@@spid as varchar(12)); 
 print '��� ��������� ������            : '+ cast(@@error as varchar(12));
 print '��� �������   : '+ cast(@@servername as varchar(12));
 print '������� ����������� ����������           : '+ cast(@@trancount as varchar(12));
 print '�������� ���������� ���������� ����� ��������������� ������           : '+ cast(@@fetch_status as varchar(12));
 print '������� ����������� ������� ���������           : '+ cast(@@nestlevel as varchar(12));


 ------------------------


declare @t int=10, @x int =100, @z float;
	if (@t>@x) set @z=sin(@t)*sin(@t);
	else if (@t<@x) set @z=4*(@t+@x);
	else if(@t=@x) set @z=1-exp(@x-2);
print 'z='+cast(@z as varchar(10));


declare @l nvarchar(15)='�������', @k nvarchar(15)='���', @m nvarchar(15)='��������';
print @l+' '+substring(@k, 1,1)+'.'+substring(@m, 1,1) +'.'


declare @month nvarchar(10) = '05';
select [name], bday,2020 - cast(substring(Cast(BDAY as nvarchar(10)),1,4) as int) as AGE from STUDENT
where substring(Cast(BDAY as nvarchar(10)),6,2) = @month;



-- ����� ��� ������, � ������� �������� ��������� ������ ������� ������� �� ����.


--------------------------

declare @x1 int=(select count(*) from AUDITORIUM);
if(select count(*) from AUDITORIUM)>5
begin
print '���������� ��������� ������ 5';
print '����������='+cast(@x1 as varchar(10));
end;
else
begin
print '���������� ��������� ������ 5';
print '����������='+cast(@x1 as varchar(10));
end;


--------------------------


select case
		when NOTE between 0 and 3 then '�����'
		when NOTE between 4 and 7 then '���������'
		when NOTE between 8 and 9 then '������'
		else '�������'
		end NOTE, count(*)[COUNT]
	from PROGRESS
	group by case
		when NOTE between 0 and 3 then '�����'
		when NOTE between 4 and 7 then '���������'
		when NOTE between 8 and 9 then '������'
		else '�������'
		end

--------------------------


create table #example
(
	id int,
	fild1 int,
	fild2 varchar(100)
);
 

set nocount on;
declare @i int = 0;
while @i<10
begin 
insert #example(id,fild1,fild2)
	values(floor(30000*rand()), floor(10*rand()),replicate('string',10));
set @i=@i+1;
end;

select * from #example



-------------------------

go
declare @x int = 1
	print @x+1
	print @x+2
	return
	print @x+3


--------------------------


begin try	
	update dbo.TEACHER set GENDER = 7
		where GENDER = 1
end try
begin catch
	print error_number()
	print error_message()
	print error_line()
	print error_procedure()
	print error_severity()
	print error_state()
end catch