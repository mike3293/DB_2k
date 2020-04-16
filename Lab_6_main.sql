USE LAB5_UNIVER

--1
SELECT PULPIT.PULPIT_NAME
FROM PULPIT, FACULTY
WHERE PULPIT.FACULTY = FACULTY.FACULTY
	and
	PULPIT.FACULTY IN (select PROFESSION.FACULTY FROM PROFESSION WHERE PROFESSION.PROFESSION_NAME LIKE '%����������%' or PROFESSION.PROFESSION_NAME LIKE '%����������%');

--2
SELECT PULPIT.PULPIT_NAME
FROM PULPIT inner join FACULTY
on  PULPIT.FACULTY = FACULTY.FACULTY
WHERE PULPIT.FACULTY IN (select PROFESSION.FACULTY FROM PROFESSION WHERE PROFESSION.PROFESSION_NAME LIKE '%����������%' or PROFESSION.PROFESSION_NAME LIKE '%����������%');

--3
SELECT *
FROM PULPIT inner join FACULTY
on  PULPIT.FACULTY = FACULTY.FACULTY
inner join PROFESSION
ON PROFESSION.FACULTY = PULPIT.FACULTY 
WHERE PROFESSION.PROFESSION_NAME LIKE '%����������%' or PROFESSION.PROFESSION_NAME LIKE '%����������%';

--4
 select AUDITORIUM_TYPE, max(AUDITORIUM_CAPACITY) as '����������'
 from AUDITORIUM group by AUDITORIUM_TYPE;

 --5(������� ���� �� ���� �����������)
 Select FACULTY.FACULTY_NAME from FACULTY
 where  exists (select * from PULPIT
 where PULPIT.FACULTY = FACULTY.FACULTY)

 --6
 Select top 1
  (select avg(NOTE) from PROGRESS where SUBJECT like '����')[����],
  (select avg(NOTE) from PROGRESS where SUBJECT like '��')[��],
  (select avg(NOTE) from PROGRESS where SUBJECT like '����')[����]
 from PROGRESS

 --7(�������� ��������� � ������� ������ ���� ��� � ��������� � id �� 1000 �� 1005)
 Select SUBJECT, IDSTUDENT, NOTE from PROGRESS
 where NOTE >= all (select NOTE from PROGRESS where IDSTUDENT between 1000 and 1005)

 --8(������ � �������� � id 1000: 6 � 8 ������ ����������� ����� ��� ������ ��� ������ ���� 6)
 Select SUBJECT, IDSTUDENT, NOTE from PROGRESS
 where NOTE > any (select NOTE from PROGRESS where IDSTUDENT = 1000)

--���� �������� � ���� ����
select NAME, BDAY
from STUDENT
where BDAY in (SELECT  BDAY
				FROM STUDENT
				group by BDAY
				having COUNT(*) > 1)
order by BDAY asc;

