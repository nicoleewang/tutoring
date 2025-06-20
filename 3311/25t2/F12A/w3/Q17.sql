create table Employees (
    SSN         integer primary key,
    birthdate   date,
    name        text
    -- department  text references Departments(name)
);

create table Dependents (
    employee    integer references Employees(SSN),
    name        text,
    birthdate   date,
    relation    text,
    primary key (employee, name)
)

create table Departments (
    name        text primary key,
    phone       integer,
    location    text,
    manager     integer references Employees(SSN),
    mdate       date
);

alter table Employees add
    foreign key department 
    references Departments(name);