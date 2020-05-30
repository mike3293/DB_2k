use LAB5_UNIVER;

--1. созд.XML в режиме PATH из TEACHER для преподов ИСиТ
--каждый столбец конфигурируется независимо с пом имени псевдонима этого столбца
go
select PULPIT.FACULTY[факультет/@код], TEACHER.PULPIT[факультет/кафедра/@код], 
    TEACHER.TEACHER_NAME[факультет/кафедра/преподаватель/@код]
	    from TEACHER inner join PULPIT
		    on TEACHER.PULPIT = PULPIT.PULPIT
			   where TEACHER.PULPIT = 'ИСиТ' for xml path, root('Список_преподавателей_кафедры_ИСиТ');




--2. режим AUTO: назв.ауд, тип, вмест + только лекционные ауд.
--применением вложенных элементов.
go
select	   AUDITORIUM.AUDITORIUM			[Аудитория],
           AUDITORIUM.AUDITORIUM_TYPE		[Наимменование_типа],
		   AUDITORIUM.AUDITORIUM_CAPACITY	[Вместимость] 
		   from AUDITORIUM join AUDITORIUM_TYPE
		     on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
	where AUDITORIUM.AUDITORIUM_TYPE = 'ЛК' for xml AUTO, root('Список_аудиторий'), elements;



--3. д-е о трех новых дисциплинах
--сист.ф-я OPENXML, констр. INSERT... SELECT
--имена его атрибутов совпадают с именами столбцов результирующего набора

go
declare @h int = 0,
@sbj varchar(3000) = '<?xml version="1.0" encoding="windows-1251" ?>
                      <дисциплины>
					     <дисциплина код="КГиГ" название="Компьютерная геометрия и графика" кафедра="ИСиТ" />
						 <дисциплина код="ОЗИ" название="Основы защиты информации" кафедра="ИСиТ" />
						 <дисциплина код="МПп" название="Математическое программирование п" кафедра="ИСиТ" />
					  </дисциплины>';
exec sp_xml_preparedocument @h output, @sbj;
insert SUBJECT select[код], [название], [кафедра] from openxml(@h, '/дисциплины/дисциплина',0)
    with([код] char(10), [название] varchar(100), [кафедра] char(20));

	select * from SUBJECT;
delete from SUBJECT where SUBJECT.SUBJECT='КГиГ' or SUBJECT.SUBJECT='ОЗИ' or SUBJECT.SUBJECT='МПп'



--4
-- Ошибка, т.к. подключена схема
insert into STUDENT(IDGROUP, NAME, BDAY, INFO)
	values(22, 'Городилов М.П.', '29.08.2000',
	'<студент>
		<паспорт серия="АВ" номер="2864982" дата="31.07.2014" />
		<телефон>375298213235</телефон>
		<адрес>
			<страна>Беларусь</страна>
			<город>Брест</город>
			<улица>Колесника</улица>
			<дом>4</дом>
			<квартира>54</квартира>
		</адрес>
	</студент>');
select * from STUDENT where NAME = 'Городилов М.П.';
update STUDENT set INFO = '<студент>
					           <паспорт серия="AB" номер="2864982" дата="31.07.2014" />
						       <телефон>375298213235</телефон>
							   <адрес>
								  <страна>Беларусь</страна>
								  <город>Брест</город>
								  <улица>Колесника</улица>
	         					  <дом>4</дом>
								  <квартира>54</квартира>
								</адрес>
							</студент>' where NAME='Городилов М.П.'
select NAME[ФИО], INFO.value('(студент/паспорт/@серия)[1]', 'char(2)')[Серия паспорта],
	INFO.value('(студент/паспорт/@номер)[1]', 'varchar(20)')[Номер паспорта],
	INFO.query('/студент/адрес')[Адрес]
		from  STUDENT
			where NAME = 'Городилов М.П.';       
delete STUDENT where NAME = 'Городилов М.П.';    


--5. измен STUDENT: чтобы значения типизированного столбца с именем INFO контролировались коллекцией XML-схем 
go
create xml schema collection Student as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
   elementFormDefault="qualified"
   xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xs:element name="студент">
<xs:complexType><xs:sequence>
<xs:element name="паспорт" maxOccurs="1" minOccurs="1">
  <xs:complexType>
    <xs:attribute name="серия" type="xs:string" use="required" />
    <xs:attribute name="номер" type="xs:unsignedInt" use="required"/>
    <xs:attribute name="дата"  use="required">
	<xs:simpleType>  <xs:restriction base ="xs:string">
		<xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
	 </xs:restriction> 	</xs:simpleType>
     </xs:attribute>
  </xs:complexType>
</xs:element>
<xs:element maxOccurs="3" name="телефон" type="xs:unsignedInt"/>
<xs:element name="адрес">   <xs:complexType><xs:sequence>
   <xs:element name="страна" type="xs:string" />
   <xs:element name="город" type="xs:string" />
   <xs:element name="улица" type="xs:string" />
   <xs:element name="дом" type="xs:string" />
   <xs:element name="квартира" type="xs:string" />
</xs:sequence></xs:complexType>  </xs:element>
</xs:sequence></xs:complexType>
</xs:element></xs:schema>';

alter table STUDENT alter column INFO xml(Student);
drop XML SCHEMA COLLECTION Student;
select Name, INFO from STUDENT where NAME='Городилов М.П.'



use G_MyBase

go
select	   Deliveries.date			[Дата],
           Deliveries.amount		[Кол-во],
		   Deliveries.sell_price	[Стоимость] 
		   from Deliveries
			where Deliveries.type = 'fast' for xml AUTO, root('Список_быстрых_доставок'), elements;