use LAB5_UNIVER
-- 1

--drop table TR_AUDIT
go 
create table TR_AUDIT
(
ID int identity,
STMT varchar(20)
check (STMT in ('INS', 'DEL', 'UPD')),
TRNAME varchar(50),
CC varchar(300)
)
	go
    create  trigger TR_TEACHER_INS 
      on TEACHER after INSERT  
      as
      declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
      print 'Вставка';
      set @a1 = (select TEACHER from INSERTED);
      set @a2= (select TEACHER_NAME from INSERTED);
      set @a3= (select GENDER from INSERTED);
	  set @a4 = (select PULPIT from INSERTED);
      set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
      insert into TR_AUDIT(STMT, TRNAME, CC)  
                            values('INS', 'TR_TEACHER_INS', @in);	         
      return;  
      go

	  insert into  TEACHER values('Ри1', 'еаива', 'ж', 'ИСиТ');

	  select * from TR_AUDIT;

	  --2

 

go
    create  trigger TR_TEACHER_DEL 
      on TEACHER after DELETE  
      as
      declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
      print 'Удаление';
      set @a1 = (select TEACHER from DELETED);
      set @a2= (select TEACHER_NAME from DELETED);
      set @a3= (select GENDER from DELETED);
	  set @a4 = (select PULPIT from DELETED);
      set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
      insert into TR_AUDIT(STMT, TRNAME, CC)  
                            values('DEL', 'TR_TEACHER_DEL', @in);	         
      return;  
      go
	    delete TEACHER where TEACHER='Ри1';
	  select * from TR_AUDIT

	

--3

go
    Create  trigger TR_TEACHER_UPD 
      on TEACHER after UPDATE  
      as
      declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
	  declare @ins int = (select count(*) from inserted),
              @del int = (select count(*) from deleted); 

      print 'Изменение';
	  set @a1 = (select TEACHER from deleted);
      set @a2= (select TEACHER_NAME from DELETED);
      set @a3= (select GENDER from DELETED);
	  set @a4 = (select PULPIT from DELETED);
      set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4 + '->';
      set @a1 = (select TEACHER from INSERTED);
      set @a2= (select TEACHER_NAME from INSERTED);
      set @a3= (select GENDER from INSERTED);
	  set @a4 = (select PULPIT from INSERTED);
      set @in = @in + ' ' + @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
      insert into TR_AUDIT(STMT, TRNAME, CC)  
                            values('UPD', 'TR_TEACHER_UPD', @in);	         
      return;  
      go

	  update TEACHER set GENDER = 'ж' where TEACHER='Ри1';
	  select * from TR_AUDIT

	  delete from TR_AUDIT where STMT = 'UPD'

--4 
-- Совмещённый

go
create trigger TR_TEACHER   on TEACHER after INSERT, DELETE, UPDATE  
 as declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
	  declare @ins int = (select count(*) from inserted),
              @del int = (select count(*) from deleted); 
   if  @ins > 0 and  @del = 0
   begin
   print 'Событие: INSERT';
      set @a1 = (select TEACHER from INSERTED);
      set @a2= (select TEACHER_NAME from INSERTED);
      set @a3= (select GENDER from INSERTED);
	  set @a4 = (select PULPIT from INSERTED);
      set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
      insert into TR_AUDIT(STMT, TRNAME, CC)  
                            values('INS', 'TR_TEACHER', @in);	
	 end;
	else		  	 
    if @ins = 0 and  @del > 0
	begin
	print 'Событие: DELETE';
      set @a1 = (select TEACHER from DELETED);
      set @a2= (select TEACHER_NAME from DELETED);
      set @a3= (select GENDER from DELETED);
	  set @a4 = (select PULPIT from DELETED);
      set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
      insert into TR_AUDIT(STMT, TRNAME, CC)  
                            values('DEL', 'TR_TEACHER', @in);
	  end;
	else	  
    if @ins > 0 and  @del > 0
	begin
	print 'Событие: UPDATE'; 
	  set @a1 = (select TEACHER from deleted);
      set @a2= (select TEACHER_NAME from DELETED);
      set @a3= (select GENDER from DELETED);
	  set @a4 = (select PULPIT from DELETED);
      set @in = + @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
      set @a1 = (select TEACHER from INSERTED);
      set @a2= (select TEACHER_NAME from INSERTED);
      set @a3= (select GENDER from INSERTED);
	  set @a4 = (select PULPIT from INSERTED);
      set @in =@in + @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
      insert into TR_AUDIT(STMT, TRNAME, CC)  
                            values('UPD', 'TR_TEACHER', @in); 
	  end;
	  return;  

	  delete TEACHER where TEACHER='Ри1'
	  insert into  TEACHER values('Ри1', 'нгакг', 'м', 'ИСиТ');
	  update TEACHER set GENDER = 'ж' where TEACHER='Ри1';
	  select * from TR_AUDIT

	  -- 5, constraint
	  update TEACHER set GENDER = 'h' where TEACHER='Ри1'
 select * from TR_AUDIT


 drop trigger TR_TEACHER;
 drop trigger TR_TEACHER_INS;
 drop trigger TR_TEACHER_DEL;
 drop trigger TR_TEACHER_UPD;

 --6,создать три триггера
 drop trigger TR_TEACHER_DEL1;
 drop trigger TR_TEACHER_DEL2;
 drop trigger TR_TEACHER_DEL3;

 go
 create  trigger TR_TEACHER_DEL1 
      on TEACHER after DELETE  
      as
      declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
      print 'Удаление';
      set @a1 = (select TEACHER from DELETED);
      set @a2= (select TEACHER_NAME from DELETED);
      set @a3= (select GENDER from DELETED);
	  set @a4 = (select PULPIT from DELETED);
      set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
      insert into TR_AUDIT(STMT, TRNAME, CC)  
                            values('DEL', 'TR_TEACHER_DEL1', @in);	         
      return;

	  go
 create  trigger TR_TEACHER_DEL2 
      on TEACHER after DELETE  
      as
      declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
      print 'Удаление';
      set @a1 = (select TEACHER from DELETED);
      set @a2= (select TEACHER_NAME from DELETED);
      set @a3= (select GENDER from DELETED);
	  set @a4 = (select PULPIT from DELETED);
      set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
      insert into TR_AUDIT(STMT, TRNAME, CC)  
                            values('DEL', 'TR_TEACHER_DEL2', @in);	         
      return;

	  go
 create  trigger TR_TEACHER_DEL3 
      on TEACHER after DELETE  
      as
      declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
      print 'Удаление';
      set @a1 = (select TEACHER from DELETED);
      set @a2= (select TEACHER_NAME from DELETED);
      set @a3= (select GENDER from DELETED);
	  set @a4 = (select PULPIT from DELETED);
      set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
      insert into TR_AUDIT(STMT, TRNAME, CC)  
                            values('DEL', 'TR_TEACHER_DEL3', @in);	         
      return;


