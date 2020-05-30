use LAB5_UNIVER
go

--1. хранимая проц. без парам, форм. рез.набор на основк SUBJECT
--к точке вызова процедура д. возвр кол-во строк, выведенных в рез.набор

CREATE procedure PSUBJECT
as begin
	DECLARE @n int = (SELECT count(*) from SUBJECT);
	SELECT SUBJECT [КОД], SUBJECT_NAME [ДИСЦИПЛИНА], PULPIT [КАФЕДРА] from SUBJECT;
	return @n;
end;
-- сохраняется в БД

DECLARE @k int;
EXEC @k = PSUBJECT; -- вызов процедуры 
print 'Количество предметов: ' + cast(@k as varchar(3));
go
DROP procedure PSUBJECT;



--2. Изм., чтобы принимала параметры @p (вх. - код кафедры), @c (вых. - кол-во)
USE [LAB5_UNIVER]
GO

/****** Object:  StoredProcedure [dbo].[PSUBJECT]    Script Date: 07.05.2020 19:44:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[PSUBJECT] @p varchar(20), @c nvarchar(2) output
as begin
	DECLARE @n int = (SELECT count(*) from SUBJECT);
	SELECT * from SUBJECT where SUBJECT = @p;
	set @c = cast(@@rowcount as nvarchar(2));
	return cast(@n as nvarchar(3));
end;

DECLARE @k nvarchar(3), @k2 nvarchar(2);
EXEC @k = PSUBJECT @p = 'СУБД', @c = @k2 output;
print @k2 + '/' + @k;
GO


--3. созд. врем.лок.табл, столбцы как в рез.наборе 2
--изм. PSUBJECT, убрать @c, добав. ее строки в #SUBJECT

ALTER procedure PSUBJECT @p varchar(20)
as begin
	SELECT * from SUBJECT where SUBJECT = @p;
end;


CREATE table #SUBJECTs
(
	Код_предмета varchar(20),
	Название_предмета varchar(100),
	Кафедра varchar(20)
);
INSERT #SUBJECTs EXEC PSUBJECT @p = 'ПСП';
INSERT #SUBJECTs EXEC PSUBJECT @p = 'СУБД';
SELECT * from #SUBJECTs;
go

drop table #SUBJECTs



--4. Процедура 4 вх.парам (значения столбцов), доб. строку в табл.AUDITORIUM
go
CREATE procedure PAUDITORIUM_INSERT
		@a char(20),
		@n varchar(50),
		@c int = 0,
		@t char(10)
as begin 
begin try
	INSERT into AUDITORIUM(AUDITORIUM, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY, AUDITORIUM_NAME)
		values(@a, @n, @c, @t);
		--values(433-1, 'ЛК', 433-1, 100);
	return 1;
end try
begin catch
	print 'Номер ошибки: ' + cast(error_number() as varchar(6));
	print 'Сообщение: ' + error_message();
	print 'Уровень: ' + cast(error_severity() as varchar(6));
	print 'Метка: ' + cast(error_state() as varchar(8));
	print 'Номер строки: ' + cast(error_line() as varchar(8));
	if error_procedure() is not null   
	print 'Имя процедуры: ' + error_procedure();
	return -1;
end catch;
end;


DECLARE @rc int;  
EXEC @rc = PAUDITORIUM_INSERT @a = '420-3', @n = 'ЛК', @c = 100, @t = '420-3'; 
print 'Код состояния: ' + cast(@rc as varchar(3));
go

delete AUDITORIUM where AUDITORIUM='420-3';



--5. форм. список дисциплин на отд.кафедре
--краткие назв. в строку через зап.(RTRIM)
go
create procedure SUBJECT_REPORT  @p CHAR(50)
   as  
   declare @rc int = 0;                            
   begin try    
      declare @tv char(20), @t char(300) = ' ';  
      declare ZkSub CURSOR  for 
      select SUBJECT from SUBJECT where Pulpit = @p;
      if not exists (select SUBJECT from SUBJECT where Pulpit = @p)
          raiserror('ошибка', 11, 1);
       else 
      open ZkSub;	  
  fetch  ZkSub into @tv;   
  print   'Предмет';   
  while @@fetch_status = 0                                     
   begin 
       set @t = rtrim(@tv) + ', ' + @t;  
       set @rc = @rc + 1;       
       fetch  ZkSub into @tv; 
    end;   
print @t;        
close  ZkSub;
    return @rc;
   end try  
   begin catch              
        print 'ошибка в параметрах' 
        if error_procedure() is not null   
  print 'имя процедуры : ' + error_procedure();
        return @rc;
   end catch; 
   go

declare @rc int;  
exec @rc = SUBJECT_REPORT @p  = 'ИСиТ';  
print 'количество предметов = ' + cast(@rc as varchar(3)); 

drop procedure SUBJECT_REPORT;




--6. Проц. доб. 2 строки: в табл.AUD_TYPE(@t, @tn) + путем вызова PAUD_INSERT
--все в рамках явной транзакции с ур.изол.SERIALIZABLE
go
CREATE procedure PAUDITORIUM_INSERTX
		@a char(20),
		@n varchar(50),
		@c int = 0,
		@t char(10),
		@tn varchar(50)	--доп., для ввода в AUD_TYPEAUD_TYPENAME
as begin
DECLARE @rc int = 1;
begin try
	set transaction isolation level serializable;          
	begin tran
	INSERT into AUDITORIUM_TYPE(AUDITORIUM_TYPE, AUDITORIUM_TYPENAME)
				values(@n, @tn);
	EXEC @rc = PAUDITORIUM_INSERT @a, @n, @c, @t;
	commit tran;
	return @rc;
end try
begin catch
	print 'Номер ошибки: ' + cast(error_number() as varchar(6));
	print 'Сообщение: ' + error_message();
	print 'Уровень: ' + cast(error_severity() as varchar(6));
	print 'Метка: ' + cast(error_state() as varchar(8));
	print 'Номер строки: ' + cast(error_line() as varchar(8));
	if error_procedure() is not  null   
	print 'Имя процедуры: ' + error_procedure(); 
	if @@trancount > 0 rollback tran ; 
	return -1;
end catch;
end;


DECLARE @k3 int;  
EXEC @k3 = PAUDITORIUM_INSERTX '622-3', @n = 'КГ', @c = 85, @t = '622-3', @tn = 'Комп. гласс'; 
print 'Код состояния: ' + cast(@k3 as varchar(3));

select * from AUDITORIUM where AUDITORIUM='622-3'; 
delete AUDITORIUM where AUDITORIUM='622-3';  
delete AUDITORIUM_TYPE where AUDITORIUM_TYPE='КГ';
go

drop procedure PAUDITORIUM_INSERTX;