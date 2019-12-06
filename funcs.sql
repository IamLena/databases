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
	+Langs.lang_code + '-' + Langs.country_code + '.psd'

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

	where Master.id = @master_id;
	return @filename;
end;
go

select dbo.get_psd(5) as new_psd
--drop function dbo.get_psd;

--2) Подставляемую табличную функцию
--3) Многооператорную табличную функцию
--4) Рекурсивную функцию или функцию с рекурсивным ОТВ B

--1) Хранимую процедуру без параметров или с параметрами
--2) Рекурсивную хранимую процедуру или хранимую процедур с рекурсивным ОТВ
--3) Хранимую процедуру с курсором
--4) Хранимую процедуру доступа к метаданным

--1) Триггер AFTER
--2) Триггер INSTEAD OF
