use RK3
go;
create schema rk3
go;
create table rk3.employees (
	id int not null,
	fio varchar(30),
	birth date,
	department varchar(20)
)
go;
create table rk3.timetable(
	employee_id int,
	date_atr date,
	weekday varchar(10),
	time_atr time,
	type int)
go;
alter table rk3.employees
add constraint pk_emp primary key (id)
go;
alter table rk3.timetable
add constraint fk_emp foreign key (employee_id) references rk3.employees (id)
go;
insert into rk3.employees(id, fio, birth, department)
values
(1, 'Ivanov Ivan Ivanovich', '19900925', 'IT'),
(2, 'Petrov Pert Petrovich', '19871112', 'accounting')
go;
insert into rk3.timetable(employee_id, date_atr, weekday, time_atr, type)
values
(1,'20181214', 'Saturday', '9:00', 1),
(1,'20181214', 'Saturday', '9:20', 2),
(1,'20181214', 'Saturday', '9:25', 1),
(2,'20181214', 'Saturday', '9:05', 1),
(2,'20181214', 'Saturday', '20:00', 2),
(1,'20181214', 'Saturday', '15:00', 2)
go;
create function rk3.late (@date date)
returns int
begin
	declare @number int;
	select @number = count(DISTINCT employee_id)
    from rk3.employees
    inner join rk3.timetable
    on rk3.employees.id = rk3.timetable.employee_id
    where date_atr = @date
    group by employee_id
    having min(time_atr) > '9:00'
	return @number;
end
go;
create function late_in_dep()
returns table as
return (
    select department, count(DISTINCT id) as number_of_late
    from rk3.employees
    join (
        select employee_id
        from rk3.timetable
        group by employee_id
        having min(time_atr) > '9:00'
    ) as late
    on rk3.employees.id = late.employee_id
    group by department
)
go;
create function ave_age_notworking()
returns table as
return (    
    with entertable as (
        select employee_id as id1, date_atr as date1, sum(DATEDIFF(MINUTE, 0, time_atr)) as entering
        from rk3.timetable
        where type = 1
        group by employee_id, date_atr
    ),
    exittable as (
        select employee_id as id2, date_atr as date2, sum(DATEDIFF(MINUTE, 0, time_atr)) as exiting
        from rk3.timetable
        where type = 2
        group by employee_id, date_atr
    )
    select avg(DATEDIFF(year,birth, getdate())) as av_age
    from rk3.employees
    join (
        select id1, (exittable.exiting - entertable.entering) as working_time
        from entertable
        left join exittable
        on entertable.id1 = exittable.id2 and entertable.date1 = exittable.date2
    ) as tmp
    on tmp.id1 = rk3.employees.id
    where working_time < 8 * 60 and working_time >= 0
)
go;