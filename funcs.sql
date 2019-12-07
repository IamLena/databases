use screenshots
go

--1) Скалярную функцию
create function get_psd
(@master_id int)
returns varchar(70)
begin
	declare @filename varchar(70);

	select @filename = Device.nick + '-'
	+ Cast(Size.scale as varchar) + 'x-'
	+ Os.nick + '-' + Master.short_cont + '-'
	+Langs.lang_code + '-' + Langs.country_code + '-by_' + Designer.nick + '.psd'

	from OsDeviceMaster join Device
	on OsDeviceMaster.id_device = Device.id
	join Os
	on Os.id = OsDeviceMaster.id_os
	join Master
	on Master.id = OsDeviceMaster.id_master
	join Size
	on Size.id_size = Master.size
	join Langs
	on Langs.id = Master.lang_id
	join Designer
	on Master.designer = Designer.id

	where Master.id = @master_id;
	return @filename;
end;
go

select dbo.get_psd(5) as new_psd
go
--drop function dbo.get_psd;

--2) Подставляемую табличную функцию
--все скрины и их масштаб сделанный на мастере определенного id
create function showScreensOfMaster
(@master_id int)
returns table
as
return (
	select ScreenShot.*, Size.scale
	from ScreenShot join Size
	on ScreenShot.size = Size.id_size
	where id_master = @master_id
);
go

select * from showScreensOfMaster(20)
go

--3) Многооператорную табличную функцию
create function getsize (@object varchar(10), @object_id int)
returns @sizetable table (width int, height int)
as
begin
	if (@object = 'device')
	begin
		insert @sizetable (width, height)
		select width, height
		from Device join Size
		on Device.size = Size.id_size
		where Device.id = @object_id
	end
	else if (@object = 'master')
	begin
		insert @sizetable (width, height)
		select width, height
		from Master join Size
		on Master.size = Size.id_size
		where Master.id = @object_id
	end
	else if (@object = 'screenshot')
	begin
		insert @sizetable (width, height)
		select width, height
		from ScreenShot join Size
		on ScreenShot.size = Size.id_size
		where ScreenShot.id = @object_id
	end
	return
end;
go

drop function dbo.getsize;

select * from getsize('device', 2)
select * from getsize('master', 2)
select * from getsize('screenshot', 2)
go

--4) Рекурсивную функцию или функцию с рекурсивным ОТВ B
create function show_origins
(@id_master int)
returns @OriginPath table
	(id int,
	lang_id int,
	short_cont nvarchar(20),
	mod_time datetime,
	designer int,
	psd nvarchar(70),
	size int,
	origin_master_id int,
	level int)
as
begin
	with otb_masters(id, lang_id, short_cont, mod_time, designer, psd, size, origin_master_id, level)
	as
	(	select id, lang_id, short_cont, mod_time, designer, psd, size,  origin_master_id, 0 as level
		from Master
		where id = @id_master
		union all
		select Master.id, Master.lang_id, Master.short_cont, Master.mod_time, Master.designer, Master.psd, Master.size, Master.origin_master_id, level + 1
		from otb_masters join Master
		on otb_masters.origin_master_id = Master.id
	)
	insert @OriginPath (id, lang_id, short_cont, mod_time, designer, psd, size, origin_master_id, level)
	select *
	from otb_masters
	return
end;
go

--drop function show_origins;
select * from dbo.show_origins(220);
go

--1) Хранимую процедуру без параметров или с параметрами
create procedure update_psd(@master_id int)
as
begin
	update Master
	set psd = dbo.get_psd(@master_id)
	where Master.id = @master_id
end
go
execute update_psd 4
go

--2) Рекурсивную хранимую процедуру или хранимую процедуру с рекурсивным ОТВ
create procedure updateAllPsd (@id int, @maxid int)
as
begin
	IF (@id <= @maxid)
	begin
		update Master
		set psd = dbo.get_psd(@id)
		where Master.id = @id

		set @id = @id + 1
		execute updateAllPsd @id, @maxid
	end
	return
end
go

execute updateAllPsd 1, 5;
go

--3) Хранимую процедуру с курсором
create procedure updatePSDcursor
as
begin
DECLARE @curid int
DECLARE master_cursor CURSOR FOR
SELECT id FROM Master

OPEN master_cursor
FETCH NEXT FROM master_cursor INTO @curid
WHILE @@FETCH_STATUS = 0
BEGIN
   update Master
	set psd = dbo.get_psd(@curid)
	where Master.id = @curid
FETCH NEXT FROM master_cursor INTO @curid END
CLOSE master_cursor
DEALLOCATE master_cursor
end

execute updatePSDcursor
go

select * from Master
go

--4) Хранимую процедуру доступа к метаданным
create procedure cntrows as
begin
	SELECT o.name, i.rowcnt 
	FROM sysindexes AS i INNER JOIN sys.tables AS o
	ON i.id = o.object_id 
	WHERE i.indid < 2  AND OBJECTPROPERTY(o.object_id, 'IsMSShipped') = 0
	ORDER BY o.name
end

execute cntrows
go

--1) Триггер AFTER
CREATE TRIGGER triggerAfterInsertDesigner
ON Designer AFTER Insert
AS 
begin
	declare @msg nvarchar(100)
	set @msg = 'new designer ' +
	(select first_name + ' ' + second_name
	from Inserted) + ' is ready for work!'
	print(@msg)
end
go

drop trigger triggerAfterInsertDesigner
go

insert into designer(nick, first_name, second_name, email, gender, age)
values('ivanov', 'Ivan', 'Ivanov', 'Ivan@gmail.com', 'M', 32)
go
--delete from Designer where nick = 'ivanov'

--2) Триггер INSTEAD OF
CREATE TRIGGER DenyInsert 
ON Device
INSTEAD OF INSERT
AS
BEGIN
    RAISERROR('You have not permission to insert in this table.',10,1);
END;

insert into Device(code, size, ppi, name, nick)
values ('jdjshdj', 2, 333, 'dsds', 'fddf')

select * from Device
