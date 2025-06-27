-- Q1 yes it does matter

-- Q2
update  Employees
set     salary = salary * 0.8
where   age < 25;


-- Q3
update  Employees e
set     salary = salary * 1.1
from    WorksIn w
join    Departments d on w.did = d.did
where   d.dname = 'Sales';

-- Q4
create table Departments (
    did     integer,
    dname   text,
    budget  real,
    manager integer not null references Employees(eid),
    primary key (did)
);

-- Q5
create table Employees (
    eid     integer,
    ename   text,
    age     integer,
    salary  real,
    primary key (eid),
    constraint salaryCheck check (salary >= 15000)
);

-- Q6
-- Note: not going to work in standard sql and postgres!!!
-- use triggers instead which is later on...
-- this is valid in SQL2
create table WorksIn (
    eid     integer references Employees(eid),
    did     integer references Departments(did),
    percent real,
    primary key (eid,did)
    constraint MaxFullTimeCheck
        check (1 >= (
            select sum(w.percent)
            from WorksIn w
            where w.eid = eid
        ))
);

-- Q8
create table WorksIn (
    eid     integer references Employees(eid) on delete cascade,
    did     integer references Departments(did),
    percent real,
    primary key (eid,did)
);

-- Q9
alter table Departments
alter column manager drop not null;

/*
1. default raise an error on deletion
2. 'on delete cascade' which will delete all rows in WorksIn rows that 
refer to a department when that department is deleted
*/

create table WorksIn (
    eid     integer references Employees(eid) on delete cascade,
    did     integer references Departments(did) on delete cascade,
    percent real,
    primary key (eid,did)
);

-- Q12
select s.sname
from Suppliers s
join Catalog c on s.sid = c.sid
join Parts p on c.pid = p.pid
where p.colour = 'red';

-- Q13
select c.sid
from Catalog c
join Parts p on c.pid = p.pid
where p.colour = 'red' or p.colour = 'green';

-- Q14
select s.sid
from Suppliers s 
join Catalog c on c.sid = s.sid 
join Parts p on c.pid = p.pid
where p.colour = 'red' or s.address = '221 Packer Street';

-- Q15
(
    select s.sid 
    from Catalog c 
    join Parts p on c.pid = p.pid 
    where p.colour = 'red';
)
intersect
(
    select s.sid 
    from Catalog c 
    join Parts p on c.pid = p.pid 
    where p.colour = 'green';
)

-- Q16

-- Method 1
-- For each supplier, is the set of parts they supply equal to the
-- entire set of parts??
-- 1. find the set of all part ids
-- 2. find the set of all part ids supplied by the supplier
-- 3. find set difference between the two
-- 4. if that set is empty that means that supplier supplies every part

select s.sid 
from suppliers s
where not exists (
    (select p.pid from Parts p)
    except
    (select c.pid from catalog c where c.sid = s.sid)
);


-- Method 2
select c.sid
from Catalog c 
group by c.sid 
having count(p.pid) = (select count(*) from Parts)


-- Q17
-- Method 1
select s.sid 
from suppliers s
where not exists (
    (select p.pid from Parts p where p.colour = 'red')
    except
    (select c.pid from catalog c where c.sid = s.sid)
);

-- Method 2
select c.sid
from catalog c
join parts p on c.pid = p.pid 
where p.colour = 'red'
group by c.sid
having count(p.pid) = (select count(*) from parts where colour = 'red');

-- Q19
(
    select s.sid 
    from suppliers s
    where not exists (
        (select p.pid from Parts p where p.colour = 'red')
        except
        (select c.pid from catalog c where c.sid = s.sid)
    )
)
union
(
    select s.sid 
    from suppliers s
    where not exists (
        (select p.pid from Parts p where p.colour = 'green')
        except
        (select c.pid from catalog c where c.sid = s.sid)
    )
)

-- Q20
select c1.sid, c2.sid 
from Catalog c1 
join Catalog c2
where c1.pid = c2.pid and c1.sid != c2.sid and c1.cost > c2.cost;

-- Q21
select pid
from catalog
group by pid
having count(distinct sid) >= 2;

-- Q22
select c.pid
from catalog c 
join suppliers s on c.sid = s.sid 
where s.sname = 'Yosemite Sham'
    and c.cost = (
        select max(c2.cost)
        from catalog c2 
        join suppliers s2 on c2.sid = s2.sid 
        where s2.sname = 'Yosemite Sham'
    );