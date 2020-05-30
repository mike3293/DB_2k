use LAB5_UNIVER;


--1-- РЕЖИМ НЕЯВНОЙ ТРАНЗАКЦИИ
-- транзакция начинается, если выполняется один из следующих операторов: 
-- CREATE, DROP; ALTER TABLE; INSERT, DELETE, UPDATE, SELECT, TRUNCATE TABLE; OPEN, FETCH; GRANT; REVOKE 
-- неявная транзакция продолжается до тех пор, пока не будет выполнен COMMIT или ROLLBACK

set nocount on -- не выводит кол-во затронутых строк
if  exists (select * from  SYS.OBJECTS 
         where OBJECT_ID=object_id(N'DBO.TAB')) 
	drop table TAB;           
declare @c int, @flag char = 'c'; -- если с->r, таблица не сохр

SET IMPLICIT_TRANSACTIONS ON -- вкл режим неявной транзакции
	create table TAB(K int );                   
	insert TAB values (1),(2),(3),(4),(5);
	set @c = (select count(*) from TAB);
	print 'кол-во строк в TAB: ' + cast(@c as varchar(2));
	if @flag = 'c' commit  -- фиксация 
		else rollback;     -- откат                           
SET IMPLICIT_TRANSACTIONS OFF -- действует режим автофиксации


if  exists (select * from  SYS.OBJECTS 
          where OBJECT_ID= object_id(N'DBO.TAB')) print 'таблица TAB есть';  
else print 'таблицы TAB нет'







--2-- СВОЙСТВО АТОМАРНОСТИ ЯВНОЙ ТРАНЗАКЦИИ
begin try        
	begin tran                 -- начало  явной транзакции
		insert FACULTY values ('ДФ', 'Факультет других наук');
	    insert FACULTY values ('ПиМ', 'Факультет принт-технологий');
	commit tran;               -- фиксация транзакции
end try

begin catch
	print 'ошибка: '+ case 
		when error_number() = 2627 and patindex('%FACULTY_PK%', error_message()) > 0 then 'дублирование '	--позиция 1-го вхождения
		else 'неизвестная ошибка: '+ cast(error_number() as  varchar(5))+ error_message()  
	end;
	if @@trancount > 0 rollback tran; -- ур.вложенности тр.>0,  транз не завершена 	  
end catch;
 
DELETE FACULTY WHERE FACULTY = 'ДФ';
DELETE FACULTY WHERE FACULTY = 'ПиМ';

select * from FACULTY;





--3-- ОПЕРАТОР SAVETRAN
-- если транзакция сост из неск независ блоков операторов T-SQL, то исп.
-- SAVE TRANSACTION, формир контр.точку транзакции

declare @point varchar(32);
 
begin try
	begin tran                              
		delete AUDITORIUM where AUDITORIUM_CAPACITY =100;
		set @point = 'p1'; 
		save tran @point;  -- контрольная точка p1
insert AUDITORIUM values ('120-1', 'ЛК-К', 40,'120-1');

		set @point = 'p2'; 
		save tran @point; -- контрольная точка p2 (перезаписали, назвали по-другому)

insert AUDITORIUM values ('413-1', 'ЛБ', 140,'413-1');
	commit tran;                                              
end try
begin catch
	print 'ошибка: '+ case 
		when error_number() = 2627 and patindex('%AUDITORIUM_PK%', error_message()) > 0 then 'дублирование аудитории' 
		else 'неизвестная ошибка: '+ cast(error_number() as  varchar(5)) + error_message()  
	end; 
    if @@trancount > 0 -- если транзакция не завершена //уровень вложенности
	begin
	   print 'контрольная точка: '+ @point;
	   rollback tran @point; -- откат к последней контрольной точке
	   commit tran; -- фиксация изменений, выполненных до контрольной точки 
	end;     
end catch;

select * from AUDITORIUM; 
delete AUDITORIUM where AUDITORIUM='120-1'; 


--4.
--Сценарий A - явную транзакцию с уровнем изолированности READ UNCOMMITED,
--кот. допуск неподтвержд, неповтор. и фантомное чтение
--сценарий B – явную транзакцию с уровнем изолированности READ COMMITED (по умолч) 

--READ UNCOMMITTED 
--операторы могут читать строки, измененные, но не выполненые др.транзакциями

