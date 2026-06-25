-- Q2
update  Employees
set     salary = salary *0.8
where   age < 25;


-- Q3
-- method 1
update Employees e
set     salary = salary *1.1
from    WorksIn w
join    Departments d on w.did = d.did 
where   w.eid = e.eid and d.dname = 'Sales';

-- method 2

update Employees e
set     salary = salary *1.1
where   eid in (
    select w.eid 
    from Departments d 
    join WorksIn w on d.did = w.did 
    where d.dname = 'Sales'
);




-- Q5
create table Employees (
    eid     integer,
    ename   text,
    age     integer,
    salary  real check (salary >= 15000),
    primary key (eid)
);



-- Q8
create table Departments (
      did     integer,
      dname   text,
      budget  real,
      manager integer references Employees(eid) on delete cascade,
      primary key (did)
);
create table WorksIn (
      eid     integer references Employees(eid) on delete cascade,
      did     integer references Departments(did),
      percent real,
      primary key (eid,did)
);

