use G_MyBase;

alter table Deliveries add [type] NVARCHAR(10) CHECK ([type] IN('fast', 'slow'));

alter table Deliveries drop column [type];