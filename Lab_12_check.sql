use LAB5_UNIVER;


--1-- ����� ������� ����������
-- ���������� ����������, ���� ����������� ���� �� ��������� ����������: 
-- CREATE, DROP; ALTER TABLE; INSERT, DELETE, UPDATE, SELECT, TRUNCATE TABLE; OPEN, FETCH; GRANT; REVOKE 
-- ������� ���������� ������������ �� ��� ���, ���� �� ����� �������� COMMIT ��� ROLLBACK

set nocount on -- �� ������� ���-�� ���������� �����
if  exists (select * from  SYS.OBJECTS 
         where OBJECT_ID=object_id(N'DBO.TAB')) 
	drop table TAB;           
declare @c int, @flag char = 'c'; -- ���� �->r, ������� �� ����

SET IMPLICIT_TRANSACTIONS ON -- ��� ����� ������� ����������
	create table TAB(K int );                   
	insert TAB values (1),(2),(3),(4),(5);
	set @c = (select count(*) from TAB);
	print '���-�� ����� � TAB: ' + cast(@c as varchar(2));
	if @flag = 'c' commit  -- �������� 
		else rollback;     -- �����                           
SET IMPLICIT_TRANSACTIONS OFF -- ��������� ����� ������������


if  exists (select * from  SYS.OBJECTS 
          where OBJECT_ID= object_id(N'DBO.TAB')) print '������� TAB ����';  
else print '������� TAB ���'







--2-- �������� ����������� ����� ����������
begin try        
	begin tran                 -- ������  ����� ����������
		insert FACULTY values ('��', '��������� ������ ����');
	    insert FACULTY values ('���', '��������� �����-����������');
	commit tran;               -- �������� ����������
end try

begin catch
	print '������: '+ case 
		when error_number() = 2627 and patindex('%FACULTY_PK%', error_message()) > 0 then '������������ '	--������� 1-�� ���������
		else '����������� ������: '+ cast(error_number() as  varchar(5))+ error_message()  
	end;
	if @@trancount > 0 rollback tran; -- ��.����������� ��.>0,  ����� �� ��������� 	  
end catch;
 
DELETE FACULTY WHERE FACULTY = '��';
DELETE FACULTY WHERE FACULTY = '���';

select * from FACULTY;





--3-- �������� SAVETRAN
-- ���� ���������� ���� �� ���� ������� ������ ���������� T-SQL, �� ���.
-- SAVE TRANSACTION, ������ �����.����� ����������

declare @point varchar(32);
 
begin try
	begin tran                              
		delete AUDITORIUM where AUDITORIUM_CAPACITY =100;
		set @point = 'p1'; 
		save tran @point;  -- ����������� ����� p1
insert AUDITORIUM values ('120-1', '��-�', 40,'120-1');

		set @point = 'p2'; 
		save tran @point; -- ����������� ����� p2 (������������, ������� ��-�������)

insert AUDITORIUM values ('413-1', '��', 140,'413-1');
	commit tran;                                              
end try
begin catch
	print '������: '+ case 
		when error_number() = 2627 and patindex('%AUDITORIUM_PK%', error_message()) > 0 then '������������ ���������' 
		else '����������� ������: '+ cast(error_number() as  varchar(5)) + error_message()  
	end; 
    if @@trancount > 0 -- ���� ���������� �� ��������� //������� �����������
	begin
	   print '����������� �����: '+ @point;
	   rollback tran @point; -- ����� � ��������� ����������� �����
	   commit tran; -- �������� ���������, ����������� �� ����������� ����� 
	end;     
end catch;

select * from AUDITORIUM; 
delete AUDITORIUM where AUDITORIUM='120-1'; 


--4.
--�������� A - ����� ���������� � ������� ��������������� READ UNCOMMITED,
--���. ������ �����������, ��������. � ��������� ������
--�������� B � ����� ���������� � ������� ��������������� READ COMMITED (�� �����) 

--READ UNCOMMITTED 
--��������� ����� ������ ������, ����������, �� �� ���������� ��.������������

--READ COMMITTED 
--��������� �� ����� ������ ������, ����������, �� �� ����������� ��.������������
-- ��� ������������� ������� ������.

insert AUDITORIUM values ('410-1', '��', 140,'413-1');
	set transaction isolation level READ UNCOMMITTED 
	begin transaction 
	-------------------------- t1 ------------------
	select @@SPID, 'insert AUditorium type' '���������', * from AUDITORIUM_TYPE
	                                                                where AUDITORIUM_TYPE = 'SM';
	select @@SPID, 'update AUDITORIUM'  '���������',  * from AUDITORIUM   where AUDITORIUM_TYPE = 'SM';
	commit; 
	-------------------------- t2 -----------------
	--- B --	
	begin transaction 
	select @@SPID
	insert AUDITORIUM_TYPE values ('SM','Something'); 
	update AUDITORIUM set AUDITORIUM_TYPE  =  'SM' 
                           where AUDITORIUM_TYPE = '��' 
	-------------------------- t1 --------------------
	-------------------------- t2 --------------------
	rollback;

	update AUDITORIUM set AUDITORIUM_TYPE  =  '��' 
                           where AUDITORIUM_TYPE = 'SM' 
	delete AUDITORIUM_TYPE where AUDITORIUM_TYPE = 'SM'
	select * from AUDITORIUM




--5. ����������� ��� �����-���: A � B �� ������� ���� ������ X_BSTU. 
--�������� A ������������ ����� ����� ���������� � ������� ��������������� READ COMMITED. 
--�������� B � ����� ���������� � ������� ��������������� READ COMMITED. 
--�������� A ������ ���������������, ��� ������� READ COMMITED �� ��������� ����������������� ������, 
--�� ��� ���� ��������  ��������������� � ��������� ������. 

-----A--------
--set transaction isolation level REPEATABLE READ -- � ���������� ���������� B ����� ����� A
set transaction isolation level SERIALIZABLE
SELECT * from PULPIT;
begin transaction
select count(*) from PULPIT
where FACULTY = '��'; --��������� ���� ��������, ����� ��������� 0

-----t1-------
-----t2-------

select 'update PULPIT' '���������', count(*) --����� ��������� 1, �.�. ��������� ���������
from PULPIT where FACULTY = '��'; --�������� ��������������� ������
commit;
------B----

begin transaction

------t1-----

update PULPIT set FACULTY = '���' where PULPIT = '����';
commit;

------t2------
update PULPIT set FACULTY = '��' where PULPIT = '����';

-- ����������� ��� �����-���: A � B �� ������� ���� ������ X_BSTU. 
--�������� A ������������ ����� ����� ���������� � ������� ��������������� REPEATABLE READ. 
--���-����� B � ����� ���������� � ������� ��������������� READ COMMITED. 

--------A---------
-- ����� ����������
--------B---------
begin transaction
--------t1---------
insert PULPIT values('test', 'test', '��')
commit
--------t2---------
delete PULPIT where PULPIT = 'test'

-- ��������� ����������
-- ����������, ������������� � ������ ������ ����������, ���������� ���������. 
-- �������� COMMIT ��������� ���������� ��������� ������ �� ���������� �������� ��������� ����������; 
-- �������� ROLLBACK ������� ���������� �������� ��������������� �������� ���������� ����������; 
-- �������� ROLLBACK ��������� ���������� ��������� �� ���-����� ������� � ���������� ����������, 
-- � ����� ��������� ��� ����������; 
-- ������� ����������� ���������� ����� ���������� � ������� ��������� ������� @@TRANCOUT. 

select (select count(*) from dbo.PULPIT where FACULTY = '����') '������� ����'

select * from PULPIT

begin tran
	begin tran
	update PULPIT set PULPIT_NAME='������� ����' where PULPIT.FACULTY = '����';
	commit;
if @@TRANCOUNT > 0 rollback;

-- ����� ���������� ���������� ����������� ��������� ����� ��������; 
-- �������� ROLLBACK ������� ���������� �������� ��������������� �������� ���������� ����������. 