--READ COMMITTED 
--операторы не могут читать данные, измененные, но не выполненные др.транзакциями
-- Это предотвращает грязные чтения.

insert AUDITORIUM values ('410-1', 'ЛК', 140,'413-1');
	set transaction isolation level READ UNCOMMITTED 
	begin transaction 
	-------------------------- t1 ------------------
	select @@SPID, 'insert AUditorium type' 'результат', * from AUDITORIUM_TYPE
	                                                                where AUDITORIUM_TYPE = 'SM';
	select @@SPID, 'update AUDITORIUM'  'результат',  * from AUDITORIUM   where AUDITORIUM_TYPE = 'SM';
	commit; 
	-------------------------- t2 -----------------
	--- B --	
	begin transaction 
	select @@SPID
	insert AUDITORIUM_TYPE values ('SM','Something'); 
	update AUDITORIUM set AUDITORIUM_TYPE  =  'SM' 
                           where AUDITORIUM_TYPE = 'ЛК' 
	-------------------------- t1 --------------------
	-------------------------- t2 --------------------
	rollback;

	update AUDITORIUM set AUDITORIUM_TYPE  =  'ЛК' 
                           where AUDITORIUM_TYPE = 'SM' 
	delete AUDITORIUM_TYPE where AUDITORIUM_TYPE = 'SM'
	select * from AUDITORIUM




--5. Разработать два сцена-рия: A и B на примере базы данных X_BSTU. 
--Сценарий A представляет собой явную транзакцию с уровнем изолированности READ COMMITED. 
--Сценарий B – явную транзакцию с уровнем изолированности READ COMMITED. 
--Сценарий A должен демонстрировать, что уровень READ COMMITED не допускает неподтвержденного чтения, 
--но при этом возможно  неповторяющееся и фантомное чтение. 

-----A--------
--set transaction isolation level REPEATABLE READ -- в результате транзакция B будет ждать A
set transaction isolation level SERIALIZABLE
SELECT * from PULPIT;
begin transaction
select count(*) from PULPIT
where FACULTY = 'ИТ'; --Указывает одно значение, видим результат 0

-----t1-------
-----t2-------

select 'update PULPIT' 'результат', count(*) --здесь результат 1, т.к. произошло изменение
from PULPIT where FACULTY = 'ИТ'; --работает неповторяющееся чтение
commit;
------B----

begin transaction

------t1-----

update PULPIT set FACULTY = 'ПиМ' where PULPIT = 'ИСиТ';
commit;

------t2------
update PULPIT set FACULTY = 'ИТ' where PULPIT = 'ИСиТ';

-- Разработать два сцена-рия: A и B на примере базы данных X_BSTU. 
--Сценарий A представляет собой явную транзакцию с уровнем изолированности REPEATABLE READ. 
--Сце-нарий B – явную транзакцию с уровнем изолированности READ COMMITED. 

--------A---------
-- взять предыдущее
--------B---------
begin transaction
--------t1---------
insert PULPIT values('test', 'test', 'ИТ')
commit
--------t2---------
delete PULPIT where PULPIT = 'test'

-- ВЛОЖЕННЫЕ ТРАНЗАКЦИИ
-- Транзакция, выполняющаяся в рамках другой транзакции, называется вложенной. 
-- оператор COMMIT вложенной транзакции действует только на внутренние операции вложенной транзакции; 
-- оператор ROLLBACK внешней транзакции отменяет зафиксированные операции внутренней транзакции; 
-- оператор ROLLBACK вложенной транзакции действует на опе-рации внешней и внутренней транзакции, 
-- а также завершает обе транзакции; 
-- уровень вложенности транзакции можно определить с помощью системной функции @@TRANCOUT. 

select (select count(*) from dbo.PULPIT where FACULTY = 'ТТЛП') 'Кафедры ТТЛП'

select * from PULPIT

begin tran
	begin tran
	update PULPIT set PULPIT_NAME='Кафедра ТТЛП' where PULPIT.FACULTY = 'ТТЛП';
	commit;
if @@TRANCOUNT > 0 rollback;

-- Здесь внутренняя транзакция завершается фиксацией своих операций; 
-- оператор ROLLBACK внешней транзакции отменяет зафиксированные операции внутренней транзакции. 