go
select t.name, e.type_desc 
  from sys.triggers  t join  sys.trigger_events e  on t.object_id = e.object_id  
  where OBJECT_NAME(t.parent_id)='TEACHER' and e.type_desc = 'DELETE' ;  

exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL3', 
	                        @order='First', @stmttype = 'DELETE';
exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL2', 
	                        @order='Last', @stmttype = 'DELETE';

--7
  go 
	create trigger PTran 
	on TEACHER after INSERT
	as declare @a1 char(10) = (select TEACHER from INSERTED);	 
	 if (@a1 = 'not') 
	 begin
       raiserror('name not', 10, 1);
	 rollback; 
	 end; 
	 return;          

	insert into TEACHER values ('not', 'нгакг', 'м', 'ИСиТ');
	select * from TEACHER;

--8
	go 
	create trigger F_INSTEAD_OF 
	on FACULTY instead of DELETE 
	as 
raiserror(N'Удаление запрещено', 10, 1);
	return;

	 delete FACULTY where FACULTY = 'ИТ'

	 drop trigger F_INSTEAD_OF;
	 drop trigger PTran;
	 drop trigger TR_TEACHER;
 drop trigger TR_TEACHER_INS;
 drop trigger TR_TEACHER_DEL;
 drop trigger TR_TEACHER_UPD;
 drop trigger TR_TEACHER_DEL1;
 drop trigger TR_TEACHER_DEL2;
 drop trigger TR_TEACHER_DEL3;

 -- 9
	 go	
 create trigger DDL_AUDITORIUMTYPE on database 
                          for DDL_DATABASE_LEVEL_EVENTS  as   
  declare @t varchar(50) =  EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)');
  declare @t1 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)');
  declare @t2 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)'); 
  if @t1 = 'AUDITORIUM_TYPE' 
  begin
       print 'Тип события: '+@t;
       print 'Имя объекта: '+@t1;
       print 'Тип объекта: '+@t2;
       raiserror( N'операции с таблицей AUDITORIUM_TYPE запрещены', 16, 1);  
       rollback;    
   end;

   alter table AUDITORIUM_TYPE Drop Column  AUDITORIUM_TYPENAME;


   -----
   use G_MyBase
   go 
	create trigger DEL_DELIVERY_INSTEAD_OF 
	on Deliveries instead of DELETE 
	as 
	raiserror(N'Удаление запрещено', 10, 1);
	return;

	 delete Deliveries where customer = 'BSU'

	 go
    create  trigger DELIVERY_UPD 
      on Deliveries after update  
      as
      print 'Обновление';
      select *, 'Обновление' from DELETED;      
      select *, 'Обновление' from INSERTED;      
      return;  

	  update  Deliveries set amount = 5 where delivery_id='6F9619FF-8B86-D011-B42D-00CF4FC964F5';