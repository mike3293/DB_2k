USE LAB5_UNIVER

--1
SELECT PULPIT.PULPIT_NAME
FROM PULPIT, FACULTY
WHERE PULPIT.FACULTY = FACULTY.FACULTY
	and
	PULPIT.FACULTY IN (select PROFESSION.FACULTY FROM PROFESSION WHERE PROFESSION.PROFESSION_NAME LIKE '%технология%' or PROFESSION.PROFESSION_NAME LIKE '%технологии%');

--2
SELECT PULPIT.PULPIT_NAME
FROM PULPIT inner join FACULTY
on  PULPIT.FACULTY = FACULTY.FACULTY
WHERE PULPIT.FACULTY IN (select PROFESSION.FACULTY FROM PROFESSION WHERE PROFESSION.PROFESSION_NAME LIKE '%технология%' or PROFESSION.PROFESSION_NAME LIKE '%технологии%');

--3
SELECT *
FROM PULPIT inner join FACULTY
on  PULPIT.FACULTY = FACULTY.FACULTY
inner join PROFESSION
ON PROFESSION.FACULTY = PULPIT.FACULTY 
WHERE PROFESSION.PROFESSION_NAME LIKE '%технология%' or PROFESSION.PROFESSION_NAME LIKE '%технологии%';

--4
 select AUDITORIUM_TYPE, max(AUDITORIUM_CAPACITY) as 'количество'
 from AUDITORIUM group by AUDITORIUM_TYPE;

 --5(кафедры есть на всех факультетах)
 Select FACULTY.FACULTY_NAME from FACULTY
 where  exists (select * from PULPIT
 where PULPIT.FACULTY = FACULTY.FACULTY)

 --6
 Select top 1
  (select avg(NOTE) from PROGRESS where SUBJECT like 'ОАиП')[ОАиП],
  (select avg(NOTE) from PROGRESS where SUBJECT like 'КГ')[КГ],
  (select avg(NOTE) from PROGRESS where SUBJECT like 'СУБД')[СУБД]
 from PROGRESS

 --7(выбираем студентов у которых оценки выше чем у студентов с id от 1000 до 1005)
 Select SUBJECT, IDSTUDENT, NOTE from PROGRESS
 where NOTE >= all (select NOTE from PROGRESS where IDSTUDENT between 1000 and 1005)

 --8(оценки у студента с id 1000: 6 и 8 значит результатом будут все строки где оценки выше 6)
 Select SUBJECT, IDSTUDENT, NOTE from PROGRESS
 where NOTE > any (select NOTE from PROGRESS where IDSTUDENT = 1000)

--день рождения в один день
select NAME, BDAY
from STUDENT
where BDAY in (SELECT  BDAY
				FROM STUDENT
				group by BDAY
				having COUNT(*) > 1)
order by BDAY asc;

