-- Q1)yes

-- Q2)
update  Employees
set     salary = salary * 0.8
where   age < 25;

-- Q3)
update  Employees e
set     salary = salary * 1.1
from    WorksIn w
join    Departments d on w.did = d.did
where   e.eid = w.eid and d.dname = 'Sales';

-- 
/*
T1
(1, 2)
(2, 3)

T2
(1, 3)
(3, 4)

Result T1 left outer join T2
(1, 2, 3)
(2, 3, null)

Result join
(1, 2, 3)

Result T1 right outer join T2
(1, 3, 2)
(3, 4, null)
*/

-- Q4
create table Departments (
    did     integer primary key,
    dname   text,
    budget  real,
    manager integer not null references Employees(eid)
);


-- Q5
create table Employees (
    eid     integer,
    ename   text,
    age     integer,
    salary  real check (salary >= 150000),
    primary key (eid)
);

-- Q6
-- Note: not gonna work when u run in in ur prostgres server :(
-- Works SQL2
create table WorksIn (
    eid     integer references Employees(eid),
    did     integer references Departments(did),
    percent real,
    primary key (eid,did),
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

-- Q10
/*
1. default behaviour: raise an error when deleting soemthing that's being refered
   to by somethign else
2. on delete cascade: automatically delete all WorksIn rows that refer to a deparment
   when the department is deleted
*/

-- Q11
/*
1. raise an error - ur not gonna delete it
2. rows 1, 5, 7 deleted in WorksIn table
*/

-- Q12
select  s.sname
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
join Catalog c on s.sid = c.sid 
join Parts p on c.pid = p.pid
where p.colour = 'red' or s.address = '221 Packer Street';

-- Q15
(
    select s.sid 
    from Catalog c 
    join Parts p on c.pid = p.pid 
    where p.colour = 'red'
)
intersect
(
    select s.sid 
    from Catalog c 
    join Parts p on c.pid = p.pid 
    where p.colour = 'green'
)

-- Q16
/*
Method 1:

rephrased: for each supplier, is the set of parts they supply equal
tothe entrie set of parts???
2 - 1 = 1
2 - 2 = 0
1. find set of all part ids
2. find set of all part ids supplied by the supplier
3. find teh difference between 1. and 2.
4. if the set is empty then the supplier supplies every part
*/

select s.sid 
from suppliers s
where not exists (
    (select p.pid from Parts p)
    except
    (select c.pid from catalog c where c.sid = s.sid)
)
/*
1. (1, 2), (2, 3)
2. (1, 2)

1. - 2. = (2,3)

2. - 1. = nothing
*/

/*
Method 2: give me the suppliers whose number of supplied parts is equal
to the total number of parts
*/
select c.sid 
from Catalog c
group by c.sid 
having count(c.pid) = (select count(*) from Parts)

-- Q17
select s.sid 
from suppliers s
where not exists (
    (select p.pid from Parts p where p.colour = 'red')
    except
    (select c.pid from catalog c where c.sid = s.sid)
)


-- Q18
select s.sid 
from suppliers s
where not exists (
    (select p.pid from Parts p where p.colour = 'red' or p.colour = 'green')
    except
    (select c.pid from catalog c where c.sid = s.sid)
)

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
from Catalog 
group by pid 
having count(distinct sid) >= 2;

-- Q22
select c.pid
from catalog c 
join suppliers on c.sid = s.sid 
where s.name = 'Yosemite Sham'
    and c.cost = (
        select max(c2.cost)
        from catalog c2 
        join suppliers s2 on c2.sid = s2.sid
        where s2.sname = 'Yosemite Sham'
    );