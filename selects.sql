use screenshots
go

--Инструкция SELECT, использующая предикат сравнения.
--имена дизайнеров старше 60
select first_name, second_name
from Designer
where age > 60
go

--Инструкция SELECT, использующая предикат BETWEEN. 
--все о мастерах измененных в время с 15 по 20 ноября 2019
select *
from Master
where mod_time between '2019-11-15' and '2019-11-20'
go

--Инструкция SELECT, использующая предикат LIKE. 
--все об устройствах содержащих подстроку macbook в своем названии
select code, ppi, width, height, name
from Device join Size
on size.id_size = Device.size
where name like '%macbook%'
go

--Инструкция SELECT, использующая предикат IN с вложенным подзапросом.
--вывести названия операционных систем,
--которые стоят на 38mm Apple Watch на созданных мастерах
select name
from OS
where id in
	(select id_os
	from OsDeviceMaster join Device
	on OsDeviceMaster.id_device = Device.id
	where name = '38mm Apple Watch')
go

--Инструкция SELECT, использующая предикат EXISTS с вложенным подзапросом.

--Инструкция SELECT, использующая предикат сравнения с квантором.
--выбрать те мастеры, что были сделаны позже, чем любой про 'erat' aka 'sport'
select *
from Master
where mod_time > ALL
	(select mod_time
	from Master
	where content like '%erat%')

--Инструкция SELECT, использующая агрегатные функции в выражениях столбцов.
--оригинал и количество зависимых от него мастеров
select origin_master_id, count(*) as _cnt_local_master
from Master
where origin_master_id is not null
group by origin_master_id

--Инструкция SELECT, использующая скалярные подзапросы в выражениях столбцов.
--количество проектров у каждого дизайнера
select nick,
	(select count(*)
	from Master
	where designer = Designer.id)
	as number_of_masters
from Designer
go

--Инструкция SELECT, использующая простое выражение CASE. 
select id,
case month(mod_time)
	when month(getdate()) then 'this month'
	when month(getdate()) - 1 then 'last month'
	else CAST(DATEDIFF(month, mod_time, Getdate()) AS varchar(5)) + 'months ago'
END AS 'When'
from Master

--Инструкция SELECT, использующая поисковое выражение CASE.
select Master.id,
case
	when width > 2500 then 'big'
	else 'small'
end as 'size'
from Size join Master
on Size.id_size = Master.size

--Создание новой временной локальной таблицы из результирующего набора данных инструкции SELECT.
select Master.id, Langs.lang_code, Langs.country_code, Master.mod_time, psd, origin_master_id
into #english
from Master join Langs
on Master.lang_id = Langs.id
where lang_code = 'en'

select * from #english

--Инструкция SELECT, использующая вложенные коррелированные 
--подзапросы в качестве производных таблиц в предложении FROM.
/*вывести имена дизайнеров младше 25, которые не работают*/
select nick, age
from 
	(select nick, age, id
	from Designer
	where age < 20) as youngdes
	left join 
	(select designer
	from Master) as des_master
	on youngdes.id = des_master.designer
	where des_master.designer is null

--Инструкция SELECT, использующая вложенные подзапросы с уровнем вложенности 3.
--вывести tiff тех скринов, которые сделаны на базе мастеров,
--сделаных для устройств размером больше 1000 по длине и ширине
select tiff
from ScreenShot
where id_master in
	(select Master.id
	from Master join OsDeviceMaster
	on Master.id = OsDeviceMaster.id_master
	where id_device in
		(select id
		from Device join
			(select *
			from Size
			where height > 1000 and width > 1000) as bigsize
		on bigsize.id_size = Device.size
		)
	)
go
		
--Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY, но без предложения HAVING.
select id_device, count(*) as number_of_masters
from OsDeviceMaster join Master
on OsDeviceMaster.id_master = Master.id
group by id_device

-- Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY и  предложения HAVING.
select origin_master_id, count(*) as cnt_local_master
from Master
where origin_master_id is not null
group by origin_master_id
having count(*) > 2

--Однострочная инструкция INSERT, выполняющая вставку в таблицу одной строки значений.
insert into Master (lang_id, content, mod_time, designer, psd, size, origin_master_id)
values (222,'porttitor lorem id ligula','2018-10-07 08:54:04',336,'dh1c4_26_2x_iqhos.psd',190,null);

--Многострочная инструкция INSERT, выполняющая вставку в таблицу результирующего набора данных вложенного подзапроса.
insert Size (width, height, scale)
select width * 11, height * 11, 11
from Size
where scale = 1

-- Простая инструкция UPDATE. 
update OsDeviceMaster
set id_os = 3
where id_master = 3

-- Инструкция UPDATE со скалярным подзапросом в предложении SET. 
update Master
set psd =
	(select Device.nick + '_' + Os.nick + '.psd'
	from Master join OsDeviceMaster
	on OsDeviceMaster.id_master = Master.id
	join Os
	on OsDeviceMaster.id_os = Os.id
	join Device
	on OsDeviceMaster.id_device = Device.id
	where Master.id = 4)
where Master.id = 4

-- Простая инструкция DELETE. 
delete Designer
where nick = 'abirt4'

-- Инструкция DELETE с вложенным коррелированным подзапросом в предложении WHERE.
/*удалить всех не работающих дизайнеров*/
delete Designer
where nick in 
(select nick
from Designer left join 
	(select designer
	from Master) as des_master
	on Designer.id = des_master.designer
	where des_master.designer is null
)

-- Инструкция SELECT, использующая простое обобщенное табличное выражение 
/*максималльное количество мастеров сделанное одним дизайнером*/
with Des_project_cnt (nick, number_of_masters)
as (
	select nick,
		(select count(*)
		from Master
		where designer = Designer.id)
		as number_of_masters
	from Designer
	)
select max(number_of_masters) as max
from Des_project_cnt

--Инструкция SELECT, использующая рекурсивное обобщенное табличное выражение. 
with otb_masters(id, psd, level)
as
(	select id, psd, 0 as level
	from Master
	where origin_master_id is null
	union all
	select Master.id, Master.psd, level + 1
	from otb_masters join Master
	on otb_masters.id = Master.origin_master_id
)
select *
from otb_masters

--Оконные функции. Использование конструкций MIN/MAX/AVG OVER() 
with cnt_langs(lang_code, country_code, cnt)
as (
	select lang_code, country_code,
	count(*) OVER (partition by lang_code) as cnt
	from Master join Langs
	on Master.lang_id = Langs.id
)
select lang_code, country_code,cnt
from cnt_langs

--Оконные фнкции для устранения дублей
with cnt_langs(lang_code, country_code,cnt, n)
as (
	select lang_code, country_code,
	count(*) OVER (partition by lang_code) as cnt,
	row_number() OVER (partition by lang_code order by (select null)) as n
	from Master join Langs
	on Master.lang_id = Langs.id
)
select lang_code, country_code,cnt
from cnt_langs
where n = 1
