use LAB5_UNIVER;


select min(AUDITORIUM_CAPACITY)[min],
	   max(AUDITORIUM_CAPACITY)[max],
	   avg(AUDITORIUM_CAPACITY)[avg],
	   sum(AUDITORIUM_CAPACITY)[sum],
	   count(*)[count]
from AUDITORIUM



select AUDITORIUM_TYPE.AUDITORIUM_TYPENAME,
	max(AUDITORIUM_CAPACITY)[max],
	min(AUDITORIUM_CAPACITY)[min],
	avg(AUDITORIUM_CAPACITY)[avg],
	sum(AUDITORIUM_CAPACITY)[sum],
	count(*)[count]
from AUDITORIUM inner join AUDITORIUM_TYPE
	on AUDITORIUM.AUDITORIUM_TYPE=AUDITORIUM_TYPE.AUDITORIUM_TYPE
	group by AUDITORIUM_TYPE.AUDITORIUM_TYPENAME


select *
from (select case 
				when note=10 then '10'
				when note between 8 and 9 then '8-9'
				when note between 6 and 7 then '6-7'
				when note between 4 and 5 then '4-5'
				else '<4'
				end [оценки],
				count(*)[количество]
		from PROGRESS group by case
								when note=10 then '10'
								when note between 8 and 9 then '8-9'
								when note between 6 and 7 then '6-7'
								when note between 4 and 5 then '4-5'
								else '<4'
								end) as T
									order by case [оценки]
									  when '10' then 0
									  when '8-9' then 1
									  when '6-7' then 2
									  when '4-5' then 3
									  else 4
									  end
			

select t0.FACULTY, t1.PROFESSION, 2014-t1.YEAR_FIRST as [курс],
		round(avg(cast(p.note as float(2))),2)[средняя оценка]
from PROGRESS p join STUDENT s
	on p.IDSTUDENT = s.IDSTUDENT
	join GROUPS t1
	on t1.IDGROUP=s.IDGROUP
	join FACULTY t0
	on t0.FACULTY=t1.FACULTY
group by  t0.FACULTY,t1.PROFESSION,t1.YEAR_FIRST
order by [средняя оценка] desc




select t0.FACULTY, t1.PROFESSION, p.SUBJECT, 2014-t1.YEAR_FIRST as [курс],
		round(avg(cast(p.note as float(2))),2)[средняя оценка]
from PROGRESS p join STUDENT s
	on p.IDSTUDENT = s.IDSTUDENT
	join GROUPS t1
	on t1.IDGROUP=s.IDGROUP
	join FACULTY t0
	on t0.FACULTY=t1.FACULTY
where p.SUBJECT='СУБД' or p.SUBJECT='ОАиП'
group by  t0.FACULTY,t1.PROFESSION,t1.YEAR_FIRST,p.SUBJECT
order by [средняя оценка] desc



select t1.PROFESSION,p.SUBJECT,round(avg(cast(p.note as float(2))),2)
from PROGRESS p join STUDENT s
	on p.IDSTUDENT = s.IDSTUDENT
	join GROUPS t1
	on t1.IDGROUP=s.IDGROUP
	join FACULTY t0
	on t0.FACULTY=t1.FACULTY
where t0.FACULTY in('ПиМ')
group by t0.FACULTY,t1.PROFESSION,p.SUBJECT


select t1.PROFESSION,p.SUBJECT,round(avg(cast(p.note as float(2))),2)
from PROGRESS p join STUDENT s
	on p.IDSTUDENT = s.IDSTUDENT
	join GROUPS t1
	on t1.IDGROUP=s.IDGROUP
	join FACULTY t0
	on t0.FACULTY=t1.FACULTY
where t0.FACULTY in('ПиМ')
group by rollup( t0.FACULTY,t1.PROFESSION,p.SUBJECT)


select t1.PROFESSION,p.SUBJECT,round(avg(cast(p.note as float(2))),2)
from PROGRESS p join STUDENT s
	on p.IDSTUDENT = s.IDSTUDENT
	join GROUPS t1
	on t1.IDGROUP=s.IDGROUP
	join FACULTY t0
	on t0.FACULTY=t1.FACULTY
where t0.FACULTY in('ПиМ')
group by cube( t0.FACULTY,t1.PROFESSION,p.SUBJECT)


select GROUPS.PROFESSION, PROGRESS.SUBJECT,
round(avg(cast(PROGRESS.note as float(2))),2)[средняя оценка]
from PROGRESS join STUDENT
on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
join GROUPS
on GROUPS.IDGROUP=STUDENT.IDGROUP
where GROUPS.FACULTY='ТОВ'
group by GROUPS.PROFESSION,PROGRESS.SUBJECT
union
select GROUPS.PROFESSION, PROGRESS.SUBJECT,
round(avg(cast(PROGRESS.note as float(2))),2)[средняя оценка]
from PROGRESS join STUDENT
on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
join GROUPS
on GROUPS.IDGROUP=STUDENT.IDGROUP
where GROUPS.FACULTY='ПиМ'
group by GROUPS.PROFESSION,PROGRESS.SUBJECT




select GROUPS.PROFESSION, PROGRESS.SUBJECT,
round(avg(cast(PROGRESS.note as float(2))),2)[средняя оценка]
from PROGRESS join STUDENT
on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
join GROUPS
on GROUPS.IDGROUP=STUDENT.IDGROUP
where GROUPS.FACULTY='ТОВ'
group by GROUPS.PROFESSION,PROGRESS.SUBJECT
union all
select GROUPS.PROFESSION, PROGRESS.SUBJECT,
round(avg(cast(PROGRESS.note as float(2))),2)[средняя оценка]
from PROGRESS join STUDENT
on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
join GROUPS
on GROUPS.IDGROUP=STUDENT.IDGROUP
where GROUPS.FACULTY='ПиМ'
group by GROUPS.PROFESSION,PROGRESS.SUBJECT



select GROUPS.PROFESSION, PROGRESS.SUBJECT,
round(avg(cast(PROGRESS.note as float(2))),2)[средняя оценка]
from PROGRESS join STUDENT
on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
join GROUPS
on GROUPS.IDGROUP=STUDENT.IDGROUP
where GROUPS.FACULTY='ТОВ'
group by GROUPS.PROFESSION,PROGRESS.SUBJECT
intersect
select GROUPS.PROFESSION, PROGRESS.SUBJECT,
round(avg(cast(PROGRESS.note as float(2))),2)[средняя оценка]
from PROGRESS join STUDENT
on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
join GROUPS
on GROUPS.IDGROUP=STUDENT.IDGROUP
where GROUPS.FACULTY='ПиМ'
group by GROUPS.PROFESSION,PROGRESS.SUBJECT


select p1.SUBJECT,
(select count(*) from PROGRESS p2
where p1.NOTE=p2.NOTE and
p1.SUBJECT=p2.SUBJECT)[count]
from PROGRESS p1
group by p1.SUBJECT,p1.NOTE
having NOTE=8 or NOTE=9
order by [count]


USE G_MyBase

SELECT amount, max(price)
FROM Products
GROUP BY amount
HAVING max(price) <= 12;

SELECT type, count(type)[count]
FROM Deliveries
GROUP BY rollup(type);

SELECT * FROM Deliveries EXCEPT 
SELECT * FROM Deliveries WHERE amount < 3;

SELECT * FROM Deliveries WHERE product = 'exams'
--UNION
--UNION ALL
--EXCEPT
INTERSECT
SELECT * FROM Deliveries WHERE customer = 'BNTU'