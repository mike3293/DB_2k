use LAB5_UNIVER

--1. Cписок дисциплин (краткие назв.) на ИСиТ
--из таблицы SUBJECT в одну строку через запятую (RTRIM)

DECLARE Subs CURSOR
	for SELECT SUBJECT from SUBJECT
	where PULPIT='ИСиТ'; 

DECLARE @sub char(4),
		@str char(100)=' '; 
OPEN Subs;  
	fetch  Subs into @sub;    
	print   'Дисциплины на кафедре ИСиТ:';   
	while @@fetch_status = 0                                   
	begin 
		set @str = rtrim(@sub)+', '+@str; -- удаляет пустые символы       
		fetch  Subs into @sub; 
	end;   
    print @str;        
CLOSE  Subs;
deallocate Subs; 


--2 Отличие глобального курсора от локального 
DECLARE aud0 CURSOR LOCAL for SELECT AUDITORIUM_NAME, AUDITORIUM_CAPACITY from AUDITORIUM;
DECLARE @name1 char(20), @cap1 real;      
OPEN aud0;	  
	fetch  aud0 into @name1, @cap1; 	
      print '1. '+@name1+cast(@cap1 as varchar(6));   
      go
 DECLARE @name1 char(20), @cap1 real;     	
	fetch  aud0 into @name1, @cap1; 	
      print '2. '+@name1+cast(@cap1 as varchar(6));  
  go   

  DECLARE aud1 CURSOR global  for SELECT AUDITORIUM_NAME, AUDITORIUM_CAPACITY from AUDITORIUM;
DECLARE @name2 char(20), @cap2 real;      
	OPEN aud1;	  
	fetch  aud1 into @name2, @cap2; 	
      print '1. '+@name2+cast(@cap2 as varchar(6));   
      go
 DECLARE @name2 char(20), @cap2 real;     	
	fetch  aud1 into @name2, @cap2; 	
      print '2. '+@name2+cast(@cap2 as varchar(6));  
  go   



--3. Отличие статических курсоров от динамических
DECLARE Studs CURSOR Local STATIC --DYNAMIC
	for SELECT NAME from STUDENT
	where IDGROUP = 3;		
		   
OPEN Studs;
print 'Кол-во строк : '+cast(@@CURSOR_ROWS as varchar(5)); 

DECLARE @name char(50);  
UPDATE STUDENT set IDGROUP=24 where IDGROUP=3;  
fetch  Studs into @name;     
while @@fetch_status = 0                                    
begin 
   print @name + ' ';      
   fetch Studs into @name; 
end;      
CLOSE  Studs;


UPDATE STUDENT set IDGROUP=3 where IDGROUP=24;
DEALLOCATE Studs 

   

--4 Демонстр свойства навигации в результиру-ющем наборе курсора с атрибутом SCROLL 
DECLARE  @t int, @rn char(50);  

DECLARE ScrollCur CURSOR LOCAL DYNAMIC SCROLL for 
		SELECT row_number() over (order by NAME), NAME from STUDENT where IDGROUP = 6 
OPEN ScrollCur;
	fetch FIRST from ScrollCur into  @t, @rn;                 
		print 'первая строка: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn);
	fetch NEXT from ScrollCur into  @t, @rn;                 
		print 'следующая строка: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn);      
	fetch LAST from  ScrollCur into @t, @rn;       
		print 'последняя строка: ' +  cast(@t as varchar(3))+ ' '+rtrim(@rn);   
	fetch PRIOR from ScrollCur into  @t, @rn;         --пред от текущей  
		print 'предыдущая строка: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn); 
	fetch ABSOLUTE 2 from ScrollCur into  @t, @rn;    -- от начала             
		print 'вторая строка: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn); 
	fetch RELATIVE 1 from ScrollCur into  @t, @rn;    -- от текущей          
		print 'третья строка: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn);         
CLOSE ScrollCur;



--5 Создать курсор, демонстрирующий применение конструкции CURRENT OF 
--в секции WHERE с исп UPDATE и DELETE.

INSERT FACULTY(FACULTY,FACULTY_NAME) VALUES (N'FIT',N'Факультет IT'); 

DECLARE cur CURSOR LOCAL SCROLL DYNAMIC
	for select f.FACULTY from FACULTY f 
	FOR UPDATE; 

DECLARE @s nvarchar(5); 
OPEN cur 
	fetch FIRST from cur into @s; 
	print 'исходная: ' + @s;
	update FACULTY set FACULTY = N'myFIT' where current of cur; 
	fetch FIRST from cur into @s;
	print 'изменённая: ' + @s;
	delete FACULTY where current of cur; 
GO 



--6. из PROGRESS удал строки о студентах с оц<4
DECLARE @name3 nvarchar(20), @n int;  

DECLARE Cur1 CURSOR LOCAL for 
SELECT NAME, NOTE from PROGRESS join STUDENT 
	on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		where NOTE<5

OPEN Cur1;  
    fetch  Cur1 into @name3, @n;  
	while @@fetch_status = 0
	begin 	
		print 'удаление: ' + @name3;
		delete PROGRESS where CURRENT OF Cur1;	
		fetch  Cur1 into @name3, @n;  
	end
CLOSE Cur1;

SELECT NAME, NOTE from PROGRESS join STUDENT
	on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		where NOTE<5

insert into PROGRESS (SUBJECT,IDSTUDENT,PDATE, NOTE)
    values 
           ('ОАиП', 1005,  '01.10.2013',4),
           ('СУБД', 1017,  '01.12.2013',4),
		   ('КГ',   1018,  '06.5.2013',4),
           ('ОХ',   1065,  '01.1.2013',4),
           ('ОХ',   1069,  '01.1.2013',4),
           ('ЭТ',   1058,  '01.1.2013',4)

-- увелиичть оценку на единицу
DECLARE @name4 char(20), @n3 int;  

SELECT NAME, NOTE from PROGRESS join STUDENT
	on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		where PROGRESS.IDSTUDENT=1000

DECLARE Cur2 CURSOR LOCAL for 
SELECT NAME, NOTE from PROGRESS join STUDENT
	on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		where PROGRESS.IDSTUDENT=1000
OPEN Cur2;  
    fetch  Cur2 into @name4, @n3; 
    UPDATE PROGRESS set NOTE=NOTE+1 where CURRENT OF Cur2;
CLOSE Cur2;

SELECT NAME, NOTE from PROGRESS join STUDENT
	on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT 
		where PROGRESS.IDSTUDENT=1000


-------------------------

use G_MyBase

DECLARE cur CURSOR LOCAL SCROLL DYNAMIC
	for select delivery_id, type from Deliveries 
	FOR UPDATE; 

DECLARE @id uniqueidentifier, @t nvarchar(5); 
OPEN cur 
	fetch FIRST from cur into @id, @t; 
	print 'исходная: '+ @t;
	print @id;
	update Deliveries set type = 'slow' where current of cur; 
	fetch FIRST from cur into @id,@t;
	print 'изменённая: ' + @t;
	print @id;
	update Deliveries set type = 'fast' where current of cur; 
GO 