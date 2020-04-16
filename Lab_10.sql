use TMPS_UNIVER

exec sp_helpindex 'auditorium_type'
exec sp_helpindex 'auditorium'
exec sp_helpindex 'faculty'
exec sp_helpindex 'groups'
exec sp_helpindex 'profession'
exec sp_helpindex 'progress'
exec sp_helpindex 'pulpit'
exec sp_helpindex 'student'
exec sp_helpindex 'subject'
exec sp_helpindex 'teacher'

create table #example
(
	id int,
	fild1 int,
	fild2 varchar(100)
);

set nocount on;
declare @i int = 0;
while @i<1000
begin 
insert #example(id,fild1,fild2)
	values(floor(30000*rand()), floor(10*rand()),replicate('string',10));
set @i=@i+1;
end;


--------------ctrl+l посмотреть стоимость запроса
select * from #example where id between 3000 and 10000 order by id

checkpoint;
dbcc dropcleanbuffers;

create clustered index #example_cl on #example(id asc)


----------------------------------------------------

create table #example2
(
	id int,
	fild1 int identity(1,1),
	fild2 varchar(100)
);

set nocount on;
declare @i int = 0;
while @i<10000
begin 
insert #example2(id,fild2)
	values(floor(30000*rand()), replicate('string',3));
set @i=@i+1;
end;


select count(*)[count] from #example2
select * from #example2

create index #example2_nonclu on #example2(id,fild1)
--drop index #example2_nonclu on #example2


select *from #example2 where id>1500 and fild1<5000
select * from #example2 order by id, fild1

select * from #example2 where id=20672 and fild1<5000

-------------------------------------------------

create table #example3
(
	id int,
	fild1 int identity(1,1),
	fild2 varchar(100)
);

set nocount on;
declare @i int = 0;
while @i<10000
begin 
insert #example3(id,fild2)
	values(floor(30000*rand()), replicate('string',3));
set @i=@i+1;
end;


select * from #example3

select fild1 from #example3 where id>2000  --0.0513/0.0327

create index #example3_id_x on #example3(id) include(fild1)


-------------------------------------------------------


create table #example4
(
	id int,
	fild1 int identity(1,1),
	fild2 varchar(100)
);

set nocount on;
declare @i int = 0;
while @i<10000
begin 
insert #example4(id,fild2)
	values(floor(30000*rand()), replicate('string',3));
set @i=@i+1;
end;


select id from #example4 where id between 15000 and 24999  ---0.0513/0.01148
select id from #example4 where id>15000 and id<25000   ----0.0513/0.0155
select id from #example4 where id=21830   ----0.0513/0.00328

create index #example4_where on #example4(id) where(id>=1500 and id<25000)



--------------------------------------

create table #example5
(
	id int,
	fild1 int identity(1,1),
	fild2 varchar(100)
);

set nocount on;
declare @i int = 0;
while @i<1000
begin 
insert #example5(id,fild2)
	values(floor(30000*rand()), replicate('string',3));
set @i=@i+1;
end;

ALTER index #example5_id on #example5 reorganize;
ALTER index #example5_id on #example5 rebuild with (online = off);

create index #example5_id on #example5(id)

-------------???????????????????????????
use tempdb;
SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
        FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), 
        OBJECT_ID(N'#example5'), NULL, NULL, NULL) ss
        JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id  
                                                             WHERE name is not null;
----------------------------------------



create table #example6
(
	id int,
	fild1 int identity(1,1),
	fild2 varchar(100)
);


set nocount on;
declare @i int = 0;
while @i<1000
begin 
insert #example6(id,fild2)
	values(floor(30000*rand()), replicate('string',3));
set @i=@i+1;
end;


create index #example6_id on #example6(id) with(fillfactor = 65)


use #example6;
------------------?????????????????????????
use tempdb;
SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
       FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'),    
       OBJECT_ID(N'#EXAMPLE6'), NULL, NULL, NULL) ss  JOIN sys.indexes ii 
                        ON ss.object_id = ii.object_id and ss.index_id = ii.index_id  
                                                            WHERE name is not null;


