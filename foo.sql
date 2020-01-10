-- Найти отделы, в которых хоть один сотрудник опаздывает больше 3-х раз в неделю.
select department
from rk3.employees
inner join rk3.timetable
on rk3.employees.id = rk3.timetable.employee_id
where rk3.late()

rk3.late(date_atr) OVER (partition by department) as cnt

-- Найти средний возраст сотрудников, не находящихся на рабочем месте 8 часов в день.
create function working_time()
returns table as
return (
    with enter as (
        select employee_id, date_atr, sum(DATEDIFF(MINUTE, 0, time_atr)) as entering
        from rk3.timetable
        where type = 1
        group by employee_id, date_atr
    ),
    exit as (
        select employee_id, date_atr, sum(DATEDIFF(MINUTE, 0, time_atr)) as exiting
        from rk3.timetable
        where type = 2
        group by employee_id, date_atr
    )
    select employee_id, (exit.exiting - enter.entering) as working_time
    from enter
    join exit
    on enter.employee_id = exit.employee_id and enter.date_atr = exit.date_atr
)
go;

-- !!
select entertable.employee_id, (exittable.exiting - COALESCE(entertable.entering, 0)) as working_time
avg(DATEDIFF(year, 0, birth)) as av_age
    where working_time < 8 * 60 and working_time >= 0


select id, as workingtime
from (
	select employee_id, date_atr, type, sum(DATEDIFF(MINUTE, 0, time_atr)) as sumtime
	from rk3.timetable
	group by employee_id, date_atr, type
)
group by employee_id, date_atr
LEAD(sumtime) OVER(partition by employee_id, date_atr ORDER BY type)

select avg(GETDATE() - birth) as av_age
from rk3.employees
inner join (
	select employee_id, date_atr, type, sum(DATEDIFF(MINUTE, 0, time_atr)) as sumtime
	from rk3.timetable
	group by employee_id, date_atr, type
)as sumtimetable
on rk3.employee.id = sumtimetable.employee_id
group by date_atr, id

on rk3.employees.id = rk3.timetable.employee_id


-- Вывести все отделы и количество сотрудников хоть раз опоздавших за всю историю учета.
select department, count(DISTINCT id) as number_of_late
from rk3.employees
join (
	select employee_id
	from rk3.timetable
	group by employee_id
	having min(time_atr) > '9:00'
)
on id = employee_id
group by department