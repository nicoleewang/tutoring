-- Q2
/*
A new government initiative to get more young people into 
work cuts the salary levels of all workers under 25 by 20%. 
Write an SQL statement to implement this policy change.
*/

update  Employees
set     salary = salary * 0.8
where   age < 25;


-- Q3
/*
The company has several years of growth and high profits, 
and considers that the Sales department is primarily responsible 
for this. Write an SQL statement to give all employees in the 
Sales department a 10% pay rise.
*/

update  Employees e
set     salary = salary * 1.1
from    WorksIn w 
join    Departments d on w.did = d.did 
where   w.eid = e.eid and d.name = 'Sales';


-- Q5
/*
Add a constraint to the CREATE TABLE statements above to 
ensure that no-one is paid less than the minimum wage of $15,000.
*/

create table Employees (
      eid     integer,
      ename   text,
      age     integer,
      salary  real check (salary >= 15000),
      primary key (eid)
);

-- Q8
/*
When an employee is removed from the database, it makes sense to 
also delete all of the records that show which departments he/she 
works for. Modify the CREATE TABLE statements above to ensure that 
this occurs.
*/

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
